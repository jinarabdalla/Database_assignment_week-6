# Query Optimization Evidence

## Method
1. Load representative data (suggested: 100,000+ expenses across tenants) in a disposable database.
2. Run ANALYZE expenses; ANALYZE categories.
3. Capture EXPLAIN (ANALYZE, BUFFERS, VERBOSE) for the exact queries in sql/analytics.sql.
4. In a test database only, compare plans with the relevant index absent and present.
5. Repeat measurements and record median timings; note row counts and cache conditions.
6. Paste actual outputs below. Do not invent timings. A small seed dataset may correctly use Seq Scan.

## Query A — monthly tenant spending
- QUERY: total spending for a tenant in the current month.
- BEFORE PLAN: paste actual EXPLAIN output here.
- CHANGE: index on (tenant_id, spent_on DESC) supports tenant equality and date range.
- AFTER PLAN: paste actual EXPLAIN output here.
- RESULT: enter measured milliseconds, buffer counts, and scan type.

## Query B — category breakdown
- QUERY: category totals over the last 90 days.
- BEFORE PLAN: paste actual EXPLAIN output here.
- CHANGE: compare (tenant_id, category_id, spent_on DESC) with (tenant_id, spent_on DESC); selectivity and grouping affect the best plan.
- AFTER PLAN: paste actual EXPLAIN output here.
- RESULT: enter real timings and plan details.

| Query | Rows | Before ms | After ms | Buffer evidence |
|---|---:|---:|---:|---|
| Monthly total | Not measured | Not measured | Not measured | Capture locally |
| Category breakdown | Not measured | Not measured | Not measured | Capture locally |

Evidence status: template prepared; actual performance testing remains to be completed on PostgreSQL.
