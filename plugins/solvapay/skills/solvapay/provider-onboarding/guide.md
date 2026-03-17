# Provider Onboarding Guide

Guide provider setup with an operational, step-by-step flow.

## Purpose

Use this guide for operational onboarding of a provider account, not application code implementation.
Use product-first setup in SolvaPay Console where plans are configured within each product.

## Steps

Follow these files in order:

1. [01-create-account.md](01-create-account.md)
2. [02-create-product-and-plan.md](02-create-product-and-plan.md)
3. [03-test-in-sandbox.md](03-test-in-sandbox.md)
4. [04-go-live.md](04-go-live.md)

## Docs Discovery Hints

- Onboarding topics: `create account`, `create product`, `test in sandbox`, `go live`.
- Runtime topics for coordination with engineering: `webhooks`, `checkout session`, `usage limits`.

## Guardrails

- Never skip sandbox validation before switching to live mode.
- Never launch with missing webhook verification or unresolved failed-payment handling.
- Always confirm product and plan references before sharing integration instructions.
- Always capture handoff outputs for engineering teams before closing onboarding.

## Handoff Outputs (Required)

At completion provide:

- account mode status (sandbox/live)
- product and plan references
- payment provider connection status
- webhook endpoint status and verification status
- unresolved risks and owner for follow-up

## Task Progress

- [ ] Account is created and billing connector is configured
- [ ] Product and plan are configured
- [ ] Sandbox purchase flow is tested end to end
- [ ] Go-live checklist is complete
