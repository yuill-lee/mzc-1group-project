<?php
session_start();
include "connect.php";

$sid = session_id();
// 1. DB에서 세션 삭제
mysqli_query($link, "DELETE FROM user_sessions WHERE session_id = '$sid'");

// 2. PHP 세션 파괴
session_unset();
session_destroy();

header("location: /index.php");
exit();
