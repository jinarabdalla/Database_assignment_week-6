# SpendWise Requirements Summary

## Purpose
SpendWise helps people record and review expenses. The schema supports multiple independent households or organizations (tenants), each with users, categories, and expenses.

## Functional requirements
1. Store tenants, tenant users, categories, and expenses with primary and foreign keys.
2. Store money as NUMERIC(12,2), not floating-point values.
3. Support filtering by date, category, and currency, and reporting totals by category/month.
4. Soft-delete expenses with deleted_at; exclude deleted rows from normal reports.
5. Record expense changes in an audit log.
6. Enforce tenant isolation with PostgreSQL row-level security (RLS).
7. Use versioned Flyway migrations and parameterized application queries.
8. Back up the database and test a restore into a separate database.

## Non-functional requirements
Security: least privilege and tenant isolation. Reliability: verifiable backups. Performance: indexes for tenant/date and tenant/category queries, validated using query plans. Maintainability: documented migrations. Privacy: synthetic demo data only; do not store card numbers or unnecessary sensitive information.

## Scope and assumptions
PostgreSQL is the durable source of truth. Redis is optional and only caches rebuildable dashboard summaries. Authentication, API authorization, secret management, monitoring, and deployment hardening must be completed before production use.

## Acceptance checks
- Fresh database migrates in version order.
- Constraints reject invalid data.
- RLS prevents a tenant-scoped runtime role from reading another tenant's rows.
- Expense changes create audit entries.
- Before/after query plans are captured on the same representative dataset.
- A backup restores into a separate test database and row counts are checked.