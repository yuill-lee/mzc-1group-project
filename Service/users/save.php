<?php
// [경로 수정] DB 연결
include('../includes/connect.php');

$cat     = $_POST['cat'] ?? $_GET['cat'] ?? '';
$act     = $_POST['act'] ?? $_GET['act'] ?? '';
$id      = $_POST['id'] ?? $_GET['id'] ?? '';
$id_get  = $_GET['id'] ?? '';

// Users 로직
if ($cat == "users" || $cat == "") {

    $password = $_POST["password"] ?? '';
    $name     = $_POST["name"] ?? '';
    $email    = $_POST["email"] ?? '';

    if ($act == "add") {
        // role 1 기본값
        $sql = "INSERT INTO `users` (`name`, `password`, `email`, `role`) VALUES ('$name', '" . md5($password) . "', '$email', 1)";
        mysqli_query($link, $sql);
    } elseif ($act == "edit") {
        $sql = "UPDATE `users` SET `name` = '$name', `email` = '$email' WHERE `id` = '$id'";
        mysqli_query($link, $sql);

        if (!empty($password)) {
            mysqli_query($link, "UPDATE `users` SET `password` = '" . md5($password) . "' WHERE `id` = '$id'");
        }
    } elseif ($act == "delete") {
        mysqli_query($link, "DELETE FROM `users` WHERE id = '$id_get'");
    }

    // [리다이렉트 수정] users.php로 이동
    header("location: users.php");
}
