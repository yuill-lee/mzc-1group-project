#!/bin/bash
# 1. SSH 설정
# Turn on password authentication
echo 'ubuntu:hackers' | sudo chpasswd
sudo sed -i 's/Include/#Include/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

# 2. 도커 및 도커 컴포즈 설치
sudo apt-get update -y
sudo apt-get install -y docker.io git
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl start docker

# 3. 프로젝트 클론
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app
git clone -b main https://github.com/yuill-lee/mzc-1group-project.git .

# 4. WAS IP 설정
# [중요] WAS_IP는 테라폼에서 생성된 실제 WAS 프라이빗 IP로 치환되어야 함
WAS_IP="${WAS_IP}"

# 5. [핵심 수정] 아파치 설정 파일에서 'was:9000' 또는 기존 IP를 현재 WAS IP로 변경
sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:9000/$WAS_IP:9000/g" /home/ubuntu/app/.docker/web/my-httpd.conf
sed -i "s/was:9000/$WAS_IP:9000/g" /home/ubuntu/app/.docker/web/my-httpd.conf

# 6. 아파치 권한 에러(403) 해결
sudo chmod -R 755 /home/ubuntu/app/Service

cat <<EOF > /home/ubuntu/app/docker-compose.override.yml
version: '3'
services:
  web:
    ports:
      - "80:80"
EOF

# 7. Web 컨테이너 실행
sudo /usr/local/bin/docker-compose up -d web