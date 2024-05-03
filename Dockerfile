# 基於官方 PHP 8.0 鏡像
FROM php:8.0

# 安裝常用 PHP 擴展和依賴
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libpq-dev \
    libmcrypt-dev \
    libmagickwand-dev \
    libc-ares2 \
    libc-ares-dev \
    curl libcurl4 libcurl4-openssl-dev \
    && docker-php-ext-install -j$(nproc) \
    gd \
    zip \
    opcache \
    pdo_mysql \
    mysqli \
    pdo_pgsql \
    pcntl 


RUN pecl install redis

RUN curl -L https://pecl.php.net/get/swoole-4.8.6.tgz -o swoole.tgz \
    && tar xvzf swoole.tgz \
    && cd swoole-4.8.6 \
    && phpize \
    && ./configure --enable-openssl --enable-http2 --enable-mysqlnd --enable-swoole-json --enable-swoole-curl --enable-cares \
    && make && make install \
    && cd ../ \
    && rm -rf swoole-4.8.6 \
    && rm swoole.tgz

RUN docker-php-ext-enable redis swoole pcntl

# 修改 swoole.use_shortname
RUN echo "swoole.use_shortname = 'Off'" >> /usr/local/etc/php/php.ini

# 安裝 Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 安裝時區設置
RUN ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && echo Asia/Taipei > /etc/timezone
