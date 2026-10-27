# Hands-On Lab: Backups, PITR, and Replication

## Objectives

- Create and inspect a PostgreSQL logical backup with `pg_dump`.
- Configure Write-Ahead Log (WAL) archiving.
- Restore a database to a point before an accidental change.
- Set up a basic streaming standby.
- Check replication status.

> **Safety:** Use a disposable PostgreSQL test instance and sample data. These steps change PostgreSQL configuration and may stop/restart the server. Never test destructive commands on a production database. Commands and paths vary by operating system and PostgreSQL version.

## 1. Create a sample database and logical backup

Connect to PostgreSQL as a database administrator, then create a test database if needed:

```sql
CREATE DATABASE bootcamp_check;
```

Connect to the database and create a sample table and rows:

```sql
CREATE TABLE students (
    id integer PRIMARY KEY,
    full_name text NOT NULL
);

INSERT INTO students (id, full_name) VALUES
    (1, 'Amina Hassan'),
    (2, 'Mohamed Ali'),
    (3, 'Fatima Noor');
SELECT * FROM students ORDER BY id;
```

In a terminal, create a custom-format backup. Replace `myuser` with your PostgreSQL role:

```bash
pg_dump -U myuser -d bootcamp_check -Fc -f bootcamp_check.dump
pg_restore -l bootcamp_check.dump
```

Restore into a separate, empty database to test the backup:

```bash
createdb -U myuser bootcamp_restore_test
pg_restore -U myuser -d bootcamp_restore_test bootcamp_check.dump
psql -U myuser -d bootcamp_restore_test -c "SELECT * FROM students ORDER BY id;"
```

**Expected result:** all three sample rows are present in `bootcamp_restore_test`. Keep the original database unchanged.

## 2. Enable WAL archiving

WAL files record database changes and are needed for point-in-time recovery. First find the active configuration file:

```sql
SHOW config_file;
SHOW data_directory;
SHOW wal_level;
SHOW archive_mode;
SHOW archive_command;
```

Create an archive directory that the PostgreSQL server account can write to. The following is an example for a Linux lab; adjust the location and ownership for your system:

```bash
sudo mkdir -p /var/lib/postgresql/wal_archive
sudo chown postgres:postgres /var/lib/postgresql/wal_archive
sudo chmod 700 /var/lib/postgresql/wal_archive
```

In `postgresql.conf`, configure the following settings (use the actual absolute path):

```conf
wal_level = replica
archive_mode = on
archive_command = 'test ! -f /var/lib/postgresql/wal_archive/%f && cp %p /var/lib/postgresql/wal_archive/%f'
```

Restart PostgreSQL for `archive_mode` to take effect. Use your operating system's service manager; the service name may differ. Then verify:

```sql
SHOW wal_level;
SHOW archive_mode;
SHOW archive_command;
SELECT * FROM pg_stat_archiver;
```

Generate some activity and request a WAL switch:

```sql
SELECT pg_switch_wal();
SELECT * FROM pg_stat_archiver;
```

Check that WAL files are being written to the archive directory and review PostgreSQL logs for archive errors. Do not delete archived WAL files that may be needed for recovery.

## 3. Take a base backup for PITR

A logical `pg_dump` backup alone is not enough for WAL-based PITR. You need a physical base backup plus every required archived WAL file.

Example, run with appropriate PostgreSQL permissions and a destination that does not already contain a backup:

```bash
sudo -u postgres pg_basebackup \
  -D /var/backups/pg_basebackup_week6 \
  -Fp -X stream -P
```

Store the backup and WAL archive safely. In a real environment, ensure backups are copied to separate storage and that retention policies preserve the required WAL files.

## 4. Practice point-in-time recovery (PITR)

Do this only in a separate recovery/test instance. Before making the test change, record the current timestamp from the database:

```sql
SELECT clock_timestamp();
```

Record the returned timestamp and timezone as `TARGET_TIME`. Then perform a test change in the original lab database:

