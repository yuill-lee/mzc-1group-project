#!/bin/bash
# Turn on password authentication
echo 'ubuntu:hackers' | sudo chpasswd
sudo sed -i 's/Include/#Include/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

# 1. PHP 8.3 및 필수 모듈 설치
sudo apt-get update -y
sudo apt-get install -y php8.3-fpm php8.3-mysql php8.3-mbstring php8.3-gd php8.3-curl mysql-client git

# 2. PHP-FPM 네트워크 설정 (503 에러 방지의 핵심)
# 9000번 포트 리스닝 및 접근 제한 완전히 해제 (주석 처리)
sudo sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php/8.3/fpm/pool.d/www.conf
sudo sed -i 's/^listen.allowed_clients = /;listen.allowed_clients = /' /etc/php/8.3/fpm/pool.d/www.conf
sudo systemctl restart php8.3-fpm

# 3. 소스 코드 가져오기 (경로 중첩 방지를 위해 현재 디렉토리에 클론)
sudo mkdir -p /var/www/html
cd /var/www/html
sudo git clone -b main https://github.com/yuill-lee/mzc-1group-project.git .

# 4. DB 접속 정보 수정 (오타 방지 및 실제 DB IP 반영)
# [중요] DB_IP는 테라폼에서 생성된 실제 DB 프라이빗 IP로 치환되어야 함
DB_IP="10.0.2.236" 
TARGET_FILE="/var/www/html/Service/includes/connect.php"
sudo sed -i "s/mysqli_connect([\"'][^\"']*[\"'], [\"'][^\"']*[\"'], [\"'][^\"']*[\"'])/mysqli_connect(\"$DB_IP\", \"user01\", \"user01\")/g" $TARGET_FILE

# 5. 권한 설정 및 데이터 임포트
sudo chown -R www-data:www-data /var/www/html
sudo mysql -h $DB_IP -u user01 -puser01 test_db < /var/www/html/Service/data.sql