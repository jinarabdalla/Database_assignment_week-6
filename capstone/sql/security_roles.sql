-- Run as a PostgreSQL administrator after reviewing your environment.
DO $$
BEGIN
 IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'capstone_app') THEN
  CREATE ROLE capstone_app NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT;
 END IF;
 IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'capstone_readonly') THEN
  CREATE ROLE capstone_readonly NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT;
 END IF;
END $$;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
GRANT CONNECT ON DATABASE capstone TO capstone_app, capstone_readonly;
GRANT USAGE ON SCHEMA public TO capstone_app, capstone_readonly;
GRANT SELECT, INSERT, UPDATE, DELETE ON tenants, app_users, categories, expenses TO capstone_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO capstone_app;
GRANT SELECT ON tenants, app_users, categories, expenses TO capstone_readonly;
GRANT SELECT ON expense_audit TO capstone_readonly;
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON expense_audit FROM capstone_app;
REVOKE UPDATE, DELETE, TRUNCATE ON expense_audit FROM capstone_readonly;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
-- Keep the migration owner trusted: the audit trigger uses SECURITY DEFINER.
-- Set app.tenant_id and app.user_id from authenticated server-side identity per transaction.
