# PHP 8.3 (FPM 버전) 기반 이미지
FROM php:8.3-fpm

# [1단계] 필수 라이브러리 설치
# 이미지 처리(gd), DB 연결(mysql), 문자열 처리(mbstring) 등을 위해 리눅스 패키지 설치
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libcurl4-openssl-dev default-mysql-client \
    && docker-php-ext-install mysqli pdo_mysql mbstring gd curl

# [2단계] 외부 접속 허용 설정
# 기본적으로 PHP-FPM은 내부(127.0.0.1) 접속만 받지만,
# 컨테이너 환경에서는 외부(Web 서버)에서 접속해야 하므로 0.0.0.0(모든 곳)으로 엽니다.
RUN sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.d/www.conf

# 작업 디렉토리 설정
WORKDIR /var/www/html