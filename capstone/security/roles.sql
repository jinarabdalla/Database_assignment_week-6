-- Review and run as a database administrator. Do not store passwords in this file.
CREATE ROLE spendwise_app NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;
GRANT CONNECT ON DATABASE capstone TO spendwise_app;
GRANT USAGE ON SCHEMA public TO spendwise_app;
GRANT SELECT, INSERT, UPDATE ON app_users, categories, expenses TO spendwise_app;
GRANT SELECT ON tenants, audit_log TO spendwise_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO spendwise_app;
-- Do not grant BYPASSRLS. Runtime role must not own the tables. Table owners and superusers can bypass RLS unless FORCE ROW LEVEL SECURITY is enabled.
-- For production, separate migration owner from runtime role and review default privileges and tenant registry access.