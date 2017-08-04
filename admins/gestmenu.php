<?php
include('../include/config.php');
include('template/header.php');

// Suppression (Confirmation)
if(isset($_GET['act']) && ($_GET['act'] == "supprok"))
{
    if(isset($_GET['id']) && is_numeric($_GET['id']))
    {
        $sql = "DELETE FROM brain_menu WHERE menuID = ".$_GET['id'];
        if(mysqli_query($db, $sql))
        {
            $sql = "UPDATE brain_article SET artBin = 1 WHERE menuID = ".$_GET['id'];
            mysqli_query($db, $sql);
            header('Location: gestmenu.php');
        }
    } else {
        header('Location: gestmenu.php');
    }
}
// Suppression (Demande de confirmation)
elseif(isset($_GET['act']) && ($_GET['act'] == "suppr"))
{
    if(isset($_GET['id']) && is_numeric($_GET['id']))
    {
        $sql = "SELECT * FROM brain_menu WHERE menuID = ".$_GET['id'];
        $result = mysqli_query($db, $sql);
        if(mysqli_num_rows($result) == 1)
        {
            $data = mysqli_fetch_row($result);
            echo '<div class="bloc_simple">';
            echo 'Êtes-vous sûr de vouloir supprimer le menu <i>'.stripslashes($data[1]).'</i> ?<br>Chaque article contenu dans ce menu sera placé dans la corbeille !';
            echo '<br><br><br><a href="gestmenu.php?act=supprok&id='.$data[0].'">Confirmer !</a>';
            echo '</div>';
        } else {
            header('Location: gestmenu.php');
        }
    } else {
        header('Location: gestmenu.php');
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "editok"))
{
    if(isset($_GET['id']) && is_numeric($_GET['id']))
    {
        if(isset($_POST['menu_name']) && !empty($_POST['menu_name']))
        {
            $sql = 'UPDATE brain_menu SET menuName = "'.addslashes($_POST['menu_name']).'" WHERE menuID = '.$_GET['id'];
            if(mysqli_query($db, $sql))
            {
                header('Location: gestmenu.php');
            } else {
                header('Location: gestmenu.php');
            }
        } else {
            header('Location: gestmenu.php');
        }
    } else {
        header('Location: gestmenu.php');
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "edit"))
{
    if(isset($_GET['id']) && is_numeric($_GET['id']))
    {
        $sql = "SELECT * FROM brain_menu WHERE menuID=".$_GET['id'];
        $result = mysqli_query($db, $sql);
        if(mysqli_num_rows($result) == 1)
        {
            $data = mysqli_fetch_row($result);
            echo '<div class="bloc_simple">';
            echo '<form method="POST" action="gestmenu.php?act=editok&id='.$_GET['id'].'">';
            echo '<input type="text" name="menu_name" value="'.stripslashes($data[1]).'"><br><br>';
            echo '<input type="submit" value="Enregistrer !">';
            echo '</form>';
            echo '</div>';
        } else {
            header('Location: gestmenu.php');
        }
    } else {
        header('Location: gestmenu.php');
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "addok"))
{
    if(isset($_POST['menu_name']) && !empty($_POST['menu_name']))
    {
        $sql = 'INSERT INTO brain_menu(menuName) VALUES ("'.$_POST['menu_name'].'")';
        if(mysqli_query($db, $sql))
        {
            header('Location: gestmenu.php');
        } else {
            header('Location: gestmenu.php');
        }
    } else {
        header('Location: gestmenu.php');
    }
}
elseif(isset($_GET['act']) && ($_GET['act'] == "add"))
{   
    echo '<div class="bloc_simple">';
    echo '<form method="POST" action="gestmenu.php?act=addok">';
    echo '<input type="text" name="menu_name" placeholder="Nom du menu..."><br><br>';
    echo '<input type="submit" value="Enregistrer !">';
    echo '</form>';
    echo '</div>';
} else {
    echo '<div class="bloc_simple"><a href="gestmenu.php?act=add">Ajouter un nouveau menu</a></div>';
    echo '<div id="bloc_list_menu">';
        $sql = "SELECT * FROM brain_menu";
        $result = mysqli_query($db, $sql);
        
        while($data = mysqli_fetch_array($result))
        {
            echo '<div class="bloc_menu">'.stripslashes($data[1]).'<br><br><a href="gestmenu.php?act=suppr&id='.$data[0].'"><img src="images/delete.png"></a><a href="gestmenu.php?act=edit&id='.$data[0].'"><img src="images/edit.png"></a></div>';
        }
    echo '</div>';
}

include('template/footer.php');
?>