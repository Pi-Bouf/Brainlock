<?php include('include/config.php'); ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<html>
    <head>
		<meta charset="UTF-8">
        <title><?php echo $site ?></title>
		<link rel="stylesheet" href="styles/prism.css">
        <link rel="stylesheet" href="styles/style.css">
		<script src="scripts/prism.js"></script>
        <script src="scripts/jquery-2.2.1.min.js"></script>
        <script src="scripts/global.js"></script>
		<script>
			(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
			
			ga('create', 'UA-77657027-1', 'auto');
			ga('send', 'pageview');
		</script>
        
    </head>
    
    <body>
        
        <div id="bannerMenu">
            <div id="menuBlock">
                <?php
                    $sql = 'SELECT * FROM brain_menu';
                    $result = mysqli_query($db, $sql);
                    while($data = mysqli_fetch_array($result))
                    {
                        echo '<a href="#" class="menuItem" menuID="'.$data[0].'">'.$data[1].'</a>';
                    }
                ?>
            </div>
            
            <div style="clear: both"></div>
        </div>
        
        <div id="logo"><?php echo $site ?></div>
        <div id="content">
            
            <div id="columnLeft">
                <div id="catList">
                </div>

            </div>
            <div id="columnRight">
                <?php
				$sql = 'SELECT * FROM brain_article WHERE artID = 1';
				$result = mysqli_query($db, $sql);
				$data = mysqli_fetch_row($result);
				
				echo '<div class="title">'.$data[2].'</div>';
				echo stripcslashes($data[3]);
				echo '<br><div style="float: right; font-style: italic; font-size: 12px;">Le '.$data[4].'.</div>';
				?>
            </div>
            
            <div style="clear: both"></div>
        </div>
    </body>
</html>
