/**
 * Modes Extension — Plan / Pair / None
 *
 * Shift+Tab cycles: None → Plan → Pair → None
 *
 * Plan mode: read-only exploration, tool restrictions, plan extraction
 * Pair mode: guide verbally, no code output by the LLM
 * None: normal operation
 */

import type { AgentMessage } from "@earendil-works/pi-agent-core";
import type { AssistantMessage, TextContent } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Key } from "@earendil-works/pi-tui";
import { extractTodoItems, isSafeCommand, markCompletedSteps, type TodoItem } from "./utils.ts";

type Mode = "none" | "plan" | "pair";

const MODE_LABEL: Record<Mode, string> = {
	none: "",
	plan: "⏸ plan",
	pair: " pair",
};

const MODE_ORDER: Mode[] = ["none", "plan", "pair"];

interface ModesState {
	mode: Mode;
	planTodos: TodoItem[];
	planExecuting: boolean;
	toolsBeforeMode: string[] | undefined;
}

// ── Tools managed by the extension ──
const PLAN_MODE_TOOLS = ["read", "bash", "grep", "find", "ls", "questionnaire"];
const NORMAL_MODE_TOOLS = ["read", "bash", "edit", "write"];
const PLAN_DISABLED = new Set(["edit", "write"]);
const PLAN_MANAGED = new Set([...PLAN_MODE_TOOLS, ...NORMAL_MODE_TOOLS]);

