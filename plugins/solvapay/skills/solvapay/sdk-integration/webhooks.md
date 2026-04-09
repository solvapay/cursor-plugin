# Webhooks

Use webhooks to keep local state in sync with SolvaPay billing events.

## Docs References (Topic-Based)

- Topics: `webhooks`, `verify signature`, `purchase events`, `payment events`, `error handling`.
- Retrieval hint: fetch verification and event-handling sections first; avoid full-page dumps.

## Required Steps

1. Configure webhook endpoint in SolvaPay Console.
2. Read raw request body (use `express.raw()` or `request.text()`).
3. Verify `SV-Signature` header with `SOLVAPAY_WEBHOOK_SECRET` using `verifyWebhook`.
4. Process event idempotently (use `SV-Delivery` header as dedupe key).
5. Update database and invalidate caches.
6. Return 2xx quickly; move heavy side effects to async workers.

## Signature Scheme

Header: `SV-Signature: t={unix_timestamp},v1={hmac_hex}`

HMAC: `SHA-256(whsec_secret, "{timestamp}.{rawBody}")`

The SDK `verifyWebhook` function handles parsing, HMAC verification, and timestamp tolerance (300 s default).

## Event Types

### Payment Events

| Event | Description |
|---|---|
| `payment.succeeded` | Payment successfully processed |
| `payment.failed` | Payment attempt failed |
| `payment.refunded` | Refund successfully processed |
| `payment.refund_failed` | Refund attempt failed |

### Purchase Events

| Event | Description |
|---|---|
| `purchase.created` | New purchase created |
| `purchase.updated` | Purchase modified (plan change, renewal, etc.) |
| `purchase.cancelled` | Purchase cancelled |
| `purchase.expired` | Purchase expired |
| `purchase.suspended` | Purchase suspended due to non-payment |

### Customer Events

| Event | Description |
|---|---|
| `customer.created` | Customer created |
| `customer.updated` | Customer updated |
| `customer.deleted` | Customer deleted |

These are curated business events. Internal CRUD events for products, plans, and
transactions are not emitted as webhooks.

## Webhook Payload Shape

```json
{
  "id": "evt_…",
  "type": "purchase.created",
  "created": 1740000000,
  "api_version": "2025-10-01",
  "data": { "object": { … }, "previous_attributes": null },
  "livemode": false,
  "request": { "id": null, "idempotency_key": null }
}
```

Additional headers: `SV-Event-Id`, `SV-Delivery`, `User-Agent: SolvaPay/1.0 (+webhooks)`.

## Next.js Pattern

```typescript
import { verifyWebhook } from '@solvapay/server'

const body = await request.text()
const signature = request.headers.get('sv-signature')
if (!signature) return NextResponse.json({ error: 'Missing signature' }, { status: 401 })

const event = verifyWebhook({
  body,
  signature,
  secret: process.env.SOLVAPAY_WEBHOOK_SECRET!,
})
// event.type, event.data.object, event.livemode, etc.
```

## Express Pattern

```typescript
import express from 'express'
import { verifyWebhook } from '@solvapay/server'

const app = express()
app.post('/api/webhooks/solvapay', express.raw({ type: 'application/json' }), async (req, res) => {
  const signature = req.headers['sv-signature'] as string | undefined
  if (!signature) return res.status(401).json({ error: 'Missing signature' })

  const event = verifyWebhook({
    body: req.body.toString(),
    signature,
    secret: process.env.SOLVAPAY_WEBHOOK_SECRET!,
  })

  await handleWebhookEvent(event)
  return res.json({ received: true })
})
```

## Event-to-Action Matrix

| Event | Typical action |
| --- | --- |
| `purchase.created` | grant access and initialize usage state |
| `purchase.updated` | update access tier/limits |
| `purchase.cancelled` | schedule downgrade or revoke at period end |
| `purchase.expired` | revoke access |
| `purchase.suspended` | restrict access, notify customer |
| `payment.succeeded` | record payment and clear payment retry flags |
| `payment.failed` | mark account at risk and notify customer |
| `payment.refunded` | record refund, reverse credits |
| `payment.refund_failed` | log failure, retry or escalate |
| `customer.created` | provision customer resources |
| `customer.updated` | sync customer profile |
| `customer.deleted` | clean up customer data |

## Idempotency Strategy

- Store processed `SV-Delivery` IDs (or `event.id` + endpoint).
- Ignore repeats safely and return success.
- Wrap state mutations in transactions where possible.

## Failure and Retry Guidance

- Return `401` for invalid signatures.
- Return `5xx` only when retry is safe and needed.
- Log unknown event types and return `200` unless blocking.
- Deliveries retry with exponential backoff (5 min -> 72 hours, max 12 attempts).
- After 12 failures the endpoint is auto-disabled.

## Verification Checklist

- [ ] Signature validation rejects invalid requests
- [ ] Duplicate delivery does not double-write records
- [ ] Unknown events are logged but do not fail endpoint
- [ ] Purchase state updates are reflected in app access checks
- [ ] Failed payment flow triggers expected user/account response
