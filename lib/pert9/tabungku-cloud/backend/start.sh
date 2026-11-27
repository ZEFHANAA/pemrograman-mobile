#!/bin/sh
set -e

echo "Menjalankan migrasi database Alembic..."
percobaan=0
while [ "$percobaan" -lt 10 ]; do
  percobaan=$((percobaan + 1))
  if alembic upgrade head; then
    break
  fi
  if [ "$percobaan" -eq 10 ]; then
    echo "Migrasi database gagal setelah 10 percobaan."
    exit 1
  fi
  echo "Database belum siap, mencoba lagi dalam 3 detik... ($percobaan/10)"
  sleep 3
done

echo "Menjalankan TabungKu Cloud API..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
