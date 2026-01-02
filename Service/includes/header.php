<?php
error_reporting(0);
session_start();
include __DIR__ . '/connect.php'; // DB 연결 필수

// 1. 쿠키에 토큰이 있는지 확인
$token = "";
if (isset($_SESSION['auth_token'])) {
    $token = $_SESSION['auth_token'];
} elseif (isset($_COOKIE['auth_token'])) {
    $token = $_COOKIE['auth_token'];
}

// 2. 토큰이 없으면 로그인 페이지로 튕겨냄
if (empty($token)) {
    header("location: /index.php");
    exit;
}

// 3. [핵심] DB에서 해당 토큰이 유효한지 검사 (이게 오토스케일링의 핵심!)
// 이 부분이 있어야 서버가 바뀌어도 DB를 보고 "아, 너 로그인한 사람이구나" 하고 알아챕니다.
$query = mysqli_query($link, "SELECT * FROM user_sessions WHERE session_token = '$token'");
if (mysqli_num_rows($query) == 0) {
    // DB에 토큰이 없으면(로그아웃 됨) 쿠키 지우고 튕겨냄
    setcookie('auth_token', '', time() - 3600, '/');
    session_destroy();
    header("location: /index.php");
    exit;
}

include __DIR__ . '/data.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Panel</title>
    
    <link href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.7/cosmo/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/includes/style.css">
    <link href="//cdn.datatables.net/1.10.16/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css" />
    </head>
<body>

<div class="wrapper">
    <nav id="sidebar" class="bg-primary">
        <div class="sidebar-header">
            <h3>Admin Panel</h3>
        </div>

        <ul class="list-unstyled components">
            <li><a href="/home.php"><i class="glyphicon glyphicon-home"></i> Home</a></li>
            <li>
                <a href="/users/users.php">
                    <i class="glyphicon glyphicon-remove"></i> Users 
                    <span class="pull-right"><?= counting("users", "id") ?></span>
                </a>
            </li>
            <li><a href="/monitoring/resources.php"><i class="glyphicon glyphicon-stats"></i> Monitoring</a></li>
            <li><a href="/logout.php"><i class="glyphicon glyphicon-log-out"></i> Logout</a></li>
        </ul>
    </nav>
    <div id="content">