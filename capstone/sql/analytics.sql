SET app.tenant_id = '1';
-- Monthly total for the current tenant.
SELECT date_trunc('month', spent_on)::date AS month, currency, SUM(amount) AS total_spent
FROM expenses
WHERE tenant_id = 1
  AND spent_on >= date_trunc('month', CURRENT_DATE)::date
  AND spent_on < (date_trunc('month', CURRENT_DATE) + INTERVAL '1 month')::date
GROUP BY 1, 2 ORDER BY 1;

-- Category breakdown for the last 90 days.
SELECT c.name AS category, SUM(e.amount) AS total_spent, COUNT(*) AS expense_count
FROM expenses e
JOIN categories c ON c.tenant_id = e.tenant_id AND c.id = e.category_id
WHERE e.tenant_id = 1 AND e.spent_on >= CURRENT_DATE - 90
GROUP BY c.name ORDER BY total_spent DESC;

-- Capture plans with EXPLAIN (ANALYZE, BUFFERS, VERBOSE) on representative data.
-- Small demo tables may correctly use a sequential scan.
