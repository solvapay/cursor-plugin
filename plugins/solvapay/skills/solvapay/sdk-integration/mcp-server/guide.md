# MCP Server Paywall Integration

Add paywall protection and self-service tools to an MCP server using `@solvapay/server`.

## Contents

- [Guardrails](#guardrails)
- [Prerequisites](#prerequisites)
- [SDK initialization](#sdk-initialization)
- [Wrap tool handlers](#wrap-tool-handlers)
- [Register virtual tools](#register-virtual-tools)
- [OAuth bridge setup](#oauth-bridge-setup)
- [Environment variables](#environment-variables)
- [Verification checklist](#verification-checklist)

## Guardrails

- Never wrap virtual tool handlers with `payable.mcp()` -- they bypass the paywall by design.
- Never expose `SOLVAPAY_SECRET_KEY` to clients or public environment variables.
- Never execute paid tool logic before the paywall check runs.
- Always require a stable customer identity for protected tools.
- Always use `@solvapay/server` helpers over raw HTTP calls to the SolvaPay API.

## Prerequisites

- `@solvapay/server` installed in the project
- A product created in SolvaPay Console with at least one plan
- `SOLVAPAY_SECRET_KEY` and `SOLVAPAY_PRODUCT_REF` set in the environment

## Auth and identity policy

- This guide assumes an HTTP MCP server using OAuth bearer tokens for caller identity.
- Always map authenticated callers to a stable customer reference before protected tool execution.
- If your product requires authentication for all paid operations, reject unauthenticated
  `tools/call` requests with 401 instead of falling back to a shared identity.
- Use an anonymous identity only when it is an explicit product decision (for example a limited
  anonymous tier) and configure plan/limits accordingly.

## SDK initialization

Create a shared config module. All other files import from here.

```typescript
import { createSolvaPay, createSolvaPayClient } from '@solvapay/server'

const apiClient = createSolvaPayClient({
  apiKey: process.env.SOLVAPAY_SECRET_KEY!,
  apiBaseUrl: process.env.SOLVAPAY_API_BASE_URL,
})

export const productRef = process.env.SOLVAPAY_PRODUCT_REF!

export const solvaPay = createSolvaPay({ apiClient })

export const payable = solvaPay.payable({ product: productRef })
```

## Wrap tool handlers

### getCustomerRef helper

The adapter can read customer identity from MCP `extra.authInfo`, which is forwarded by `StreamableHTTPServerTransport` when `req.auth` is set.

```typescript
const getCustomerRef = (_args: Record<string, unknown>, extra?: McpToolExtra) => {
  const customerRef = extra?.authInfo?.extra?.customer_ref
  return typeof customerRef === 'string' && customerRef.trim() ? customerRef : null
}
```

### Wrapping pattern

Write business logic as plain functions. Wrap each one with `payable.mcp()`:

```typescript
async function createTask(args: { title: string }) {
  return { success: true, task: { id: crypto.randomUUID(), title: args.title } }
}

const toolHandlers = {
  create_task: payable.mcp(createTask),
  get_task: payable.mcp(getTask),
  list_tasks: payable.mcp(listTasks),
}
```

The adapter automatically:
- Checks usage limits before running business logic
- Tracks usage after successful execution
- Wraps results in MCP `content` format
- Returns a structured paywall error with checkout URL when limits are exceeded

No manual `PaywallError` handling is needed.

### Different plans per tool

Create separate `payable` instances:

```typescript
const freeTier = solvaPay.payable({ product: productRef, plan: 'pln_free' })
const proTier = solvaPay.payable({ product: productRef, plan: 'pln_pro' })

const toolHandlers = {
  list_tasks: freeTier.mcp(listTasks),
  create_task: proTier.mcp(createTask),
}
```

## Register virtual tools

Virtual tools provide self-service account management. They are **not** paywall-protected.

| Tool | Description |
| --- | --- |
| `get_user_info` | Returns user profile and purchase status |
| `upgrade` | Returns available plans and checkout URLs |
| `manage_account` | Returns a secure customer portal link |

### Recommended: one-call registration with `McpServer`

```typescript
await solvaPay.registerVirtualToolsMcp(server, {
  product: productRef,
})
```

To exclude specific virtual tools, pass `exclude: ['manage_account']` in the options.

### Advanced: custom server registration loop

If you are not using `McpServer.registerTool()`, use `getVirtualTools()` and register each definition manually.

## OAuth bridge setup

MCP clients authenticate via OAuth. Use `createMcpOAuthBridge()` to register well-known endpoints and attach `req.auth` for MCP transports.

```typescript
app.use(
  ...createMcpOAuthBridge({
    publicBaseUrl: process.env.MCP_PUBLIC_BASE_URL!,
    apiBaseUrl: process.env.SOLVAPAY_API_BASE_URL || 'https://api.solvapay.com',
    productRef: process.env.SOLVAPAY_PRODUCT_REF!,
    mcpPath: '/mcp',
    requireAuth: true,
  }),
)
```

### What the helper does

- Serves `GET /.well-known/oauth-protected-resource`
- Serves `GET /.well-known/oauth-authorization-server`
- Decodes bearer JWTs locally and sets `req.auth`
- Returns `401` + `WWW-Authenticate` when bearer auth is missing/invalid

For unauthenticated requests:

```
WWW-Authenticate: Bearer resource_metadata="<MCP_PUBLIC_BASE_URL>/.well-known/oauth-protected-resource"
```

## Environment variables

| Variable | Required | Description |
| --- | --- | --- |
| `SOLVAPAY_SECRET_KEY` | Yes | API secret key (`sk_...`) |
| `SOLVAPAY_API_BASE_URL` | No | API base URL (defaults to `https://api.solvapay.com`) |
| `SOLVAPAY_PRODUCT_REF` | Yes | Product reference for paywall and OAuth DCR |
| `MCP_PUBLIC_BASE_URL` | Yes | Your server's public origin |

## Verification checklist

- [ ] Unauthenticated requests receive 401 with `WWW-Authenticate` header
- [ ] `GET /.well-known/oauth-protected-resource` returns correct resource metadata
- [ ] `GET /.well-known/oauth-authorization-server` returns endpoints pointing to SolvaPay
- [ ] Protected tool denies over-limit calls with a paywall error containing a checkout URL
- [ ] Protected tool allows authenticated, in-limit calls and returns business logic result
- [ ] Virtual tools (`get_user_info`, `upgrade`, `manage_account`) respond without paywall
- [ ] Virtual tool handlers are NOT wrapped with `payable.mcp()`
- [ ] If webhooks are enabled, signature verification and event handling follow [webhooks.md](../webhooks.md)
