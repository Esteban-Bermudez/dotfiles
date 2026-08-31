import type { ExtensionAPI } from "@earendil-works/pi-coding-agent"
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui"
import { homedir } from "node:os"
import { existsSync, readFileSync, statSync } from "node:fs"
import { dirname, join, resolve } from "node:path"

export default function (pi: ExtensionAPI) {
  function formatCwd(cwd: string): string {
    const home = homedir()
    return cwd.startsWith(home) ? `~${cwd.slice(home.length)}` : cwd
  }

  function formatTokens(count: number): string {
    if (count < 1000) return `${count}`
    if (count < 1_000_000) return `${(count / 1000).toFixed(1)}k`
    return `${(count / 1_000_000).toFixed(1)}M`
  }

  function capitalize(value: string): string {
    return value.length === 0 ? value : value[0].toUpperCase() + value.slice(1)
  }

  function findGitHeadPath(cwd: string): string | null {
    let dir = cwd
    while (true) {
      const gitPath = join(dir, ".git")
      if (existsSync(gitPath)) {
        try {
          const stat = statSync(gitPath)
          if (stat.isFile()) {
            const content = readFileSync(gitPath, "utf8").trim()
            if (content.startsWith("gitdir: ")) {
              const gitDir = resolve(dir, content.slice(8).trim())
              const headPath = join(gitDir, "HEAD")
              if (existsSync(headPath)) return headPath
              return null
            }
          } else if (stat.isDirectory()) {
            const headPath = join(gitPath, "HEAD")
            if (existsSync(headPath)) return headPath
            return null
          }
        } catch {
          return null
        }
      }
      const parent = dirname(dir)
      if (parent === dir) return null
      dir = parent
    }
  }

  function readBranchDirect(cwd: string): string | null {
    const headPath = findGitHeadPath(cwd)
    if (!headPath) return null
    try {
      const content = readFileSync(headPath, "utf8").trim()
      if (content.startsWith("ref: refs/heads/")) return content.slice(16)
      if (content) return "detached"
      return null
    } catch {
      return null
    }
  }

  let currentTui: { requestRender: () => void } | null = null

  pi.on("tool_result" as never, async (event: { toolName: string; input: { command?: string } }) => {
    if (event.toolName !== "bash") return
    const cmd = event.input?.command ?? ""
    if (!/\bgit\b.*\b(checkout|switch|branch|merge|rebase|reset|clone|worktree)\b/.test(cmd)) return
    setTimeout(() => currentTui?.requestRender(), 350)
  })

  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setFooter((tui, theme, footerData) => {
      currentTui = tui as unknown as { requestRender: () => void }

      const getCwd = (): string => {
        try {
          const sm = ctx.sessionManager as unknown as { getCwd?: () => string }
          return sm.getCwd?.() ?? ctx.cwd
        } catch {
          return ctx.cwd
        }
      }

      let lastBranch: string | null | undefined = readBranchDirect(getCwd()) ?? footerData.getGitBranch()

      const unsub = footerData.onBranchChange(() => {
        lastBranch = readBranchDirect(getCwd()) ?? footerData.getGitBranch()
        tui.requestRender()
      })

      const poll = setInterval(() => {
        const fresh = readBranchDirect(getCwd()) ?? footerData.getGitBranch() ?? null
        const cached = footerData.getGitBranch() ?? null
        if (fresh !== lastBranch || cached !== fresh) {
          lastBranch = fresh
          tui.requestRender()
        }
      }, 700) as unknown as NodeJS.Timeout
      ;(poll as unknown as { unref?: () => void }).unref?.()

      return {
        dispose: () => {
          unsub()
          clearInterval(poll)
          if (currentTui === (tui as unknown as { requestRender: () => void })) currentTui = null
        },
        invalidate() {},
        render(width: number): string[] {
          const cwd = formatCwd(getCwd())
          const freshBranch = readBranchDirect(getCwd())
          const branch = freshBranch ?? footerData.getGitBranch()
          lastBranch = branch
          const provider = ctx.model?.provider ? capitalize(ctx.model.provider) : undefined
          const modelName = ctx.model?.name
          const thinking = pi.getThinkingLevel()

          const statuses = footerData.getExtensionStatuses()
          const modeStatus = statuses.get("modes")
          const styleStatus = statuses.get("pi-output-styles")
          const styleName = styleStatus?.replace(/^style:\s*/, "")
          const styleIndicator = styleName ? `\x1b[35m${styleName}\x1b[39m` : undefined

          const leftParts = [cwd]
          if (branch) leftParts.push(branch)
          if (provider) leftParts.push(provider)
          if (modelName) leftParts.push(modelName)
          leftParts.push(thinking)
          const leftRest = theme.fg("dim", leftParts.join(" · "))
          const indicators = [modeStatus].filter(Boolean).join(" ")
          const left = indicators ? `${indicators} ${leftRest}` : leftRest

          const sessionName = ctx.sessionManager.getSessionName()
          const usage = ctx.getContextUsage()
          const rightParts: string[] = []
          if (sessionName) rightParts.push(theme.fg("muted", sessionName))
          if (styleIndicator) rightParts.push(styleIndicator)
          if (usage && usage.percent !== null && usage.tokens !== null) {
            rightParts.push(
              theme.fg("muted", `${usage.percent.toFixed(1)}%/${formatTokens(usage.contextWindow)}`),
            )
          }
          const right = rightParts.join(theme.fg("muted", " · "))

          const gap = Math.max(1, width - visibleWidth(left) - visibleWidth(right))
          return [truncateToWidth(left + " ".repeat(gap) + right, width)]
        },
      }
    })
  })
}
