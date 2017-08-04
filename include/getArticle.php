<script> Prism.highlightAll(); </script>

<?php
	include('config.php');
	if(isset($_GET['artID']))
	{
		$artID = mysqli_real_escape_string($db, $_GET['artID']);
		$sql = 'SELECT * FROM brain_article WHERE artID = '.$artID;
		$result = mysqli_query($db, $sql);
		$data = mysqli_fetch_row($result);
		
		echo '<div class="title">'.stripslashes($data[2]).'</div>';
		echo stripslashes($data[3]);
		echo '<br><div style="float: right; font-style: italic; font-size: 12px;">Le '.$data[4].'.</div>';
	}
?>