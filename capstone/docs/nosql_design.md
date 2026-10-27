# NoSQL Layer Decision: Redis Cache

Redis is optional and used only for derived monthly dashboard summaries. PostgreSQL remains the source of truth for expenses, users, categories, and audit records. MongoDB is unnecessary here because the core data has clear relationships and requires transactions, foreign keys, RLS, and constraints.

Suggested key: spendwise:tenant:{tenant_id}:month:{YYYY-MM}
Value: JSON with currency, total, and category totals.
Initial TTL: 60–300 seconds; tune from measured traffic.

After an expense transaction commits, invalidate the affected tenant-month key. For edits/deletes that move an expense to another date, invalidate both old and new month keys. Cache misses rebuild from PostgreSQL; short TTL limits stale data if invalidation fails. Never treat cached totals as financial truth.

Use private networking, Redis ACLs/authentication, TLS where supported, and environment-specific keys. Do not expose Redis publicly or commit secrets. Measure cache hit ratio and p50/p95 latency before claiming improvement.
