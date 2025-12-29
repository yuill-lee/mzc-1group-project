#!/bin/bash
# 패키지 목록 업데이트
sudo apt-get update -y

# MySQL 클라이언트 및 Git 설치
sudo apt-get install -y git mysql-client

cd /home/ubuntu

# 프로젝트 다운로드
git clone https://github.com/yuill-lee/mzc-1group-project.git

# 변수 설정
RDS_HOST="${rds_endpoint}"
DB_USER="user01"
DB_PASS="user01password"
DB_NAME="test_db"

# SQL 파일 위치
SQL_FILE="/home/ubuntu/mzc-1group-project/data.sql"

# 데이터 밀어넣기 명령어
if [ -f "$SQL_FILE" ]; then
    # -p와 비밀번호 사이에는 공백이 없어야 합니다 (-pPASSWORD)
    mysql -h "$RDS_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"
    
    if [ $? -eq 0 ]; then
        echo "✅ 성공: 데이터가 정상적으로 입력되었습니다."
        
        # 확인을 위해 테이블 목록 출력
        echo "📊 생성된 테이블 목록:"
        mysql -h "$RDS_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SHOW TABLES;"
    else
        echo "❌ 실패: 접속 정보나 보안 그룹(SG)을 확인해주세요."
    fi
else
    echo "❌ 에러: SQL 파일을 찾을 수 없습니다. 경로를 확인해주세요: $SQL_FILE"
fi