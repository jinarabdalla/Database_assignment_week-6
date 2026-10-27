# Redis Cache Design

Redis is optional and caches rebuildable dashboard summaries. PostgreSQL remains the source of truth for durable expenses, constraints, transactions, audit history, backups, and RLS.

Example key: spendwise:dashboard:v1:<tenant_uuid>:<yyyy-mm>. Value: JSON summary with totals by category, currency, and count. Start with a short TTL such as 60 seconds and tune only after measuring. Invalidate the key after an expense changes; if Redis is unavailable, fall back to PostgreSQL.

Never cache passwords, card details, or unnecessary personal data. Derive tenant ID from the authenticated session, not untrusted client input. Use authentication and private networking. Redis is not a better primary store for relational expense records because cache data may be evicted and relational constraints and durable audit trails are required.

Illustrative Python key helper:

    def dashboard_cache_key(tenant_id, year_month):
        return f"spendwise:dashboard:v1:{tenant_id}:{year_month}"

Measure cache hit rate and latency before claiming performance gains.