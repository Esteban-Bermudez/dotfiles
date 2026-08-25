import type { ExtensionAPI } from "@earendil-works/pi-coding-agent"
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui"
import { homedir } from "node:os"

// Custom single-line footer.
// Left:  cwd · branch · provider · model · thinking level
// Right: session name (if set) · context usage
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

  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsub = footerData.onBranchChange(() => tui.requestRender())

      return {
        dispose: unsub,
        invalidate() {},
        render(width: number): string[] {
          const cwd = formatCwd(ctx.cwd)
          const branch = footerData.getGitBranch()
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
