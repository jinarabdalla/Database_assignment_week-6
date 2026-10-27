CREATE INDEX idx_expenses_tenant_spent_on ON expenses (tenant_id, spent_on DESC);
CREATE INDEX idx_expenses_tenant_category_date ON expenses (tenant_id, category_id, spent_on DESC);
CREATE INDEX idx_expenses_tenant_created_by ON expenses (tenant_id, created_by);
CREATE INDEX idx_categories_tenant_name ON categories (tenant_id, name);
