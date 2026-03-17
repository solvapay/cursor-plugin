# SolvaPay Cursor marketplace

Repository for SolvaPay Cursor Marketplace plugins.

## Current release strategy

- Ship one plugin first: `solvapay` (source: `plugins/solvapay`)
- Prioritize SDK integration workflows
- Include both:
  - SolvaPay Docs MCP (`https://docs.solvapay.com/mcp`)
  - SolvaPay Admin MCP (`https://mcp.solvapay.com/mcp`)

## Plugin manifest locations

- Marketplace manifest: `.cursor-plugin/marketplace.json`
- Plugin manifest: `plugins/solvapay/.cursor-plugin/plugin.json`

## Local validation

```bash
node scripts/validate-template.mjs
```

## Marketplace readiness checklist

- Plugin metadata and keywords are production-ready.
- Skills, rules, and MCP server config are explicitly declared in plugin manifest.
- Skill routing prioritizes SDK integration and docs-grounded guidance.
- Admin MCP setup is documented as optional for users without API keys.
- Validator passes before submission.
- Plugin folder name matches plugin name for clarity (`plugins/solvapay`).

## Future split policy

Do not split into multiple plugins until at least two of these are observed:

- clear request for separate installs by user persona
- independent release cadence
- support burden from mixed plugin scope
- better marketplace discoverability with narrower plugin descriptions
