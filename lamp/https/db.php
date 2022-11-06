<?php
$user = "lamp_admin";
$password = "lamp_admin";
$database = "lamp_db";
$table = "lamp_tb";

try {
  $db = new PDO("mysql:host=127.0.0.1;dbname=$database", $user, $password);
  echo "<h2>Connection to mysql successful</h2>";
  echo "<h2>USERS</h2><ol>";
  echo "<p><strong>Name Email</strong><p>";
  foreach($db->query("SELECT * FROM $table") as $row) {
    echo "<p>" . $row['item_id'] . " " . $row['name'] . " " . $row['mail'] ."</p>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
?>
