# Menggunakan image resmi FrankenPHP dengan PHP 8.4
FROM dunglas/frankenphp:1-php8.4

# 1. Install sistem dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Install ekstensi PHP yang dibutuhkan (Sesuai Master Prompt)
RUN install-php-extensions \
    pdo_pgsql \
    pgsql \
    redis \
    pcntl \
    gd \
    intl \
    zip \
    opcache \
    bcmath \
    exif

# 3. Ambil binari Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Pengaturan PHP untuk Produksi
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 5. Set Working Directory
WORKDIR /app

# 6. Salin dependensi dulu untuk optimasi cache
COPY composer.json composer.lock* ./
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-interaction

# 7. Salin seluruh kode aplikasi
COPY . .

# 8. Set Izin Folder (Penting untuk Laravel)
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# 9. Jalankan entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]