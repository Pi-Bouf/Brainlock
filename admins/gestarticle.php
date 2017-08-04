<?php
include('../include/config.php');
include('template/header.php');

if(isset($_GET['act']) && ($_GET['act'] == "supprok"))
{
    if(isset($_GET['id']) && is_numeric($_GET['id']))
    {
        $sql = "UPDATE brain_article SET artBin = 1 WHERE artID = ".$_GET['id'];
        mysqli_query($db, $sql);
        header('Location: gestarticle.php');
    } else {
        header('Location: gestarticle.php');
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "suppr"))
{
    if(isset($_GET['id']) && is_numeric($_GET['id']))
    {
        $sql = "SELECT * FROM brain_article WHERE artID = ".$_GET['id'];
        $result = mysqli_query($db, $sql);
        if(mysqli_num_rows($result) == 1)
        {
            $data = mysqli_fetch_row($result);
            echo '<div class="bloc_simple">';
            echo 'Êtes-vous sûr de vouloir supprimer l\'article <i>'.stripslashes($data[1]).'</i> ?<br>Il sera placé dans la corbeille !';
            echo '<br><br><br><a href="gestarticle.php?act=supprok&id='.stripslashes($data[0]).'">Confirmer !</a>';
            echo '</div>';
        } else {
            header('Location: gestarticle.php');
        }
    } else {
        header('Location: gestarticle.php');
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "editok"))
{
    if(isset($_POST['art_titleshort']) && !empty($_POST['art_titleshort']) && isset($_POST['art_titlelong']) && !empty($_POST['art_titlelong']) && isset($_POST['art_text']) && !empty($_POST['art_text']) && isset($_POST['art_menu']) && !empty($_POST['art_menu']))
    {
        if(isset($_GET['id']) && is_numeric($_GET['id']))
        {
            $sql = "UPDATE brain_article SET artTitleLong = '".addslashes($_POST['art_titlelong'])."', artTitleShort = '".addslashes($_POST['art_titleshort'])."', artText = '".addslashes(nl2br($_POST['art_text']))."', menuID = '".$_POST['art_menu']."' WHERE artID = '".$_GET['id']."'";
            if(mysqli_query($db, $sql))
            {
                header('Location: gestarticle.php');
            } else {
                header('Location: gestarticle.php');
            }
        } else {
            header('Location: gestarticle.php');
        }
    } else {
        header('Location: gestarticle.php');
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "edit"))
{
    if(isset($_GET['id']) && is_numeric($_GET['id']))
    {
        $sql = "SELECT * FROM brain_article WHERE artID = ".$_GET['id'];
        $result = mysqli_query($db, $sql);
        if(mysqli_num_rows($result) == 1)
        {
            $data = mysqli_fetch_row($result);
            echo '<div class="bloc_simple">';
            echo '<form method="POST" action="gestarticle.php?act=editok&id='.$_GET['id'].'">';
            echo '<input type="text" name="art_titleshort" placeholder="Titre court ici..." value="'.stripslashes($data[1]).'"><br>';
            echo '<input type="text" name="art_titlelong" placeholder="Titre long ici..." value="'.stripslashes($data[2]).'"><br>';
            echo '<br><textarea id="content_article" name="art_text" placeholder="Le contenu ici...">'.str_replace("<br />", "", stripslashes($data[3])).'</textarea><br>';
            echo '<select name="art_menu">';
            $sql_menu = "SELECT * FROM brain_menu";
            $result_menu = mysqli_query($db, $sql_menu);
            while($data_menu = mysqli_fetch_array($result_menu))
            {
                if($data_menu[0] == $data[7])
                {
                    echo '<option value="'.$data_menu[0].'" selected="selected">'.stripslashes($data_menu[1]).'</option>';
                } else {
                    echo '<option value="'.$data_menu[0].'">'.stripslashes($data_menu[1]).'</option>';
                }
            }
            echo '</select>';
            echo '<input type="submit" value="Enregistrer !">';
            echo '</form>';
            echo '</div>';
        }
        
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "addok"))
{
    if(isset($_POST['art_titleshort']) && !empty($_POST['art_titleshort']) && isset($_POST['art_titlelong'])
       && !empty($_POST['art_titlelong']) && isset($_POST['art_text']) && !empty($_POST['art_text'])
       && isset($_POST['art_menu']) && !empty($_POST['art_menu']))
    {
        $sql = "INSERT INTO brain_article(artTitleShort, artTitleLong, artText, artDate, artBin, artAuteur, menuID) VALUES('".addslashes($_POST['art_titleshort'])."', '".addslashes($_POST['art_titlelong'])."', '".addslashes(nl2br($_POST['art_text']))."', now(), 0, 1, '".$_POST['art_menu']."');";
        if(mysqli_query($db, $sql))
        {
            unset($_SESSION['art_titleshort']);
            unset($_SESSION['art_titlelong']);
            unset($_SESSION['art_text']);
            unset($_SESSION['art_menu']);
            header('Location: gestarticle.php');
        }
    } else {
        if(isset($_POST['art_titleshort']))
        {
            $_SESSION['art_titleshort'] = $_POST['art_titleshort'];
        }
        if(isset($_POST['art_titlelong']))
        {
            $_SESSION['art_titlelong'] = $_POST['art_titlelong'];
        }
        if(isset($_POST['art_text']))
        {
            $_SESSION['art_text'] = $_POST['art_text'];
        }
        if(isset($_POST['art_menu']))
        {
            $_SESSION['art_menu'] = $_POST['art_menu'];
        }
        header('Location: gestarticle.php?act=add');
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "add"))
{
    echo '<div class="bloc_simple">';
    echo '<form method="POST" action="gestarticle.php?act=addok">';
    echo '<input type="text" name="art_titleshort" placeholder="Titre court ici..." value="'.(isset($_SESSION['art_titleshort']) ? $_SESSION['art_titleshort'] : '').'"><br>';
    echo '<input type="text" name="art_titlelong" placeholder="Titre long ici..." value="'.(isset($_SESSION['art_titlelong']) ? $_SESSION['art_titlelong'] : '').'"><br>';
    echo '<br><textarea id="content_article" name="art_text" placeholder="Le contenu ici...">'.(isset($_SESSION['art_text']) ? $_SESSION['art_text'] : '').'</textarea><br>';
    echo '<select name="art_menu">';
    $sql = "SELECT * FROM brain_menu";
    $result = mysqli_query($db, $sql);
    while($data = mysqli_fetch_array($result))
    {
        echo '<option value="'.$data[0].'"'.((isset($_SESSION['art_menu']) && ($data[0] == $_SESSION['art_menu'])) ? 'selected="selected"' : '').'>'.$data[1].'</option>';
    }
    echo '</select>';
    echo '<input type="submit" value="Enregistrer !">';
    echo '</form>';
    echo '</div>';
}
else
{
    echo '<div class="bloc_simple"><a href="gestarticle.php?act=add">Ajouter un nouvel article</a></div><br>';
    $sql = "SELECT * FROM brain_article ORDER BY artBin, menuID";
    $result = mysqli_query($db, $sql);
    while($data = mysqli_fetch_array($result))
    {
        echo '<div class="bloc_simple article">';
        if($data[5] == 1)
        {
            echo '<div class="bin">Corbeille</div>';
        } else {
            $sqlmenu = "SELECT menuName FROM brain_menu WHERE menuID =".$data[7];
            $datamenu = mysqli_fetch_row(mysqli_query($db, $sqlmenu));
            echo '<div class="menu">'.$datamenu[0].'</div>';
        }
        echo $data[1];
        echo '<a href="gestarticle.php?act=suppr&id='.$data[0].'"><img style="float: right; margin-left: 5px;" src="images/delete.png"></a>';
        echo '<a href="gestarticle.php?act=edit&id='.$data[0].'"><img style="float: right" src="images/edit.png"></a>';
        echo '</div>';
    }
}

include('template/footer.php');
?>