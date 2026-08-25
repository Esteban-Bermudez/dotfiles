import type { ExtensionAPI } from "@earendil-works/pi-coding-agent"

export default function (pi: ExtensionAPI) {
  pi.on("before_provider_headers", (event, ctx) => {
    if (ctx.model?.provider !== "opencode") return

    event.headers["x-opencode-client"] = "cli"
    event.headers["x-opencode-session"] = ctx.sessionManager.getSessionId()
    event.headers["x-opencode-request"] = crypto.randomUUID()
    event.headers["User-Agent"] = "opencode/1.18.7"
  })
}
