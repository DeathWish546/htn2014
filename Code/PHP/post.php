<?php
$hostname = "groceryBrain.db.7160932.hostedresource.com";
$username = "groceryBrain";
$dbname = "groceryBrain";

$password = "Brainstation1!";
$usertable = "grocerylist";
$yourfield = "name";

mysql_connect($hostname, $username, $password) OR DIE ("Unable to connect to database! Please try again later.");
mysql_select_db($dbname);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $postdata = test_input(file_get_contents("php://input"));
}

// file_get_contents("php://input")

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}

$statement = "INSERT INTO ".$usertable." (name) VALUES ('".$postdata."')";
mysql_query($statement);
mysql_close();
?>