<?php
	include('config.php');
	
	if(isset($_GET['menuID']))
	{
		
		$returnArray = array();
		$menuID = mysqli_real_escape_string($db, $_GET['menuID']);
		$sql = 'SELECT artID, artTitleShort FROM brain_article WHERE menuID = "'.$menuID.'"';
		$result = mysqli_query($db, $sql);
		$i = 0;
		while($data = mysqli_fetch_assoc($result))
		{
			$returnArray[] = $data;
			$returnArray[$i]['artTitleShort'] = stripslashes($data['artTitleShort']);
			
			$i++;
		}
		
		echo json_encode($returnArray);
	}
	
?>