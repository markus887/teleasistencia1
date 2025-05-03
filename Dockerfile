# Imagen base oficial de PHP con extensiones necesarias
FROM php:8.2-fpm

# Instala dependencias de sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpq-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_pgsql zip

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia el código al contenedor
COPY . /var/www/html

WORKDIR /var/www/html

# Instala dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Genera clave y cachea configuración
RUN php artisan key:generate && php artisan config:cache

# Expone el puerto que usará Laravel
EXPOSE 8000

# Comando de inicio
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
