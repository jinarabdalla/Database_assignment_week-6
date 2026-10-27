INSERT INTO tenants (id, name) VALUES (1, 'Demo Household');
INSERT INTO app_users (id, tenant_id, email, display_name)
 VALUES (1, 1, 'demo@example.test', 'Demo User');
INSERT INTO categories (id, tenant_id, name) VALUES
 (1, 1, 'Food'), (2, 1, 'Transport'), (3, 1, 'Utilities'), (4, 1, 'Savings');
INSERT INTO expenses (id, tenant_id, category_id, created_by, amount, currency, description, spent_on) VALUES
 (1, 1, 1, 1, 450.00, 'KES', 'Groceries', CURRENT_DATE - 2),
 (2, 1, 2, 1, 120.00, 'KES', 'Bus fare', CURRENT_DATE - 1),
 (3, 1, 3, 1, 1800.00, 'KES', 'Electricity token', CURRENT_DATE),
 (4, 1, 1, 1, 300.00, 'KES', 'Market vegetables', CURRENT_DATE);
SELECT setval(pg_get_serial_sequence('tenants','id'), COALESCE((SELECT max(id) FROM tenants),1));
SELECT setval(pg_get_serial_sequence('app_users','id'), COALESCE((SELECT max(id) FROM app_users),1));
SELECT setval(pg_get_serial_sequence('categories','id'), COALESCE((SELECT max(id) FROM categories),1));
SELECT setval(pg_get_serial_sequence('expenses','id'), COALESCE((SELECT max(id) FROM expenses),1));
