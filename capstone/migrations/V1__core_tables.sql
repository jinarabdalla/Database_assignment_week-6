CREATE TABLE tenants (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 name varchar(120) NOT NULL CHECK (length(trim(name)) > 0),
 created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE app_users (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
 email varchar(254) NOT NULL,
 display_name varchar(120) NOT NULL,
 role varchar(20) NOT NULL DEFAULT 'member' CHECK (role IN ('tenant_admin','member','viewer')),
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE (tenant_id, email)
);
CREATE TABLE categories (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
 name varchar(80) NOT NULL CHECK (length(trim(name)) > 0),
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE (tenant_id, name)
);
CREATE TABLE expenses (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
 user_id uuid NOT NULL REFERENCES app_users(id) ON DELETE RESTRICT,
 category_id uuid REFERENCES categories(id) ON DELETE SET NULL,
 amount numeric(12,2) NOT NULL CHECK (amount >= 0),
 currency char(3) NOT NULL DEFAULT 'KES' CHECK (currency ~ '^[A-Z]{3}$'),
 description varchar(500), spent_on date NOT NULL DEFAULT CURRENT_DATE,
 attributes jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(attributes) = 'object'),
 created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz
);
CREATE TABLE audit_log (
 id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 tenant_id uuid NOT NULL, table_name text NOT NULL, record_id uuid NOT NULL,
 action text NOT NULL CHECK (action IN ('INSERT','UPDATE','DELETE')),
 changed_by text, changed_at timestamptz NOT NULL DEFAULT now(), old_data jsonb, new_data jsonb
);