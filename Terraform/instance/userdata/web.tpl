#!/bin/bash
# Turn on password authentication
echo 'ubuntu:hackers' | sudo chpasswd
sudo sed -i 's/Include/#Include/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

# 1. Apache 설치 및 프록시 모듈 활성화
sudo apt-get update -y
sudo apt-get install -y apache2 git
sudo a2enmod proxy proxy_fcgi
sudo systemctl restart apache2

# 2. 정적 파일(CSS)만 가져오기 (Sparse Checkout)
sudo mkdir -p /var/www/html
cd /var/www/html
sudo git init
sudo git remote add origin https://github.com/yuill-lee/mzc-1group-project.git
sudo git config core.sparseCheckout true
sudo echo "Service/includes/style.css" >> .git/info/sparse-checkout
sudo echo "Service/library/style.css" >> .git/info/sparse-checkout
sudo git pull origin main

# 3. Apache VirtualHost 설정 (WAS IP 주입)
# [중요] WAS_IP는 테라폼에서 생성된 실제 WAS 프라이빗 IP로 치환되어야 함
WAS_IP="${WAS_IP}"
sudo cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    DocumentRoot /var/www/html/Service
    DirectoryIndex index.php index.html

    <Directory /var/www/html/Service>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # PHP 요청 전달 (루트 및 전체 php 경로)
    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://${WAS_IP}:9000/var/www/html/Service/\$1
    ProxyPassMatch ^/$ fcgi://${WAS_IP}:9000/var/www/html/Service/index.php

    ErrorLog $${APACHE_LOG_DIR}/error.log
    CustomLog $${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo systemctl restart apache2