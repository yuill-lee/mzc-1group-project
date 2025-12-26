FROM httpd:2.4

# Apache 내부 설정에서 Proxy 모듈 주석 해제
RUN sed -i \
    -e 's/^#\(LoadModule proxy_module modules\/mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule proxy_fcgi_module modules\/mod_proxy_fcgi.so\)/\1/' \
    conf/httpd.conf

# 우리가 작성한 상세 설정 파일을 컨테이너 안으로 복사
COPY .docker/web/my-httpd.conf /usr/local/apache2/conf/extra/my-httpd.conf
RUN echo "Include conf/extra/my-httpd.conf" >> /usr/local/apache2/conf/httpd.conf