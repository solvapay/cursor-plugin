# SolvaPay Cursor plugin

Official Cursor Marketplace plugin for SolvaPay SDK integration and account operations.

## Priority and scope (v1)

- Primary audience: developers integrating SolvaPay SDK in code.
- Included capabilities:
  - SolvaPay routing skill and domain guides (`skills/solvapay`)
  - SolvaPay Docs MCP (`solvapay-docs`) for up-to-date documentation retrieval
  - SolvaPay Admin MCP (`solvapay-admin`) for product/plan/customer management
  - Lightweight rules for safety and implementation quality
- Single-plugin strategy: ship one cohesive plugin first for faster review and clearer onboarding.

## Quick start

1. Install the plugin from Cursor Marketplace.
2. Configure MCP servers in Cursor:
   - Docs MCP (`solvapay-docs`): no key required.
   - Admin MCP (`solvapay-admin`): set `SOLVAPAY_API_KEY` to a valid `sk_sandbox_...` or `sk_live_...` key.
3. Start with one of these prompts:
   - "Integrate SolvaPay SDK in my Next.js app."
   - "Protect my Express route with SolvaPay paywall checks."
   - "Create a product and monthly plan in SolvaPay."

## Included files

- `skills/solvapay/`: integration, checkout, and onboarding guides
- `rules/`: SolvaPay safety and review rules
- `mcp.json`: SolvaPay Docs + Admin MCP server definitions
- `.cursor-plugin/plugin.json`: plugin metadata and explicit component paths

## Notes

- If `SOLVAPAY_API_KEY` is not set, SDK guidance and docs retrieval still work.
- Admin MCP actions become available after the API key is configured.

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
