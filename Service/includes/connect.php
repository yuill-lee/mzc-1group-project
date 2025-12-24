<?php
		$link = mysqli_connect("192.168.65.175", "user02", "user02");
		mysqli_select_db($link, "test_db");
		mysqli_query($link, "SET CHARACTER SET utf8");
		?>
		