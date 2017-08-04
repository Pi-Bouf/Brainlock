<?php
// Global
$site = "BrainLock";
$slogan = "Come with me... :D";

// Sécurity
$salt = "0x874x0";
$key = "zorro05?!";

// MySQL
$host = "localhost";
$user = "brainlock";
$pass = "roroBrainlock.RCZ";
$base = "brainlock";
// MySQL connect
$db = mysqli_connect($host, $user, $pass, $base);
mysqli_set_charset($db, "UTF8");

?>