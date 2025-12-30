<?php
	include __DIR__ . "/../includes/header.php";
	$data = [];

	// $_GET 값이 없을 경우를 대비해 기본값('') 설정
	$act = $_GET['act'] ?? '';
	$users = ['name' => '', 'password' => '', 'email' => '']; // 기본값 초기화

	if ($act == "edit") {
		$id = $_GET['id'] ?? '';
		if ($id) {
			$users = getById("users", $id);
		}
	}
?>
<form method="post" action="save.php" enctype='multipart/form-data'>
	<fieldset>
		<legend class="hidden-first">Add New Users</legend>
		<input name="cat" type="hidden" value="users">
		<input name="id" type="hidden" value="<?= $id ?>">
		<input name="act" type="hidden" value="<?= $act ?>">
		<label>Name</label>
		<input class="form-control" type="text" name="name" value="<?= $users['name'] ?>" /><br>

		<label>Password</label>
		<input class="form-control" type="text" name="password" value="<?= $users['password'] ?>" /><br>

		<label>Email</label>
		<input class="form-control" type="text" name="email" value="<?= $users['email'] ?>" /><br>
		<br>
		<input type="submit" value=" Save " class="btn btn-success">
</form>
<?php include __DIR__ . "/../includes/footer.php"; ?>