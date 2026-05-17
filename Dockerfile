# Menggunakan image resmi FrankenPHP (Debian-based recommended)
FROM dunglas/frankenphp:1-php8.4

# 1. Install sistem dependencies yang diperlukan Composer & PHP
# FrankenPHP menggunakan Debian secara default, jadi gunakan apt-get
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Install ekstensi PHP menggunakan script pembantu bawaan FrankenPHP
RUN install-php-extensions \
    pdo_pgsql \
    pgsql \
    redis \
    pcntl \
    gd \
    intl \
    zip \
    opcache \
    bcmath

# 3. Ambil binari Composer dari image resmi (Metode paling aman & bersih)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Pengaturan Produksi
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
ENV SERVER_NAME=":80"
ENV OCTANE_SERVER="frankenphp"

WORKDIR /app

# 5. Optimasi Layer Docker: Copy file composer dulu agar tidak install ulang jika kode berubah
COPY composer.json composer.lock* ./
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-interaction

# 6. Salin seluruh kode aplikasi
COPY . .

# 7. Pengaturan Izin (Sangat Penting untuk Laravel)
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# 8. Entrypoint sesuai standar Laravel Octane
# ENTRYPOINT ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=80"]
ENTRYPOINT ["php", "artisan"]

# Berikan default command (bisa ditimpa saat docker-compose run)
# CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=80"]
CMD ["octane:frankenphp", "--host=0.0.0.0", "--port=8000"]