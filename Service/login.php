<?php
// 1. 세션 시작 (반드시 최상단)
session_start();
include("includes/connect.php");

// 2. 입력값 필터링 (기존 방식 유지)
$admin_email = mysqli_real_escape_string($link, $_POST['email']);
$admin_pass = md5($_POST['password']);
$auth = 'admin_in';

// 3. 사용자 조회
$query = mysqli_query($link, "SELECT * FROM users WHERE email = '" . $admin_email . "' AND password = '" . $admin_pass . "'");

if (mysqli_num_rows($query) == 0) {
	// 로그인 실패 시 index로 이동
	header("location: index.php");
	exit();
} else {
	$row = mysqli_fetch_array($query);

	// 4. 세션 변수에 로그인 정보 저장 (쿠키 대신)
	$_SESSION['user_id'] = $row["id"];
	$_SESSION['user_name'] = $row["name"];
	$_SESSION['auth_status'] = $auth;

	// 5. DB 세션 테이블에 기록 (현재 세션 ID와 사용자 ID 연결)
	$sid = session_id();
	$uid = $row["id"];
	$ip = $_SERVER['REMOTE_ADDR'];

	// 기존 세션이 있다면 갱신, 없으면 삽입
	mysqli_query($link, "REPLACE INTO user_sessions (session_id, user_id, ip_address) VALUES ('$sid', '$uid', '$ip')");

	// 6. 메인 페이지로 이동
	header("location: home.php");
	exit();
}
