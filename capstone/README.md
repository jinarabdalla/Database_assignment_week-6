# SpendWise Database Capstone

A learning capstone for a multi-tenant expense tracker. PostgreSQL is the source of truth; Redis is an optional short-lived dashboard cache.

## Contents
- docs/requirements.md — requirements and scope
- docs/er-diagram.dbml — ER diagram source; paste into dbdiagram.io
- migrations/ — ordered Flyway migrations
- sql/analytics.sql — analytical query examples
- docs/query-optimization.md — reproducible plan comparison guide
- nosql/redis-design.md — Redis decision and design
- security/roles.sql — least-privilege role example
- scripts/backup_restore.sh — backup and restore test helper
- presentation/walkthrough.md — short presentation outline

## Quick start
Use PostgreSQL 15+, Flyway, and psql. Create an empty development database named capstone, then run:

    flyway -url=jdbc:postgresql://localhost:5432/capstone -user=YOUR_MIGRATION_USER -locations=filesystem:capstone/migrations migrate

Configure credentials securely. Never commit passwords. WARNING: flyway clean drops objects in the configured database; only use it with a disposable development database.

No performance improvement is claimed in advance. Capture real EXPLAIN (ANALYZE, BUFFERS) output on your own dataset and record measured results in docs/query-optimization.md. This is a learning prototype, not a production-ready financial product.