```sql
DELETE FROM students WHERE id = 2;
SELECT * FROM students ORDER BY id;
```

To recover a physical backup, restore the base backup into a separate, empty data directory owned by the PostgreSQL service account. Configure that recovery instance to read from the WAL archive. For PostgreSQL 12 and later, add a file named `recovery.signal` to the restored data directory and set these parameters in its `postgresql.conf`:

```conf
restore_command = 'cp /var/lib/postgresql/wal_archive/%f %p'
recovery_target_time = 'TARGET_TIME'
recovery_target_action = 'pause'
```

Replace `TARGET_TIME` with the actual timestamp recorded **before** the DELETE, in a format PostgreSQL accepts. The archive path and file permissions must be correct. Start the recovery instance using a separate port and data directory so it cannot overwrite or conflict with the original server. Follow your platform's PostgreSQL recovery procedure and logs.

**Verify:** query `students` on the recovered instance. The row with `id = 2` should be present if the target time is before the DELETE and the required WAL files are available. If recovery pauses at the target, verify the data before allowing recovery to continue.

## 5. Set up a streaming standby (replication practice)

Use a second PostgreSQL instance or machine. This section requires network access and appropriate privileges.

On the primary, create a dedicated replication role with a strong password:

```sql
CREATE ROLE replicator WITH LOGIN REPLICATION PASSWORD 'REPLACE_WITH_A_STRONG_PASSWORD';
```

In the primary server's `pg_hba.conf`, add a rule limited to the standby's real IP address and your replication role. Example only:

```conf
host  replication  replicator  192.0.2.25/32  scram-sha-256
```

Replace `192.0.2.25/32` with the standby's actual address. Reload the primary configuration and confirm the primary is reachable from the standby. Keep the firewall restricted to trusted hosts.

On the standby, stop PostgreSQL and use an empty data directory owned by the PostgreSQL service account. Take a base backup from the primary; replace host, port, user, and destination as appropriate:

```bash
pg_basebackup -h PRIMARY_HOST -p 5432 -U replicator \
  -D /path/to/standby_data -Fp -Xs -P -R
```

The `-R` option writes standby connection settings (including a standby signal file) for supported PostgreSQL versions. Secure credentials using a protected password file or another approved secret method; do not put real passwords in GitHub. Start the standby and check the server logs.

## 6. Monitor replication

Run on the **primary**:

```sql
SELECT
    application_name,
    client_addr,
    state,
    sync_state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn
FROM pg_stat_replication;
```

A connected standby normally appears with a state such as `streaming`. No rows may mean that no standby is connected, or replication is not configured correctly. Check host access rules, network/firewall, role permissions, connection settings, and PostgreSQL logs.

## 7. Evidence and checklist

- [ ] Created a custom-format logical dump with `pg_dump -Fc`.
- [ ] Listed the dump contents and restored it into a separate test database.
- [ ] Enabled WAL archiving and checked `pg_stat_archiver`.
- [ ] Took a physical base backup.
- [ ] Practiced PITR on an isolated recovery instance and verified the deleted row was restored.
- [ ] Configured a test standby and checked `pg_stat_replication`.
- [ ] Recorded screenshots or command output showing successful verification.

## Key terms

- **Logical backup:** a backup of database objects and data, commonly made with `pg_dump`.
- **WAL:** Write-Ahead Log, a record of database changes.
- **PITR:** Point-in-Time Recovery; restoring a database to a chosen time using a base backup and archived WAL.
- **Streaming replication:** continuously sending WAL changes from a primary server to a standby server.
- **RPO:** the amount of data loss an organization can tolerate, measured in time or data.
- **RTO:** the maximum acceptable time to restore service.

## References

- PostgreSQL documentation: `pg_dump` and `pg_restore`
- PostgreSQL documentation: Continuous Archiving and Point-in-Time Recovery
- PostgreSQL documentation: Streaming Replication
