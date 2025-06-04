#!/usr/bin/env bash
#
# restore-db.sh  –  one-shot “copy + pg_restore” helper
#
#   ./restore-db.sh  perygondevdb.backup          # overwrites hospitality
#   ./restore-db.sh  perygondevdb.backup  perygon # loads into new DB named perygon
#
# Requirements:
#   * docker compose v2 (or the docker-compose v1 wrapper)
#   * a PostgreSQL custom-format dump (.backup / .bac / .sql produced with pg_dump -Fc)
#   * the service is called “db” in docker-compose.yml (as in your file)
#
set -euo pipefail
shopt -s nocasematch

FILE=${1:-}
NEW_DB=${2:-hospitality}

if [[ -z "$FILE" ]]; then
  echo "Usage: $0 <dump-file.backup> [target_db]" >&2
  exit 1
fi
if [[ ! -f "$FILE" ]]; then
  echo "Error: file '$FILE' not found" >&2
  exit 1
fi

echo "▶ starting / ensuring db container is up…"
docker compose up -d db

CID=$(docker compose ps -q db)
if [[ -z "$CID" ]]; then
  echo "Error: could not find running container for service 'db'." >&2
  exit 1
fi
echo "   container id: $CID"

echo "▶ copying dump into container…"
/usr/bin/docker cp "$FILE" "$CID":/tmp/

echo "▶ restoring into database '$NEW_DB'…"
/usr/bin/docker compose exec -T db sh -c "
  set -e
  # create target DB if it is not 'hospitality'
  if [ \"$NEW_DB\" != \"hospitality\" ]; then
    psql -U postgres -tc \"SELECT 1 FROM pg_database WHERE datname = '$NEW_DB'\" \
      | grep -q 1 || psql -U postgres -c \"CREATE DATABASE \\\"$NEW_DB\\\";\"
  fi
  pg_restore -U postgres \
             --dbname=\"$NEW_DB\" \
             --clean --if-exists --no-owner --exit-on-error \
             /tmp/$(basename "$FILE")
"

echo "✅ restore complete."
