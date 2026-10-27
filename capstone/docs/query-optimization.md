# Query Optimization Evidence

## Query under test
EXPLAIN (ANALYZE, BUFFERS) SELECT id, spent_on, amount, category_id FROM expenses WHERE tenant_id='11111111-1111-4111-8111-111111111111' AND deleted_at IS NULL AND spent_on >= CURRENT_DATE - INTERVAL '90 days' ORDER BY spent_on DESC LIMIT 100;

## Evidence record
- BEFORE PLAN: paste the full EXPLAIN (ANALYZE, BUFFERS) output here before adding the matching index.
- CHANGE: migration V2 adds a partial B-tree index on (tenant_id, spent_on DESC) for rows where deleted_at IS NULL. It matches the tenant equality filter, date range, and ordering.
- AFTER PLAN: paste the full output here after applying V2 and running ANALYZE expenses.
- RESULT: record actual execution time, buffers, and scan type from your own environment. No timing is fabricated here; PostgreSQL may choose a sequential scan on small tables.

## Reproduction
1. Use a disposable database and representative synthetic data.
2. Capture the plan before and after the index using the exact same query and data.
3. Run ANALYZE expenses after loading data.
4. Save PostgreSQL version, row count, environment, and both plans. Repeat runs because cache and system load affect timing.