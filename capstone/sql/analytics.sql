-- Run with psql -v tenant_id='11111111-1111-4111-8111-111111111111'.
BEGIN;
SELECT set_config('app.tenant_id', :'tenant_id', true);
SELECT date_trunc('month', e.spent_on::timestamp)::date AS month, c.name AS category, e.currency,
       sum(e.amount) AS total_spend, count(*) AS expense_count
FROM expenses e LEFT JOIN categories c ON c.id=e.category_id AND c.tenant_id=e.tenant_id
WHERE e.tenant_id=:'tenant_id'::uuid AND e.deleted_at IS NULL
  AND e.spent_on >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY 1,2,3 ORDER BY 1 DESC,total_spend DESC;
COMMIT;
-- JSONB search example: bind values as parameters in application code.
-- SELECT id, spent_on, amount FROM expenses WHERE tenant_id=$1::uuid AND deleted_at IS NULL AND attributes @> '{"payment_method":"cash"}'::jsonb;