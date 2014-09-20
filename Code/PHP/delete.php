<?php
$hostname = "groceryBrain.db.7160932.hostedresource.com";
$username = "groceryBrain";
$dbname = "groceryBrain";

$password = "Brainstation1!";
$usertable = "grocerylist";
$yourfield = "name";

mysql_connect($hostname, $username, $password) OR DIE ("Unable to connect to database! Please try again later.");
mysql_select_db($dbname);

$name = urldecode($_GET["name"]);


$statement = "DELETE FROM ".$usertable." WHERE name='".$name."'";
mysql_query($statement);
mysql_close();
?>