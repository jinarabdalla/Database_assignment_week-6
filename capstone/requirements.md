# SpendWise — Requirements Summary

## Purpose
SpendWise helps people record expenses and review spending by category and month. This capstone demonstrates relational design, tenant isolation, auditability, migrations, query optimization, and recovery.

## Users and workflows
A user belongs to a household/workspace (tenant), records expenses, selects a category, and views monthly totals and category breakdowns. Authorized operators can review an audit trail of changes.

## Functional requirements
1. Store tenants, users, categories, and expenses with primary and foreign keys.
2. Prevent an expense from referencing a category or creator in another tenant.
3. Query monthly totals and category summaries.
4. Audit inserts, updates, and deletes on expenses.
5. Isolate tenant rows with PostgreSQL Row-Level Security (RLS).
6. Apply schema changes through ordered Flyway migrations.
7. Support repeatable backups and a documented restore test.
8. Optionally cache derived monthly summaries in Redis; PostgreSQL remains the source of truth.

## Non-functional requirements
- Integrity: foreign keys, check constraints, and transactions.
- Security: no application superuser, RLS, restricted grants, and parameterized SQL.
- Performance: index tenant/date and category access paths; prove impact using EXPLAIN ANALYZE.
- Recovery: custom-format pg_dump backup and a restore drill.
- Maintainability: migrations and instructions kept in version control.

## Entities and relationships
Tenant 1—many Users; Tenant 1—many Categories; Tenant 1—many Expenses; User 1—many Expenses as creator; Category 1—many Expenses; Expense 1—many Audit Events.

## Scope and assumptions
Each expense stores one currency. Bank integrations and authentication are out of scope. Passwords are not stored here. Production authentication should use a trusted identity provider or a reviewed password-hashing implementation. RLS uses the session setting app.tenant_id, which trusted server-side code must set per transaction after authentication. Never let an untrusted client choose this value.

## Acceptance checks
- Flyway applies V1–V5 to an empty database.
- Cross-tenant references are rejected.
- A non-owner application role sees only its configured tenant.
- Expense changes create audit events.
- Actual query plans are recorded.
- A backup is restored into a separate test database and verified.
