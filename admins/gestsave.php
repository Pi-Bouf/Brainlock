<?php
include('../include/config.php');

// On détermine la date et l'heure
$date = date("d-m-Y H:i:s");
$date_secondaire = date("Y_m_d H-i-s");
// Création du fichier de backup
$filename = $date_secondaire."_backup_4RCh.sql";
$backupFile = fopen("./backups/".$filename, "w");
// Ecriture des commentaires
fwrite($backupFile, "-- ######   #\n");
fwrite($backupFile, "-- #     #  #\n");
fwrite($backupFile, "-- #     #  #\n");
fwrite($backupFile, "-- ######   #\n");
fwrite($backupFile, "-- #     #  #\n");
fwrite($backupFile, "-- #     #  #\n");
fwrite($backupFile, "-- ######   #######\n");
fwrite($backupFile, "-- Sauvegarde Automatique\n");
fwrite($backupFile, "-- Effectuée le ".$date."\n\n");
// Récupération de la liste des tables
$tableList = mysqli_query($db, "SHOW TABLES");
// Boucle: pour chaque tables
while($tableData = mysqli_fetch_array($tableList))
{
    if($tableData[0] != "system_backup") {
        // Ecriture
        fwrite($backupFile, "-- Suppression & Insertion de la table ".$tableData[0]."\n");
        fwrite($backupFile, "DROP TABLE IF EXISTS ".$tableData[0].";\nCREATE TABLE ".$tableData[0]." (\n");
        // Pour chaque table, on récupére chaque colonne
        $listField = mysqli_query($db, "SHOW FIELDS FROM ".$tableData[0]);
        // On récupére le nombre de colonne
        $nbrFields = mysqli_num_rows($listField);
        $cpt = 1;
        // Boucle: pour chaque colonnes
        while($listData = mysqli_fetch_array($listField))
        {
            $line = $listData[0]." ".$listData[1];
            if($listData[2] == "YES") {
                $line .= " NOT NULL";
            }
            if($listData[3] == "PRI") {
                $line .= " PRIMARY KEY";
            }
            if($listData[4] != "") {
                $line .= " DEFAULT '".$listData[4]."'";
            }
            if($listData[5] != "") {
                $line .= " ".$listData[5];
            }
            if($cpt != $nbrFields) {
                $line .= ",";
            }
            $cpt++;
            fwrite($backupFile, $line."\n");
        }
        fwrite($backupFile, ")engine=innodb default charset=utf8;\n");
        fwrite($backupFile, "-- Insertion dans la table ".$tableData[0]."\n");
        // Requête pour obtenir les informations ligne par ligne des dnnées
        $sqlData = "SELECT * FROM ".$tableData[0];
        $returnData = mysqli_query($db, $sqlData);
        // Pour chaque résultat
        while($getData = mysqli_fetch_array($returnData))
        {
            
            $text = "INSERT INTO ".$tableData[0]." VALUES(";
            // Pour chaque colonne de la ligne
            for($cpt = 0; $cpt < $nbrFields; $cpt++)
            {
                // On récupére les données pour leurs ajouter un ADDSLASHES pour ne pas avoir de coupure de chaines.
                $text .= "'".addslashes($getData[$cpt])."',";
            }
            // On récupére le string final et on lui retire le dernier caractère qui représente la virgule et on forme la requête.
            $text = substr($text, 0, strlen($text)-1).");\n";
            // On écrit tout ça
            fwrite($backupFile, $text);
        }
        // On écrit quelque retour chariot
        fwrite($backupFile, "\n\n\n");
    }
}
// On ferme le fichier.
fclose($backupFile);

?>