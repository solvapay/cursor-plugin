# SDK Reference

## Purpose

Use this file for TypeScript SDK operation patterns and minimal payload shapes.

## Contents

- Package map
- Common operations
- Operation templates
  - Create checkout session
  - Create customer session
  - Check limits
  - Record usage
  - Create/process payment intent (embedded only)
- Setup
- Required environment variables
- Guardrails
- Retrieval hints

## Package Map

- `@solvapay/server`: server SDK, paywall handlers, webhook verification
- `@solvapay/next`: Next.js helpers for checkout/customer/access routes
- `@solvapay/react`: UI provider/hooks for purchase and plan state
- `@solvapay/react-supabase`: Supabase auth adapter for `@solvapay/react`
- `@solvapay/auth`: auth utilities and adapters

## Common Operations

- Create checkout session
- Create customer session (portal)
- Ensure/sync customer
- Check subscription/purchase access
- Record usage events
- Verify webhooks

## Operation Templates

### Create Checkout Session

Use when user needs hosted checkout redirect.

Request shape:

```json
{
  "customerRef": "cus_xxx",
  "productRef": "prd_xxx",
  "planRef": "pln_xxx",
  "returnUrl": "https://app.example.com/billing/return"
}
```

Response shape:

```json
{
  "checkoutUrl": "https://solvapay.com/checkout?...",
  "sessionId": "..."
}
```

Docs topic hint: `checkout sessions create`.

### Create Customer Session

Use when user needs hosted billing portal access.

Request shape:

```json
{
  "customerRef": "cus_xxx"
}
```

Response shape:

```json
{
  "customerUrl": "https://solvapay.com/customer/...",
  "sessionId": "..."
}
```

Docs topic hint: `customer session create`.

### Check Access and Limits

Use before expensive or paid operations to enforce monetization.

Request shape (conceptual):

```json
{
  "customerRef": "cus_xxx",
  "productRef": "prd_xxx"
}
```

Response shape should indicate access status and upgrade path when blocked.

Docs topic hint: `limits check usage limits for customer and product`.

### Record Usage

Use for metered features after successful execution.

Request shape (conceptual):

```json
{
  "customerRef": "cus_xxx",
  "productRef": "prd_xxx",
  "event": "feature_invocation"
}
```

Docs topic hint: `usage record event` and `usage bulk`.

### Create/Process Payment Intent (Embedded Only)

Use only when hosted checkout is not acceptable for the use case.

Docs topic hint: `payment intents create` and `payment intents process`.

## Setup

### Recommended: CLI init

```bash
npx solvapay init
```

Handles provider authentication, `.env` configuration, `.gitignore` updates, and installs
`@solvapay/server`, `@solvapay/core`, and `@solvapay/auth`.

### Manual install (CI, Docker, or non-interactive environments)

```bash
npm install @solvapay/server @solvapay/next @solvapay/react @solvapay/auth @solvapay/react-supabase @supabase/supabase-js
```

## Required Environment Variables (Typical)

- `SOLVAPAY_SECRET_KEY` (server only)
- `SOLVAPAY_API_BASE_URL` (optional override)
- `SOLVAPAY_WEBHOOK_SECRET` (when webhooks enabled)
- Auth provider vars (for example Supabase keys)

## Credential Context Matrix

Use the right credential context to avoid auth confusion:

- `SOLVAPAY_SECRET_KEY`: server-side SDK credential used by your application code for paywall checks,
  usage events, checkout/customer sessions, and webhook-related operations.
- `solvapay-admin` (Cursor plugin MCP server): URL-only MCP configuration that authenticates
  via OAuth + dynamic client registration (DCR) during the MCP connection flow.

Do not expose `SOLVAPAY_SECRET_KEY` to client code or public environment variables.

## Guardrails

- Never put `SOLVAPAY_SECRET_KEY` in `NEXT_PUBLIC_*` or client bundles.
- Always map your authenticated user ID to a stable customer reference.
- Always verify webhook signatures before parsing business data.
- Always keep pricing/product configuration in SolvaPay backend, not hardcoded in UI.

## Retrieval Hints

When docs URLs change, resolve by topic using the documentation sources defined in the root [SKILL.md](../SKILL.md#documentation-sources).
