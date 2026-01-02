<?php
session_start();
include "includes/connect.php";

$admin_email = mysqli_real_escape_string($link, $_POST['email']);
$admin_pass = md5($_POST['password']);

// 사용자 확인
$query = mysqli_query($link, "SELECT * FROM users WHERE email = '".$admin_email."' AND password = '".$admin_pass."'");

if (mysqli_num_rows($query) == 0) {
    echo "<script>alert('로그인 실패: 정보를 확인하세요.'); location.href='index.php';</script>";
} else {
    $row = mysqli_fetch_array($query);
    
    // [핵심] 랜덤 토큰 생성 (보안성이 높음)
    $token = bin2hex(random_bytes(32)); 
    $user_id = $row['id'];
    $ip = $_SERVER['REMOTE_ADDR'];

    // [핵심] 기존 세션 정보 삭제 (중복 로그인 방지용, 선택사항)
    mysqli_query($link, "DELETE FROM user_sessions WHERE user_id = '$user_id'");

    // [핵심] DB에 세션 토큰 저장
    $insert = "INSERT INTO user_sessions (user_id, session_token, ip_address) VALUES ('$user_id', '$token', '$ip')";
    mysqli_query($link, $insert);

    // [핵심] 사용자 브라우저에 토큰을 쿠키로 발급 (1일 유지)
    setcookie('auth_token', $token, time() + (86400 * 1), "/"); 

    // PHP 세션에도 임시 저장 (퍼포먼스용)
    $_SESSION['auth_token'] = $token;

    header("location: home.php");
}
?>