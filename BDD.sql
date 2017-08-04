DROP TABLE IF EXISTS brain_article;
DROP TABLE IF EXISTS brain_menu;
DROP TABLE IF EXISTS brain_user;


CREATE TABLE brain_menu (
  menuID tinyint auto_increment,
  menuName varchar(50) NOT NULL,
  PRIMARY KEY(menuID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE brain_article (
  artID smallint auto_increment,
  artTitleShort varchar(60) NOT NULL,
  artTitleLong varchar(150) NOT NULL,
  artText mediumtext NOT NULL,
  artDate date NOT NULL,
  artBin tinyint,
  artAuteur smallint,
  menuID tinyint NOT NULL,
  PRIMARY KEY(artID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE brain_user (
  userID smallint auto_increment,
  userPrenom varchar(20) NOT NULL,
  userLogin varchar(20) NOT NULL,
  userPassword varchar(32) NOT NULL,
  userLevel varchar(1) NOT NULL,
  PRIMARY KEY(userID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO brain_menu (menuName) VALUES ("PHP"), ("C#");
INSERT INTO brain_article (artTitleShort, artTitleLong, artText, artDate, artBin, artAuteur, menuID) VALUES ("Mode immersif #OKLM", "Comment mettre un mod immersif ?", "Salut et bienvenue les gars !! :D", "2016-02-24", 0, 1, 1), 
("Petite SEGUE", "Voilà la grosse ségue du jouuuur !!", "COUCOU, c'est moi !!<br><br>okok", "2001-02-03", 0, 1, 2), ("Petit test tranquillement", "La sieste...", "ZOROOOOOOOOOOOOOOO c'est moiii !! <br><br><pre><code class=\"language-css line-numbers\">p { margin-left: 5px; }</code></pre>", "2015-02-03", 0, 1, 2);
INSERT INTO brain_user (userPrenom, userLogin, userPassword, userLevel) VALUES ("Pierre", "pbouffier", "6ab9f8ba9e16e2c79cfcbd947d944f52", "5");