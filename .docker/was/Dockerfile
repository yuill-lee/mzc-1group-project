FROM php:8.3-fpm

# 필수 라이브러리 및 PHP 확장 모듈 설치
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install mysqli pdo_mysql mbstring gd curl

# 외부(Apache) 접속을 허용하도록 설정
RUN sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www/html