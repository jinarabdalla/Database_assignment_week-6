#!/usr/bin/env bash
set -euo pipefail
DB_NAME="${PGDATABASE:-capstone}"
BACKUP_DIR="${BACKUP_DIR:-backups}"
STAMP="$(date +%F)"
BACKUP_FILE="$BACKUP_DIR/capstone_$STAMP.dump"
mkdir -p "$BACKUP_DIR"
pg_dump --format=custom --file="$BACKUP_FILE" "$DB_NAME"
pg_restore --list "$BACKUP_FILE" >/dev/null
printf 'Backup created and archive listing verified: %s\n' "$BACKUP_FILE"
printf 'Next, restore into a separate test database as documented in capstone/docs/backup_restore.md\n'
