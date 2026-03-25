# SolvaPay Cursor Plugin

A Cursor marketplace plugin that helps AI assistants integrate SolvaPay faster, with built-in skills, rules, and MCP server configuration for monetization, docs, and admin workflows.

## Overview

This repository contains the public source for the SolvaPay Cursor plugin.

## What you can do with this plugin

- Get SDK-first guidance for SolvaPay integrations in Next.js, React, Express, and MCP servers
- Monetize MCP servers with paywalls, usage charging, and auth/identity patterns
- Access up-to-date docs and account operations through built-in MCP integrations:
  - SolvaPay Docs MCP: `https://docs.solvapay.com/mcp`
  - SolvaPay Admin MCP: `https://mcp.solvapay.com/mcp`

## MCP monetization use cases

- Add paywalls to MCP tools with `@solvapay/server`
- Charge by usage with limits checks and usage event recording
- Implement MCP auth and identity mapping (OAuth bearer token to stable customer reference)
- Follow the MCP implementation path in `plugins/solvapay/skills/solvapay/sdk-integration/mcp-server/guide.md`

## Installation

1. Open Cursor settings
2. Go to **Plugins**
3. Click **Browse Marketplace**
4. Search for `SolvaPay`
5. Click **Install**

## For contributors

Plugin manifest locations:

- Marketplace manifest: `.cursor-plugin/marketplace.json`
- Plugin manifest: `plugins/solvapay/.cursor-plugin/plugin.json`

Local validation:

```bash
node scripts/validate-template.mjs
```

## Support

- SolvaPay docs: [https://docs.solvapay.com](https://docs.solvapay.com)
- Issues and requests: open an issue in this repository
