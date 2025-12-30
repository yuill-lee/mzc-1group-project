<?php
// 도커 환경 변수를 읽어오고, 없으면 기본값인 'db'를 사용합니다.
<<<<<<< HEAD
$host = getenv('DB_HOST') ?: 'db'; // RDS를 사용할 경우 주석 처리 필요
// $host = getenv('DB_HOST') ?: '<DB_ENDPOINT>'; // RDS를 사용할 경우 주석 해제 후 사용
=======
$host = getenv('DB_HOST') ?: '<DB-ENDPOINT>'; 
>>>>>>> 7179fb69f3d6c88e3f16f3940d23c6fe31e05f9b
$user = getenv('DB_USER') ?: 'user01';
$pass = getenv('DB_PASS') ?: 'user01password';
$dbname = getenv('DB_NAME') ?: 'test_db';

$link = mysqli_connect($host, $user, $pass, $dbname);

if (!$link) {
    die("DB 연결 실패: " . mysqli_connect_error());
}
