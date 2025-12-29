<?php
// 도커 환경 변수를 읽어오고, 없으면 기본값인 'db'를 사용합니다.
$host = getenv('DB_HOST') ?: '<DB-ENDPOINT>'; 
$user = getenv('DB_USER') ?: 'user01';
$pass = getenv('DB_PASS') ?: 'user01password';
$dbname = getenv('DB_NAME') ?: 'test_db';

$link = mysqli_connect($host, $user, $pass, $dbname);

if (!$link) {
    die("DB 연결 실패: " . mysqli_connect_error());
}
?>