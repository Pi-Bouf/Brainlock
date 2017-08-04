-- ######   #
-- #     #  #
-- #     #  #
-- ######   #
-- #     #  #
-- #     #  #
-- ######   #######
-- Sauvegarde Automatique
-- Effectuée le 25-04-2016 23:46:48

-- Suppression & Insertion de la table brain_article
DROP TABLE IF EXISTS brain_article;
CREATE TABLE brain_article (
artID smallint(6) PRIMARY KEY auto_increment,
artTitleShort varchar(60),
artTitleLong varchar(150),
artText mediumtext,
artDate date,
artBin tinyint(4) NOT NULL,
artAuteur smallint(6) NOT NULL,
menuID tinyint(4)
)engine=innodb default charset=utf8;
-- Insertion dans la table brain_article
INSERT INTO brain_article VALUES('1','Accueil','Bienvenue sur BrainLock !','Bienvenue sur cette boîte à outils, destiner à répertorier un tas de fonctions et codes utiles pour la programmation.<br />
<br />
Envie d\'un code qui marche ? Dirigez-vous vers un menu et fouillez... ;)<br />
<br />
Les codes sont testé avant leur publication, avec des explications et commentaires !<br />
<br />
<i>Bonne navigation !</i>','2016-04-25','0','1','1');



-- Suppression & Insertion de la table brain_menu
DROP TABLE IF EXISTS brain_menu;
CREATE TABLE brain_menu (
menuID tinyint(4) PRIMARY KEY auto_increment,
menuName varchar(50)
)engine=innodb default charset=utf8;
-- Insertion dans la table brain_menu
INSERT INTO brain_menu VALUES('1','Accueil');
INSERT INTO brain_menu VALUES('2','Android (JAVA)');



-- Suppression & Insertion de la table brain_user
DROP TABLE IF EXISTS brain_user;
CREATE TABLE brain_user (
userID smallint(6) PRIMARY KEY auto_increment,
userPrenom varchar(20),
userLogin varchar(20),
userPassword varchar(32),
userLevel varchar(1)
)engine=innodb default charset=utf8;
-- Insertion dans la table brain_user
INSERT INTO brain_user VALUES('1','Pierre','pbouffier','4352072b0da2133c0192c9bdabf42037','5');



