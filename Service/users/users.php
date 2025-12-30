<?php
include __DIR__ . "/../includes/header.php";
?>

<a class="btn btn-primary" href="edit-users.php?act=add"> <i class="glyphicon glyphicon-plus-sign"></i> Add New Users</a>

<h1>Users</h1>
<p>This table includes <?php echo counting("users", "id"); ?> users.</p>

<table id="sorted" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Id</th>
			<th>User name</th>
			<th>Password</th>
			<th>Name</th>

			<th class="not">Edit</th>
			<th class="not">Delete</th>
		</tr>
	</thead>

	<?php
	$users = getAll("users");
	if ($users) foreach ($users as $users):
	?>
		<tr>
			<td><?php echo $users['id'] ?></td>
			<td><?php echo $users['name'] ?></td>
			<td><?php echo $users['email'] ?></td>
			<td><?php echo $users['password'] ?></td>
			<td><a href="edit-users.php?act=edit&id=<?php echo $users['id'] ?>"><i class="glyphicon glyphicon-edit"></i></a></td>
			<td><a href="save.php?act=delete&id=<?php echo $users['id'] ?>&cat=users" onclick="return navConfirm(this.href);"><i class="glyphicon glyphicon-trash"></i></a></td>
		</tr>
	<?php endforeach; ?>
</table>
<?php include __DIR__ . "/../includes/footer.php"; ?>