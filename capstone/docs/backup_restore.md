# Backup and Restore Runbook

Create a custom-format backup:
mkdir -p backups
pg_dump -Fc -f "backups/capstone_$(date +%F).dump" capstone

Verify archive readability:
pg_restore --list backups/capstone_YYYY-MM-DD.dump

Test restore to a separate database:
createdb capstone_restore_test
pg_restore --verbose --no-owner --dbname=capstone_restore_test backups/capstone_YYYY-MM-DD.dump
psql -d capstone_restore_test -c "\dt"
psql -d capstone_restore_test -c "SELECT count(*) FROM expenses;"

Record the backup date, restore duration, row counts, and errors. Drop the test database only after verification. Use PG environment variables or .pgpass securely. Never commit passwords or real personal data. A backup is not proven until restoration has been tested.
