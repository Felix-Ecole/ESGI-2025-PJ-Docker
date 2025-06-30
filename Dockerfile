FROM php:8.1-fpm

ARG SERVER_ID=1

# --- System dependencies ---
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip \
    vim \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    netcat-traditional \
    dos2unix \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# --- PHP extensions ---
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    zip \
    exif \
    pcntl \
    bcmath \
    gd

# --- Composer ---
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# --- Working directory ---
WORKDIR /var/www/html

# --- Entry point ---
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && dos2unix /usr/local/bin/docker-entrypoint.sh

ENV SERVER_ID=${SERVER_ID}

ENTRYPOINT ["bash", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm"]
