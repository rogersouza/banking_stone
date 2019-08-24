#!/bin/sh
set -e

until psql -h db -U "postgres" -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - waiting 1s"
  sleep 1
done

cd banking_umbrella
mix do ecto.create, ecto.migrate, phx.server