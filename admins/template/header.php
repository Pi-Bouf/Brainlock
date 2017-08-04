<?php
session_start();
if(isset($_SESSION['session_timeout']))
{
	if($_SESSION['session_timeout'] + (2*3600) < time())
	{
		session_unset();
		session_destroy();
		header('Location: index.php');
	}
} else {
	session_unset();
	session_destroy();
	header('Location: index.php');
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">
<html>
    <head>
        <title><?php echo $site ?></title>
        <link href="styles/style.css" rel="stylesheet">
        <script src="../scripts/jquery-2.2.1.min.js"></script>
		<script src="scripts/tinymce.min.js"></script>
		<script src="scripts/global.js"></script>
		<meta charset="UTF-8">
    </head>
    
    <body>
        <div id="logo"><?php echo $site ?></div>
        <div id="menu">
            <a href="gestmenu.php">Gestion des menus</a>
            <a href="gestarticle.php">Gestion des articles</a>
        </div>