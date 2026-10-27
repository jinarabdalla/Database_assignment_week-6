CREATE INDEX expenses_tenant_spent_on_idx ON expenses (tenant_id, spent_on DESC) WHERE deleted_at IS NULL;
CREATE INDEX expenses_tenant_category_date_idx ON expenses (tenant_id, category_id, spent_on DESC) WHERE deleted_at IS NULL;
CREATE INDEX expenses_attributes_gin_idx ON expenses USING GIN (attributes jsonb_path_ops);
CREATE INDEX audit_log_tenant_changed_at_idx ON audit_log (tenant_id, changed_at DESC);