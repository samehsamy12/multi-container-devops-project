#!/bin/bash
set -e

# تحميل متغيرات البيئة لضمان استخدام الأسماء العامة
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

DB_USER="${POSTGRES_USER:-app_user}"
DB_NAME="${POSTGRES_DB:-app_db}"
DB_PASSWORD="${POSTGRES_PASSWORD:-YourSecurePassword123}"

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DEST_DIR="$BACKUP_DIR/backup_$TIMESTAMP"

mkdir -p "$DEST_DIR"

echo "[*] Starting backup process..."

# 1. Backup PostgreSQL Database
if docker compose ps --services --filter "status=running" | grep -q "postgres"; then
    echo "[+] Backing up PostgreSQL database..."
    docker compose exec -T -e PGPASSWORD="$DB_PASSWORD" postgres pg_dump -h localhost -U "$DB_USER" -d "$DB_NAME" > "$DEST_DIR/database.sql"
else
    echo "[-] Database container is not running!"
fi

# 2. Backup Redis Data (AOF/Dump)
if docker compose ps --services --filter "status=running" | grep -q "redis"; then
    echo "[+] Backing up Redis data..."
    docker compose exec -T redis redis-cli SAVE || true
    docker cp $(docker compose ps -q redis):/data/dump.rdb "$DEST_DIR/" 2>/dev/null || echo "[!] Redis dump file not directly copied, skipping."
fi

# 3. Compress backup folder
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" -C "$BACKUP_DIR" "backup_$TIMESTAMP"
rm -rf "$DEST_DIR"

echo "[+] Backup completed successfully: $BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
