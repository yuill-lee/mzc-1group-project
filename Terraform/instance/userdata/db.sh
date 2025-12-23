#!/bin/bash
# Turn on password authentication
echo 'ubuntu:hackers' | sudo chpasswd
sudo sed -i 's/Include/#Include/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

apt-get update -y
apt-get install -y mysql-server

# 외부 접속 허용 설정
sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

# WAS 대역(10.0.2.x)에서 오는 3306 포트 허용
# ufw allow from 10.0.2.0/24 to any port 3306 proto tcp

mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS test_db;
-- 같은 프라이빗 서브넷(10.0.2.x) 대역의 모든 WAS 접속 허용
CREATE USER IF NOT EXISTS 'user01'@'10.0.2.%' IDENTIFIED BY 'user01';
GRANT ALL PRIVILEGES ON test_db.* TO 'user01'@'10.0.2.%';
FLUSH PRIVILEGES;
EOF