FROM httpd:2.4
# Apache 모듈 활성화 (기존 유지)
RUN sed -i \
    -e 's/^#\(LoadModule proxy_module modules\/mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule proxy_fcgi_module modules\/mod_proxy_fcgi.so\)/\1/' \
    conf/httpd.conf
# 설정 파일 복사
COPY .docker/web/my-httpd.conf /usr/local/apache2/conf/extra/my-httpd.conf
RUN echo "Include conf/extra/my-httpd.conf" >> /usr/local/apache2/conf/httpd.conf
# [추가] 웹 서버가 파일을 읽을 수 있도록 디렉토리 생성 및 권한 부여
RUN mkdir -p /var/www/html/Service && \
    chown -R daemon:daemon /var/www/html && \
    chmod -R 755 /var/www/html
    # 로드밸런싱 및 프록시 관련 필수 모듈 활성화
RUN sed -i \
    -e 's/^#\(LoadModule proxy_module modules\/mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule proxy_fcgi_module modules\/mod_proxy_fcgi.so\)/\1/' \
    -e 's/^#\(LoadModule proxy_balancer_module modules\/mod_proxy_balancer.so\)/\1/' \
    -e 's/^#\(LoadModule lbmethod_byrequests_module modules\/mod_lbmethod_byrequests.so\)/\1/' \
    -e 's/^#\(LoadModule slotmem_shm_module modules\/mod_slotmem_shm.so\)/\1/' \
    conf/httpd.conf
# 설정 파일 주입
COPY .docker/web/my-httpd.conf /usr/local/apache2/conf/extra/my-httpd.conf
RUN echo "Include conf/extra/my-httpd.conf" >> /usr/local/apache2/conf/httpd.conf