export default function modesExtension(pi: ExtensionAPI): void {
	let mode: Mode = "none";
	let planTodos: TodoItem[] = [];
	let planExecuting = false;
	let toolsBeforeMode: string[] | undefined;

	pi.registerFlag("plan", {
		description: "Start in plan mode (read-only exploration)",
		type: "boolean",
		default: false,
	});

	pi.registerFlag("pair", {
		description: "Start in pair programming mode (guide, don't write code)",
		type: "boolean",
		default: false,
	});

	// ── Helpers ──

	function fmtMode(m: Mode): string {
		return MODE_LABEL[m];
	}

	function isPlan(): boolean {
		return mode === "plan" || planExecuting;
	}

	function updateStatus(ctx: ExtensionContext): void {
		if (planExecuting && planTodos.length > 0) {
			const done = planTodos.filter((t) => t.completed).length;
			ctx.ui.setStatus("modes", ctx.ui.theme.fg("accent", `📋 ${done}/${planTodos.length}`));
		} else if (mode !== "none") {
			ctx.ui.setStatus("modes", ctx.ui.theme.fg(mode === "plan" ? "warning" : "accent", fmtMode(mode)));
		} else {
			ctx.ui.setStatus("modes", undefined);
		}

		// Todo widget
		if (planExecuting && planTodos.length > 0) {
			const lines = planTodos.map((item) => {
				if (item.completed) {
					return (
						ctx.ui.theme.fg("success", "☑ ") + ctx.ui.theme.fg("muted", ctx.ui.theme.strikethrough(item.text))
					);
				}
				return `${ctx.ui.theme.fg("muted", "☐ ")}${item.text}`;
			});
			ctx.ui.setWidget("plan-todos", lines);
		} else {
			ctx.ui.setWidget("plan-todos", undefined);
		}
	}

	function persist(): void {
		pi.appendEntry("modes-state", {
			mode,
			planTodos,
			planExecuting,
			toolsBeforeMode,
		} satisfies ModesState);
	}

	// ── Tool management ──

	function uniqueTools(names: string[]): string[] {
		return [...new Set(names)];
	}

	function getPlanTools(active: string[]): string[] {
		return uniqueTools([...active.filter((n) => !PLAN_DISABLED.has(n)), ...PLAN_MODE_TOOLS]);
	}

	function getNormalTools(active: string[]): string[] {
		return uniqueTools([...NORMAL_MODE_TOOLS, ...active.filter((n) => !PLAN_MANAGED.has(n))]);
	}

	function enablePlanTools(): void {
		if (toolsBeforeMode === undefined) toolsBeforeMode = pi.getActiveTools();
		pi.setActiveTools(getPlanTools(toolsBeforeMode));
	}

	function restoreNormalTools(): void {
		pi.setActiveTools(toolsBeforeMode ?? getNormalTools(pi.getActiveTools()));
		toolsBeforeMode = undefined;
	}

	// ── Mode switching ──

	function setMode(m: Mode, ctx: ExtensionContext): void {
		const prev = mode;

		// Leave previous mode
		if (prev === "plan" || planExecuting) {
			restoreNormalTools();
		}
		planTodos = [];
		planExecuting = false;

		mode = m;

		// Enter new mode
		if (mode === "plan") {
			enablePlanTools();
			ctx.ui.notify("Plan mode — read-only. Build a numbered plan.");
		} else if (mode === "pair") {
			ctx.ui.notify("Pair mode — I guide, you drive. No code from me.");
		} else {
			ctx.ui.notify("Normal mode — full access restored.");
		}

		updateStatus(ctx);
		persist();
	}

	function cycleMode(ctx: ExtensionContext): void {
		const idx = MODE_ORDER.indexOf(mode);
		const next = MODE_ORDER[(idx + 1) % MODE_ORDER.length];
		setMode(next, ctx);
	}

	function togglePlan(ctx: ExtensionContext): void {
		setMode(mode === "plan" ? "none" : "plan", ctx);
	}

	function togglePair(ctx: ExtensionContext): void {
		setMode(mode === "pair" ? "none" : "pair", ctx);
	}

	// ── Commands ──

	pi.registerCommand("plan", {
		description: "Toggle plan mode (read-only exploration)",
		handler: async (_args, ctx) => togglePlan(ctx),
	});

	pi.registerCommand("pair", {
		description: "Toggle pair programming mode (guide, don't write code)",
		handler: async (_args, ctx) => togglePair(ctx),
	});

	pi.registerCommand("mode", {
		description: "Show current mode",
		handler: async (_args, ctx) => {
			if (mode === "none") ctx.ui.notify("Mode: normal", "info");
			else ctx.ui.notify(`Mode: ${fmtMode(mode)}`, "info");
		},
	});

	pi.registerCommand("todos", {
		description: "Show plan todo list",
		handler: async (_args, ctx) => {
			if (planTodos.length === 0) {
				ctx.ui.notify("No plan todos.", "info");
				return;
			}
			const list = planTodos.map((t, i) => `${i + 1}. ${t.completed ? "✓" : "○"} ${t.text}`).join("\n");
			ctx.ui.notify(`Plan:\n${list}`, "info");
		},
	});

	// ── Shortcut — Shift+Tab cycles modes ──

	pi.registerShortcut(Key.shift("tab"), {
		description: "Cycle modes: none → plan → pair → none",
		handler: async (ctx) => cycleMode(ctx),
	});

	// ── Plan mode: block destructive bash ──

	pi.on("tool_call", async (event) => {
		if (!isPlan() || event.toolName !== "bash") return;
		const cmd = event.input.command as string;
		if (!isSafeCommand(cmd)) {
			return {
				block: true,
				reason: `Plan mode: command blocked (read-only). Use /plan or /pair to switch modes.\nCommand: ${cmd}`,
			};
		}
	});

	// ── Filter stale mode context (keep the current mode's own markers) ──

	pi.on("context", async (event) => {
		if (isPlan()) return;

		// Only strip markers for modes that are NOT active. Without this, the
		// freshly injected [PAIR MODE ACTIVE] message would be filtered out
		// before it ever reaches the model and pair mode would never apply.
		const staleCustom = new Set<string>();
		const staleNeedles: string[] = [];
		if (mode === "none") {
			staleCustom.add("plan-mode-context");
			staleCustom.add("plan-execution-context");
			staleCustom.add("pair-mode-context");
			staleNeedles.push("[PLAN MODE ACTIVE]", "[EXECUTING PLAN", "[PAIR MODE ACTIVE]");
		} else if (mode === "pair") {
			staleCustom.add("plan-mode-context");
			staleCustom.add("plan-execution-context");
			staleNeedles.push("[PLAN MODE ACTIVE]", "[EXECUTING PLAN");
		}

		return {
			messages: event.messages.filter((m) => {
				const msg = m as AgentMessage & { customType?: string };
				if (msg.customType && staleCustom.has(msg.customType)) return false;
				if (msg.role !== "user") return true;
				const content = msg.content;
				if (typeof content === "string") return !staleNeedles.some((n) => content.includes(n));
				if (Array.isArray(content)) {
					return !content.some(
						(c) => c.type === "text" && (c as TextContent).text && staleNeedles.some((n) => (c as TextContent).text!.includes(n)),
					);
				}
				return true;
			}),
		};
	});

	// ── Inject behavior instructions ──

	pi.on("before_agent_start", async () => {
		if (planExecuting && planTodos.length > 0) {
			const remaining = planTodos.filter((t) => !t.completed);
			const todoList = remaining.map((t) => `${t.step}. ${t.text}`).join("\n");
			return {
				message: {
					customType: "plan-execution-context",
					content: `[EXECUTING PLAN - Full tool access enabled]

Remaining steps:
${todoList}

Execute each step in order.
After completing a step, include a [DONE:n] tag in your response.`,
					display: false,
				},
			};
		}

		if (mode === "plan") {
			return {
				message: {
					customType: "plan-mode-context",
					content: `[PLAN MODE ACTIVE]
You are in plan mode — read-only exploration for safe code analysis.

Restrictions:
- Built-in edit and write tools are disabled
- Other currently active tools remain available
- Bash is restricted to an allowlist of read-only commands

Create a detailed numbered plan under a "Plan:" header:

Plan:
1. First step description
2. Second step description
...

Do NOT attempt to make changes — just describe what you would do.`,
					display: false,
				},
			};
		}

		if (mode === "pair") {
			return {
				message: {
					customType: "pair-mode-context",
					content: `[PAIR MODE ACTIVE]
You are in pair programming mode. The user drives; you advise. You never write code for them.

Hard rules:
- NEVER use the edit or write tools, for any reason. No exceptions, no "just one line".
- Code snippets ARE allowed when used as illustrative examples for learning (e.g. showing example code that the user then implements themselves in their own way). Do not hand over full implementations of the user's own tasks. NEVER output runnable commands.
- Do not run commands that modify files (no formatters, no file writes, no migrations).
- Read-only exploration is fine: reading files, searching, running builds/tests to check the user's code.
- Guide the user step by step. Point to specific files and line numbers.
- Explain what needs to change and why. Describe the approach in plain language.
- Ask questions to engage the user and let them drive.
- End every reply with a question that moves the work forward.

If you catch yourself about to write or edit code, stop and describe instead.
The user writes the code — you advise and review.

Your job is to be a thoughtful senior developer looking over their shoulder.`,
					display: false,
				},
			};
		}
	});

	// ── Track plan execution progress ──

	pi.on("turn_end", async (event, ctx) => {
		if (!planExecuting || planTodos.length === 0) return;
		const msg = event.message;
		if (msg.role !== "assistant" || !Array.isArray(msg.content)) return;
		const text = msg.content
			.filter((b): b is TextContent => b.type === "text")
			.map((b) => b.text)
			.join("\n");
		if (markCompletedSteps(text, planTodos) > 0) {
			updateStatus(ctx);
		}
		persist();
	});

	// ── Plan extraction from assistant responses ──

	pi.on("agent_end", async (event, ctx) => {
		// Completion check
		if (planExecuting && planTodos.length > 0 && planTodos.every((t) => t.completed)) {
			const list = planTodos.map((t) => `~~${t.text}~~`).join("\n");
			pi.sendMessage(
				{ customType: "plan-complete", content: `**Plan Complete!** ✓\n\n${list}`, display: true },
				{ triggerTurn: false },
			);
			planExecuting = false;
			planTodos = [];
			updateStatus(ctx);
			persist();
			return;
		}

		if (mode !== "plan" || !ctx.hasUI) return;

		// Extract todos from last assistant message
		const lastAssistant = [...event.messages].reverse().find((m) => m.role === "assistant" && Array.isArray(m.content)) as
			| AssistantMessage
			| undefined;
		if (!lastAssistant) return;

		const text = lastAssistant.content
			.filter((b): b is TextContent => b.type === "text")
			.map((b) => b.text)
			.join("\n");
		const extracted = extractTodoItems(text);
		if (extracted.length === 0) return;

		planTodos = extracted;
		persist();

		const todoListText = planTodos.map((t, i) => `${i + 1}. ☐ ${t.text}`).join("\n");
		const planMsg = {
			customType: "plan-todo-list",
			content: `**Plan Steps (${planTodos.length}):**\n\n${todoListText}`,
			display: true,
		};

		const choice = await ctx.ui.select("Plan mode — what next?", [
			"Execute the plan (track progress)",
			"Stay in plan mode",
			"Refine the plan",
		]);

		if (choice?.startsWith("Execute")) {
			const first = planTodos[0];
			if (!first) return;

			mode = "none"; // execution uses full tool access
			planExecuting = true;
			restoreNormalTools();
			updateStatus(ctx);
			persist();

			const remaining = planTodos.map((t) => `${t.step}. ${t.text}`).join("\n");
			pi.sendMessage(planMsg, { deliverAs: "followUp" });
			pi.sendMessage(
				{
					customType: "plan-mode-execute",
					content: `Execute the plan.\n\nRemaining steps:\n${remaining}\n\nStart with: ${first.text}\nAfter completing a step, include a [DONE:n] tag.`,
					display: true,
				},
				{ triggerTurn: true, deliverAs: "followUp" },
			);
		} else if (choice === "Refine the plan") {
			const refinement = await ctx.ui.editor("Refine the plan:", "");
			if (refinement?.trim()) {
				pi.sendMessage(planMsg, { deliverAs: "followUp" });
				pi.sendUserMessage(refinement.trim(), { deliverAs: "followUp" });
			}
		}
	});

	// ── Restore state on session start ──

	pi.on("session_start", async (_event, ctx) => {
		// Flags override persisted state
		if (pi.getFlag("plan")) mode = "plan";
		else if (pi.getFlag("pair")) mode = "pair";

		const entries = ctx.sessionManager.getEntries();
		const stateEntry = entries
			.filter((e: { type: string; customType?: string }) => e.type === "custom" && e.customType === "modes-state")
			.pop() as { data?: ModesState } | undefined;

		if (stateEntry?.data) {
			// Flags take precedence
			if (!pi.getFlag("plan") && !pi.getFlag("pair")) {
				mode = stateEntry.data.mode ?? "none";
			}
			planTodos = stateEntry.data.planTodos ?? [];
			planExecuting = stateEntry.data.planExecuting ?? false;
			toolsBeforeMode = stateEntry.data.toolsBeforeMode;
		}

		// Rebuild completion state on resume
		if (planExecuting && planTodos.length > 0) {
			let execIdx = -1;
			for (let i = entries.length - 1; i >= 0; i--) {
				const e = entries[i] as { type: string; customType?: string };
				if (e.customType === "plan-mode-execute") {
					execIdx = i;
					break;
				}
			}
			const msgs: AssistantMessage[] = [];
			for (let i = execIdx + 1; i < entries.length; i++) {
				const e = entries[i];
				if (e.type === "message" && "message" in e) {
					const m = e.message as AgentMessage;
					if (m.role === "assistant" && Array.isArray(m.content)) msgs.push(m as AssistantMessage);
				}
			}
			const allText = msgs
				.map((m) => m.content.filter((b): b is TextContent => b.type === "text").map((b) => b.text).join("\n"))
				.join("\n");
			markCompletedSteps(allText, planTodos);
		}

		if (mode === "plan") enablePlanTools();
		updateStatus(ctx);
	});
}
