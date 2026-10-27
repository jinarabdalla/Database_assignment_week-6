# SpendWise Capstone Walkthrough

1. **Problem:** record expenses and understand monthly spending while keeping tenant data separated.
2. **Requirements and ERD:** show docs/requirements.md and render docs/er-diagram.dbml at dbdiagram.io.
3. **Architecture:** PostgreSQL stores durable data; Redis optionally caches short-lived dashboard summaries; the app uses parameterized queries and trusted tenant context.
4. **Migrations:** explain V1 core tables, V2 indexes, V3 audit trigger, V4 RLS, and V5 synthetic seed data.
5. **Security:** demonstrate least privilege, tenant policies, audit history, and why secrets are not committed.
6. **Optimization:** show real before/after EXPLAIN (ANALYZE, BUFFERS) plans and measured results from the test environment.
7. **Backup:** create a custom-format backup, restore to a separate test database, and verify row counts.
8. **Limitations:** this is a database learning prototype; production authentication, API authorization, monitoring, and deployment hardening remain future work.

Demo checklist: fresh migrations succeed; tenant isolation is tested using a runtime role; expense changes create audit records; real query plans are recorded; backup restore is verified.