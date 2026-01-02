<?php
error_reporting(0);
session_start();
include "includes/connect.php";

// [핵심] 이미 로그인된 사람인지 DB 토큰 체크
if (isset($_COOKIE['auth_token'])) {
    $token = $_COOKIE['auth_token'];
    $check = mysqli_query($link, "SELECT * FROM user_sessions WHERE session_token = '$token'");
    if (mysqli_num_rows($check) > 0) {
        header("location: home.php");
        exit;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Panel</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.7/cosmo/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container" style="margin-top:30px">
        <div class="row">
            <div class="col-sm-6 col-md-4 col-md-offset-4">
                <h1 class="text-center">Mage Admin Panel</h1>
                <h2 class="text-center">Sign in</h2>
                <div>
                    <form action="login.php" method="post" name="login">
                        <input type="text" class="form-control" placeholder="Email" name="email" required autofocus><br>
                        <input type="password" class="form-control" placeholder="Password" name="password" required><br>
                        <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>