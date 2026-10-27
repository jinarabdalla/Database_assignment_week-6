ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_audit ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenants_self_read ON tenants FOR SELECT
 USING (id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT);
CREATE POLICY app_users_tenant_isolation ON app_users
 USING (tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT)
 WITH CHECK (tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT);
CREATE POLICY categories_tenant_isolation ON categories
 USING (tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT)
 WITH CHECK (tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT);
CREATE POLICY expenses_tenant_isolation ON expenses
 USING (tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT)
 WITH CHECK (tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT);
CREATE POLICY expense_audit_tenant_isolation ON expense_audit
 USING (tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT)
 WITH CHECK (tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::BIGINT);
-- Runtime roles must not own these tables or be superusers/BYPASSRLS roles.
