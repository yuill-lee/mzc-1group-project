# Apache 2.4 기반 이미지 사용
FROM httpd:2.4

# -----------------------------------------------------------------
# [1단계] 설정 파일 복사 (가장 중요!)
# 우리가 만든 설정을 아파치 설정 폴더로 복사합니다.
COPY .docker/web/my-httpd.conf /usr/local/apache2/conf/extra/my-httpd.conf

# 기본 httpd.conf 파일 맨 끝에 "우리 설정을 포함하라"는 명령어를 추가합니다.
RUN echo "Include conf/extra/my-httpd.conf" >> /usr/local/apache2/conf/httpd.conf
# -----------------------------------------------------------------

# [2단계] 소스코드 디렉토리 생성 및 권한 부여
# K8s나 Docker Compose가 볼륨을 마운트할 때 권한 문제가 없도록 미리 설정
RUN mkdir -p /var/www/html/Service && \
    chown -R daemon:daemon /var/www/html && \
    chmod -R 755 /var/www/html

# [3단계] 필수 모듈 활성화
# 프록시(WAS 연결), 로드밸런싱 등에 필요한 모듈의 주석(#)을 제거(sed)합니다.
RUN sed -i \
    -e 's/^#\(LoadModule proxy_module modules\/mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule proxy_fcgi_module modules\/mod_proxy_fcgi.so\)/\1/' \
    -e 's/^#\(LoadModule proxy_balancer_module modules\/mod_proxy_balancer.so\)/\1/' \
    -e 's/^#\(LoadModule slotmem_shm_module modules\/mod_slotmem_shm.so\)/\1/' \
    -e 's/^#\(LoadModule rewrite_module modules\/mod_rewrite.so\)/\1/' \
    conf/httpd.conf