# Database Assignment Week 6

This repository contains two PostgreSQL hands-on labs:

- **Backup, PITR, and replication:** see [backup_recovery_lab.md](backup_recovery_lab.md).
- **Audit logging, category trees, safe migrations, and least-privilege security:** see the files below.

## Audit and migration lab

```text
migrations/
  V1__core_tables.sql
  V2__audit_log.sql
  V3__categories.sql
sql/
  demo_audit.sql
  demo_category_tree.sql
  security_roles.sql
```

### Requirements
PostgreSQL, Flyway CLI, and a test database named `bootcamp`.

Create the database as an administrator if needed:
```sql
CREATE DATABASE bootcamp;
```

From the project root, run migrations:
```bash
flyway -url=jdbc:postgresql://localhost:5432/bootcamp -user=postgres -locations=filesystem:migrations migrate
flyway -url=jdbc:postgresql://localhost:5432/bootcamp -user=postgres -locations=filesystem:migrations info
```
Configure credentials securely on your own machine; never commit passwords.

Test audit logging:
```bash
psql -d bootcamp -f sql/demo_audit.sql
```

Test the recursive category query:
```bash
psql -d bootcamp -f sql/demo_category_tree.sql
```

The optional `sql/security_roles.sql` must be reviewed and run as a database administrator. It contains no active login password; replace the commented placeholder only if you need a login role.

**Safety:** Use a development database and take backups before testing destructive statements. The audit demo deletes sample student id 3.
