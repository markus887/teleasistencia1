# Usa una imagen oficial de PHP con FPM
FROM php:8.2-fpm

# Instala extensiones necesarias y herramientas básicas
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpq-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

# Instala Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia el código de la app al contenedor
COPY . /var/www/html

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Instala dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Expone el puerto por el que Laravel escuchará
EXPOSE 8000

# Comando para arrancar la app (Laravel usará variables desde Render)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
