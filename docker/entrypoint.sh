#!/bin/bash
set -e

# 1. Setup Folder & Permissions
mkdir -p storage/app/private/berkas storage/app/private/backups storage/framework/sessions storage/framework/views storage/framework/cache
chown -R www-data:www-data storage bootstrap/cache

# 2. Wait for Database (Opsional tapi disarankan)
# if [ "$DB_CONNECTION" = "pgsql" ]; then
#     until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME"; do
#       echo "Waiting for postgres..."
#       sleep 2
#     done
# fi

# 3. Laravel Setup
php artisan storage:link --force

# 4. Eksekusi Command
# Jika script dipanggil tanpa argumen, jalankan Octane sebagai default
if [ $# -eq 0 ]; then
    echo "Starting Octane..."
    exec php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=8000
else
    # Jika ada argumen (seperti 'php artisan queue:work'), jalankan argumen tersebut
    echo "Executing command: $@"
    exec "$@"
fi