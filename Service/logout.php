<?php
session_start();
include "includes/connect.php";

// 쿠키나 세션에서 토큰 가져오기
$token = "";
if (isset($_SESSION['auth_token'])) $token = $_SESSION['auth_token'];
elseif (isset($_COOKIE['auth_token'])) $token = $_COOKIE['auth_token'];

if (!empty($token)) {
    // [핵심] DB에서 세션 삭제
    mysqli_query($link, "DELETE FROM user_sessions WHERE session_token = '$token'");
}

// 브라우저 쿠키 삭제
setcookie('auth_token', '', time() - 3600, '/');

// 세션 파괴
session_unset();
session_destroy();

header("location: index.php");
?>