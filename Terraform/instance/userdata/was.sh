#!/bin/bash
# 1. SSH 설정
# Turn on password authentication
echo 'ubuntu:hackers' | sudo chpasswd
sudo sed -i 's/Include/#Include/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

# 2. 도커 및 도커 컴포즈 설치
sudo apt-get update -y
sudo apt-get install -y docker.io git mysql-client
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl start docker

# 3. 프로젝트 클론
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app
git clone -b main https://github.com/yuill-lee/mzc-1group-project.git .

# 4. 권한 설정
sudo chmod -R 755 /home/ubuntu/app/Service

# 5. DB IP 설정
# [중요] DB_IP는 테라폼에서 생성된 실제 DB 프라이빗 IP로 치환되어야 함
DB_IP="10.0.2.236" 

# 6. [핵심 추가] docker-compose.yml 내의 호스트명을 실제 IP로 변경
# 이 과정이 있어야 php_network_getaddresses 에러를 방지할 수 있습니다.
sed -i "s/DB_HOST=db/DB_HOST=$DB_IP/g" /home/ubuntu/app/docker-compose.yml

# 7. DB 데이터 임포트 (DB 서버가 켜질 때까지 20초 대기)
sleep 20 
mysql -h $DB_IP -u user01 -puser01 test_db < /home/ubuntu/app/Service/data.sql

# 8. WAS 컨테이너 실행
sudo /usr/local/bin/docker-compose up -d was