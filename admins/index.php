<?php
session_start();
include('../include/config.php');

if(isset($_SESSION['userID']) && !empty($_SESSION['userID']) && isset($_SESSION['userLevel']) && $_SESSION['userLevel'] == '5')
{
    header("Location: home.php");
}

if(isset($_POST['login']) && !empty($_POST['login']) && isset($_POST['password']) && !empty($_POST['password']))
{
    $username = mysqli_real_escape_string($db, $_POST['login']);
    $password = md5(sha1(sha1($salt).md5($key)).$_POST['password'].md5(sha1(md5($salt.$key))));
	
	$sql = "SELECT * FROM brain_user WHERE userLogin = '$username' AND userPassword = '$password'";
	$result = mysqli_query($db, $sql);
	if(mysqli_num_rows($result) == 1)
	{
		$data = mysqli_fetch_array($result);
		$_SESSION['userID'] = $data[0];
		$_SESSION['userPrenom'] = $data[1];
		$_SESSION['userLevel'] = $data[4];
		$_SESSION['session_timeout'] = time();
		header("Location: home.php");
	}
}
?><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">

<html>
    <head>
        <title><?php echo $site ?></title>
        <link href="styles/style.css" rel="stylesheet">
    </head>
    
    <body>
        <div id="logo"><?php echo $site ?></div>
        <div id="loginPanel">
            <form method="POST" action="index.php">
                <input type="text" name="login" placeholder="Login"><br>
                <input type="password" name="password" placeholder="Mot de passe"><br>
                <input type="submit" value="Entrer">
            </form>
        </div>
    </body>
</html>