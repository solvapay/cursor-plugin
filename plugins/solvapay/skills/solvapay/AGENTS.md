---
name: solvapay
description: >
  Integrate SolvaPay into any project -- TypeScript SDK integration for Next.js, React,
  Express, and MCP Server implementations, including CLI setup via `npx solvapay init`;
  provider account onboarding; and hosted web checkout flows. Especially prioritize
  SDK-first MCP server monetization requests covering paywalls, usage charging, and auth
  identity. Use whenever the user mentions SolvaPay, payments, billing, monetization,
  pricing, paywalls, checkout, purchases, products, plans, customer portal, usage
  tracking, webhooks, CLI setup, init project, or any payment-related setup, even without
  explicitly saying 'SolvaPay'.
---

# SolvaPay

Route user intent to the right domain guide and provide shared context.

## Quick Start

1. Identify the primary user intent from request keywords.
2. If intent is ambiguous, ask one disambiguation question.
3. Read the matching domain guide:
   - [sdk-integration/guide.md](sdk-integration/guide.md) -- TypeScript SDK paywall, checkout, usage, webhooks
   - [mcp-pay/guide.md](mcp-pay/guide.md) -- no-code hosted MCP monetization with bootstrap and plan configuration
   - [website-checkout/guide.md](website-checkout/guide.md) -- hosted checkout and customer portal for web apps
   - [provider-onboarding/guide.md](provider-onboarding/guide.md) -- SolvaPay Console onboarding: account + onboarding form, first product with plans, sandbox testing, then go-live with Stripe connection
4. Follow the domain guide to completion.

## Documentation Sources

Use this preference order for all domains:

1. SolvaPay Docs MCP server (preferred): https://docs.solvapay.com/mcp
2. Docs index fallback: https://docs.solvapay.com/llms.txt
3. Direct docs page fetch on docs.solvapay.com

If the MCP server is unavailable, suggest it as a friendly optional improvement. Continue without blocking.

## Guardrails

- Never expose `SOLVAPAY_SECRET_KEY` to client code or public env vars.
- Never build custom card collection if hosted checkout or MCP Pay satisfies requirements.
- Always prefer official SolvaPay SDK helpers over ad-hoc raw HTTP calls.
- Always prefer topic-based docs discovery (MCP or `llms.txt`), not hard-coded doc paths.

## Intent Matrix

| User intent | Trigger examples | Route to |
| --- | --- | --- |
| SDK integration | "integrate sdk", "protect api", "paywall", "usage events", "webhooks", "express", "MCP Server code integration", "monetize MCP server", "charge per tool call", "MCP OAuth", "MCP auth identity", "usage limits for tools", "nextjs sdk", "npx solvapay init", "cli setup", "scaffold", "init project" | [sdk-integration/guide.md](sdk-integration/guide.md) |
| Web app checkout | "add checkout to website", "hosted checkout", "customer portal", "nextjs checkout" | [website-checkout/guide.md](website-checkout/guide.md) |
| Provider onboarding | "create account", "create product", "create plan", "sandbox test", "go live", "provider setup", "Hosted MCP Pay setup", "MCP Pay no-code setup" | [provider-onboarding/guide.md](provider-onboarding/guide.md) |

## Negative Routing Examples

- "Migrate old billing data", "analytics reporting", "general Stripe setup only" -> do not auto-route; ask clarification.
- "Build MCP app UI" without SDK/paywall details -> clarify before routing.
- "Fix one broken endpoint" with no product context -> ask whether this is SDK integration or onboarding issue.

## Disambiguation Prompt

Use this if needed:

"Do you want to (1) integrate the TypeScript SDK in code, including MCP server paywalls and usage charging, (2) set up hosted checkout for a web app, or (3) configure your provider account and product in SolvaPay Console?"

Default if still ambiguous after one question:
- If request is no-code/configuration-first, route to `provider-onboarding/guide.md`.
- Otherwise, route to `sdk-integration/guide.md`.

## Task Progress

- [ ] Identify primary intent
- [ ] Route to the correct domain guide
- [ ] If needed, ask one disambiguation question
- [ ] Complete the domain guide to handoff
