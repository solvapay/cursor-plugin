# SolvaPay Cursor plugin

Official Cursor Marketplace plugin for SolvaPay SDK integration, MCP server monetization, and account operations.

## Priority and scope (v1)

- Primary audience: developers integrating SolvaPay SDK in code.
- Included capabilities:
  - Five skills auto-discovered from `skills/` — see "Bundled skills" below
  - CLI-first SDK setup guidance (`npx solvapay init`)
  - SDK-first MCP server monetization guidance (paywalls, usage charging, auth/identity)
  - SolvaPay Docs MCP (`solvapay-docs`) for up-to-date documentation retrieval
  - SolvaPay Admin MCP (`solvapay-admin`) for product/plan/customer management
  - Session-start hook for proactive SolvaPay setup detection
  - Lightweight rules for safety and implementation quality
- Single-plugin strategy: ship one cohesive plugin first for faster review and clearer onboarding.

## Bundled skills

| Skill | Purpose |
| --- | --- |
| `skills/solvapay/` | Router — disambiguates vague intent and points at the right surface skill |
| `skills/create-mcp-app/` | Create or scaffold a paid MCP server on Cloudflare Workers (OpenAPI or hand-written) |
| `skills/sdk-integration/` | TypeScript SDK paywall, checkout, usage, webhooks for Next.js / React / Express / MCP / Supabase Edge |
| `skills/website-checkout/` | Hosted checkout and customer portal for web apps |
| `skills/lovable-checkout/` | Paste-in preview-only checkout for Lovable (Vite + shadcn/ui + Supabase Edge) |

Cursor invokes each skill as `/solvapay:<skill>` once the plugin is installed.

## Quick start

1. Install the plugin from Cursor Marketplace.
2. Open Cursor MCP settings and confirm plugin MCP servers are visible:
   - `solvapay-docs` loads from the plugin automatically and needs no API key.
   - `solvapay-admin` loads from the plugin as a URL-only MCP server and authenticates
     with OAuth + dynamic client registration (DCR) during the MCP connection flow.
3. If either server does not appear, add a manual fallback entry in your Cursor MCP config
   using the values from `mcp.json`.
4. Start with one of these prompts:
   - "Monetize my MCP server tools with SolvaPay paywalls and usage charging."
   - "Deploy a paywalled MCP server on Cloudflare Workers (or Supabase Edge) with SolvaPay."
   - "Add OAuth identity mapping for my MCP server paywall."
   - "Integrate SolvaPay SDK in my Next.js app."
   - "Protect my Express route with SolvaPay paywall checks."
   - "Drop `<CurrentPlanCard />` into my account page to render self-serve billing UI."
   - "Create a product and monthly plan in SolvaPay."

## Included files

- `skills/`: five sibling skills (see "Bundled skills" above) — auto-discovered by Cursor
- `rules/`: SolvaPay safety and review rules
- `hooks/hooks.json`: hook configuration for session-start setup detection
- `scripts/detect-solvapay.sh`: lightweight workspace detection script used by hooks
- `mcp.json`: SolvaPay Docs + Admin MCP server definitions
- `.cursor-plugin/plugin.json`: plugin metadata

## Notes

- `solvapay-docs` and `solvapay-admin` load from plugin MCP config with URL-only entries.
- Admin MCP actions become available after OAuth consent and DCR complete in Cursor.
- Plugin-bundled MCP config is the default path; manual MCP config is only a fallback.
- SDK server code uses `SOLVAPAY_SECRET_KEY` in your app/runtime environment.
- `sessionStart` hook only injects context when it detects an incomplete SolvaPay setup.
- Hook detection checks for `package.json`, SolvaPay dependencies, and `.env` key presence.

## Validation

Run:

```bash
node scripts/validate-template.mjs
```

## v2 split criteria

Split into multiple plugins only when at least two are true:

- Distinct install demand from SDK integrators vs operations-only provider teams.
- Divergent release cadence between integration skills and admin tooling.
- Support burden indicates confusion from mixed scope in one plugin.
- Marketplace search/discoverability improves with narrower plugin descriptions.
