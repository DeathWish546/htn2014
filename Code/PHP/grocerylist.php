<?php

$hostname = "groceryBrain.db.7160932.hostedresource.com";
$username = "groceryBrain";
$dbname = "groceryBrain";

$password = "Brainstation1!";
$usertable = "grocerylist";
$yourfield = "name";

mysql_connect($hostname, $username, $password) OR DIE ("Unable to connect to database! Please try again later.");
mysql_select_db($dbname);

$query = "SELECT * FROM grocerylist";
$result = mysql_query($query);

$first_time = "yes";

if ($result) {
echo "{";
echo "\"groceries\":[";
    while($row = mysql_fetch_array($result)) {
       if ($first_time=="yes")
       {
       	 $first_time = "no";
       } else {
       	 echo ",";       
       }

        $name = $row["$yourfield"];
        echo "\"$name\"";
    }
echo "]}";
}

?>