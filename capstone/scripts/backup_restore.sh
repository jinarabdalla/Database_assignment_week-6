#!/usr/bin/env bash
set -euo pipefail
DB_NAME="${DB_NAME:-capstone}"
BACKUP_DIR="${BACKUP_DIR:-backups}"
STAMP="$(date +%F_%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/capstone_$STAMP.dump"
RESTORE_DB="${RESTORE_DB:-capstone_restore_test}"
mkdir -p "$BACKUP_DIR"
pg_dump -Fc -d "$DB_NAME" -f "$BACKUP_FILE"
pg_restore --list "$BACKUP_FILE" >/dev/null
echo "Backup archive verified: $BACKUP_FILE"
echo "Restore target must be a disposable database: $RESTORE_DB"
createdb "$RESTORE_DB"
pg_restore --clean --if-exists --no-owner --dbname="$RESTORE_DB" "$BACKUP_FILE"
psql --dbname="$RESTORE_DB" -v ON_ERROR_STOP=1 -c "SELECT 'tenants' AS table_name, count(*) FROM tenants;"
echo "Restore test completed; inspect data and clean up the test database when finished."