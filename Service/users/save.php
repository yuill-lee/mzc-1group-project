<?php
include __DIR__ . "/../includes/connect.php";

// 1. 모든 Undefined array key 에러 방지
$cat     = $_POST['cat'];
$act     = $_POST['act'];
$id      = $_POST['id'];

if ($cat == "users") {
    // 2. 보안 기능 없이 변수만 할당 (Warning 방지)
    $password  = $_POST["password"] ?? '';
    $name      = $_POST["name"] ?? '';
    $email     = $_POST["email"] ?? '';

    // 3. 작업 로직
    if ($act == "add") {
        // 'role' 컬럼이 숫자형이므로 문자 'user' 대신 숫자 1을 삽입
        mysqli_query($link, "INSERT INTO `users` (`name`, `password`, `email`, `role`) VALUES ('$name', '" . md5($password) . "', '$email', 1)");
    } elseif ($act == "edit") {
        mysqli_query($link, "UPDATE `users` SET `name` = '$name', `email` = '$email' WHERE `id` = '$id'");
    } elseif ($act == "delete") {
        mysqli_query($link, "DELETE FROM `users` WHERE id = '$id'");
    }

    header("Location: /users/users.php");
}
