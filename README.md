# SolvaPay Cursor Plugin

A Cursor marketplace plugin that helps AI assistants integrate SolvaPay faster, with built-in
skills, rules, and MCP server configuration for docs retrieval.

## Overview

This repository contains the SolvaPay Cursor marketplace plugin source and release assets.

Current plugin scope:

- Ship one plugin: `solvapay` (source: `plugins/solvapay`)
- Prioritize SolvaPay SDK integration workflows
- Include SolvaPay Docs MCP: `https://docs.solvapay.com/mcp`

## Installation

1. Open Cursor settings
2. Go to **Plugins**
3. Click **Browse Marketplace**
4. Search for `SolvaPay`
5. Click **Install**

## Development

Plugin manifest locations:

- Marketplace manifest: `.cursor-plugin/marketplace.json`
- Plugin manifest: `plugins/solvapay/.cursor-plugin/plugin.json`

Local validation:

```bash
node scripts/validate-template.mjs
```

## Marketplace readiness checklist

- Plugin metadata and keywords are production-ready
- Skills, rules, and MCP server config are explicitly declared in the plugin manifest
- Skill routing prioritizes SDK integration and docs-grounded guidance
- Docs MCP setup is documented and keyless
- Validator passes before submission
- Plugin folder name matches plugin name (`plugins/solvapay`)

## Future split policy

Do not split into multiple plugins until at least two of these are true:

- Clear request for separate installs by user persona
- Independent release cadence
- Support burden from mixed plugin scope
- Better marketplace discoverability with narrower plugin descriptions

## Support

- SolvaPay docs: [https://docs.solvapay.com](https://docs.solvapay.com)
- Issues and requests: open an issue in this repository
