# SpendWise Capstone — Walkthrough Presentation

## Slide 1 — Problem
SpendWise records expenses and shows monthly and category spending. The goal is reliable data, tenant isolation, and maintainable changes.

## Slide 2 — Requirements and ER diagram
Render dbdiagram.dbml in dbdiagram.io. Explain Tenant, Users, Categories, Expenses, and Expense Audit. Composite foreign keys block cross-tenant references.

## Slide 3 — Architecture
Application → PostgreSQL source of truth → optional Redis cache for dashboard summaries. MongoDB is not needed for the relational core.

## Slide 4 — Migrations
Explain V1 core tables, V2 indexes, V3 audit trigger, V4 RLS, and V5 demo rows. Show your actual Flyway output.

## Slide 5 — Security
Show non-superuser roles, tenant context per transaction, RLS policies, audit records, parameterized queries, and no secrets in Git. Tenant context must come from authenticated server-side identity.

## Slide 6 — Optimization
Show actual before/after EXPLAIN ANALYZE output, dataset size, buffer reads, and elapsed time. Do not present placeholder numbers as results.

## Slide 7 — Backup and recovery
Show the custom-format backup, archive listing, restore into a separate database, and row-count verification.

## Slide 8 — Lessons and next steps
Summarize trade-offs, measured results, limitations, and future improvements.

## Final checklist
- [ ] ER diagram rendered/exported
- [ ] Fresh database migration output captured
- [ ] RLS tested as a non-owner role
- [ ] Audit trigger verified
- [ ] Real before/after plans recorded
- [ ] Backup restored and verified
- [ ] No secrets or real personal data committed
