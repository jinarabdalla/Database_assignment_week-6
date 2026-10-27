# SpendWise Database Capstone

A PostgreSQL-first multi-tenant expense tracker for the Database Systems Capstone Build Sprint.

## Contents
- requirements.md: one-page requirements summary
- dbdiagram.dbml: ER diagram source for dbdiagram.io
- migrations/: ordered Flyway migrations V1–V5
- sql/analytics.sql: analytical queries
- sql/security_roles.sql: least-privilege role setup
- docs/nosql_design.md: Redis design decision
- docs/optimization_evidence.md: before/after evidence template
- docs/backup_restore.md and scripts/backup_restore.sh: backup runbook
- docs/presentation.md: final walkthrough presentation outline

## Run locally
Requirements: PostgreSQL 15+, Flyway CLI, psql, and pg_dump. Redis is optional.

1. Create an empty database named capstone.
2. Configure Flyway connection settings securely in your shell.
3. Run: flyway -locations=filesystem:capstone/migrations migrate
4. Run analytics with: psql "$DATABASE_URL" -f capstone/sql/analytics.sql
5. Review sql/security_roles.sql and run as a database administrator if appropriate.

Important: actual migration success, EXPLAIN ANALYZE measurements, RLS tests, and a test restore must be performed in your environment. No performance results are fabricated in this submission. Use a disposable development database for testing.
