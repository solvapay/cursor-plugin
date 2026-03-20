# SolvaPay Cursor plugin

Official Cursor Marketplace plugin for SolvaPay SDK integration.

## Priority and scope (v1)

- Primary audience: developers integrating SolvaPay SDK in code.
- Included capabilities:
  - SolvaPay routing skill and domain guides (`skills/solvapay`)
  - SolvaPay Docs MCP (`solvapay-docs`) for up-to-date documentation retrieval
  - Lightweight rules for safety and implementation quality
- Single-plugin strategy: ship one cohesive plugin first for faster review and clearer onboarding.

## Quick start

1. Install the plugin from Cursor Marketplace.
2. Configure MCP servers in Cursor:
   - Docs MCP (`solvapay-docs`): no key required.
3. Start with one of these prompts:
   - "Integrate SolvaPay SDK in my Next.js app."
   - "Protect my Express route with SolvaPay paywall checks."
   - "How do I create a product and monthly plan in SolvaPay Console?"

## Included files

- `skills/solvapay/`: integration, checkout, and onboarding guides
- `rules/`: SolvaPay safety and review rules
- `mcp.json`: SolvaPay Docs MCP server definition
- `.cursor-plugin/plugin.json`: plugin metadata and explicit component paths

## Notes

- Docs MCP is keyless and works out of the box.
- Product and plan setup is handled in SolvaPay Console through provider onboarding guidance.

## Validation

Run:

```bash
node scripts/validate-template.mjs
```

## v2 split criteria

Split into multiple plugins only when at least two are true:

- Distinct install demand from SDK integrators vs operations-only provider teams.
- Divergent release cadence between integration and onboarding guidance.
- Support burden indicates confusion from mixed scope in one plugin.
- Marketplace search/discoverability improves with narrower plugin descriptions.
