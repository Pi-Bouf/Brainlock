-- ######   #
-- #     #  #
-- #     #  #
-- ######   #
-- #     #  #
-- #     #  #
-- ######   #######
-- Sauvegarde Automatique
-- Effectuée le 27-04-2016 13:48:17

-- Suppression & Insertion de la table brain_article
DROP TABLE IF EXISTS brain_article;
CREATE TABLE brain_article (
artID smallint(6) PRIMARY KEY auto_increment,
artTitleShort varchar(60) NOT NULL,
artTitleLong varchar(150) NOT NULL,
artText mediumtext NOT NULL,
artDate date NOT NULL,
artBin tinyint(4),
artAuteur smallint(6),
menuID tinyint(4) NOT NULL
)engine=innodb default charset=utf8;
-- Insertion dans la table brain_article
INSERT INTO brain_article VALUES('1','Accueil','Bienvenue sur BrainLock !','Bienvenue sur cette boîte à outils, destiner à répertorier un tas de fonctions et codes utiles pour la programmation.<br />
<br />
Envie d\'un code qui marche ? Dirigez-vous vers un menu et fouillez... ;)<br />
<br />
Les codes sont testé avant leur publication, avec des explications et commentaires !<br />
<br />
<i>Bonne navigation !</i>','2016-04-25','0','1','1');
INSERT INTO brain_article VALUES('2','Socket Asynchrone','Les Sockets Asynchrones pour un plus beau serveur !','<b><i>Qu\\\'est-ce que des sockets synchrone ?</i></b><br />
<br />
Pour expliquer correctement, je vais commencer par un contre exemple: les sockets synchrone (bloquante). Ces dernières, en théorie, sont bloquante: un client se connecte, le serveur fait une action en fonction de ce qu\\\'il reçoit et reprend du début, comme une boucle.<br />
Il n\\\'y a aucun événement lors de la réception d\\\'un message: le serveur attend gentiment qu\\\'un message arrive, fais une action et se remet à écouter, sans faire autre chose.<br />
<br />
<br />
<pre><code class=\\\"language-cpp line-numbers\\\">while(true)<br />
{<br />
    Serveur read(); // Il attend qu\\\'un message arrive et ne fait rien d\\\'autre<br />
    Serveur enTrainDeLire; // Il lit un message qui arrive<br />
    if(message == \\\"...\\\")<br />
    {<br />
        jeFaisUneAction(); // On fait une action<br />
    }<br />
    // On se remet à attendre...<br />
}</code></pre><br />
<br />
<i>Où est le problème dans ce cas là ?</i><br />
1) Et s\\\'il y avait autre chose à faire ?<br />
2) Et si on a plusieurs client ? (Chat, serveur de jeu,...)<br />
<br />
En gros, en dernier exemple, imaginons un chat: le client envoie un message, le serveur lui répond, puis le client, puis le serveur,...<br />
Alors qu\\\'en asynchrone, on envoie plusieurs message, le serveur répond (ou pas), puis on en envoie encore 3, il nous en répond 2,...<br />
<br />
<b><i>Donc, qu\\\'est-ce que des sockets asynchrone ?</i></b><br />
<br />
Il s\\\'agit de l\\\'opposé ! Il peut recevoir de multiple messages et connexions et il peut les traiter séparément.<br />
<br />
Dans cas là, il s\\\'agit d\\\'un serveur recevant un événement d\\\'une nouvelle connexion, qui va nous permettre de créer une instance de classe Client, qui donc sera destiné uniquement à cette connexion. Des événements seront connecté, comme par exemple le Client#2 enverra un message au serveur, seulement son instance pourra le traiter, alors que le Client#1 et Client#3 ne le pourront pas. Tout sera cloisonné et fait par événement: donc socket <b>asynchrone</b> !<br />
<br />
<u>Petit schéma:</u><br />
<center><img src=\\\"./down/data_img/socketcpp/Graph.png\\\"></center><br />
<br />
<b>Ici, le main.cpp</b><br />
<pre><code class=\\\"language-cpp line-numbers\\\">#include <QCoreApplication><br />
#include <serveur.h><br />
<br />
using namespace std;<br />
<br />
int main(int argc, char *argv[])<br />
{<br />
    QCoreApplication a(argc, argv);<br />
<br />
	// Instanciation du serveur<br />
    Serveur server;<br />
	// Appel de la procédure pour lancer le serveur sur le port 9999<br />
    server.startServer(9999);<br />
<br />
    return a.exec();<br />
}<br />
</code></pre><br />
<br />
<b>Ici, le serveur.cpp</b><br />
<pre><code class=\\\"language-cpp line-numbers\\\">#include \\\"serveur.h\\\"<br />
#include \\\"client.h\\\"<br />
<br />
Serveur::Serveur(QObject *parent) : QTcpServer(parent)<br />
{<br />
    // Constructeur vide, parce que dans ce cas, c\\\'est pas important !<br />
}<br />
<br />
// Procédure de lancement du serveur<br />
void Serveur::startServer(int port)<br />
{<br />
    // Ici, condition: si le serveur est lancé ou pas<br />
    if(listen(QHostAddress(\\\"127.0.0.1\\\"), port))<br />
    {<br />
        // Le serveur est enfin démarré<br />
    }<br />
    else<br />
    {<br />
        // Le serveur n\\\'a pas pu... port déjà pris ?<br />
    }<br />
}<br />
<br />
// Evénement appelé lors d\\\'une connexion<br />
void Serveur::incomingConnection(int handle)<br />
{<br />
	// On crée un nouveau client<br />
    Client* nouveauClient = new Client(this);<br />
	// On lui attribue la valeur de la connexion socket<br />
    nouveauClient->setSocket(handle);<br />
}<br />
</code></pre><br />
<br />
<b>Et pour finir, le client.cpp</b><br />
<pre><code class=\\\"language-cpp line-numbers\\\">#include \\\"client.h\\\"<br />
#include <iostream><br />
#include <QDebug><br />
<br />
using namespace std;<br />
<br />
Client::Client(QObject *parent) :<br />
    QObject(parent)<br />
{<br />
	// Toujours un constructeur vide<br />
}<br />
<br />
// Procédure attribuant la valeur du socket<br />
void Client::setSocket(int socketDescriptor)<br />
{<br />
	// On crée un nouveau socket<br />
    socket = new QTcpSocket(this);<br />
<br />
	// On connecte les événements à des procédures présentes dans cette classe<br />
    connect(socket, SIGNAL(disconnected()), this, SLOT(disconnected()));<br />
    connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));<br />
<br />
	// On attribue la valeur du socket au socket créé<br />
    socket->setSocketDescriptor(socketDescriptor);<br />
}<br />
<br />
// Procédure d\\\'appel lors de la déconnexion du client<br />
void Client::disconnected()<br />
{<br />
    qDebug()<<\\\"Déconnexion !\\\";<br />
}<br />
<br />
// Procédure d\\\'appel lors d\\\'un message arrivant<br />
void Client::readyRead()<br />
{<br />
	// On affiche le message reçus<br />
    QString text = socket->readAll();<br />
    qDebug()<<\\\"Message: \\\" + text;<br />
}<br />
</code></pre><br />
<br />
<i><b>Code source: </b></i> <a href=\\\"http://brainlock.comxa.com/down/data_img/socketcpp/Socket.zip\\\">cliquez ici</a> !','2016-04-26','0','1','3');
INSERT INTO brain_article VALUES('3','[Console] Couleur de texte','Mettre de la couleur dans vos consoles !','<i><b>Voici une librairie permettant d\\\'afficher un texte coloré dans la console !</b></i><br />
<br />
La bibliothèque <biostream></b> nous permet d\\\'utiliser le <u>cout</u>, mais celui-ci ne s\\\'affiche qu\\\'en blanc sur noir, ou selon le style de la console. Et c\\\'est moche.<br />
<br />
En ajoutant certain code dans le <i>cout</i>, on permet de le mettre en couleur, en gras ou bien italique (voir les 3 !)<br />
<br />
<b><i>Exemple:</i></b><br />
<br />
<br />
<pre><code class=\\\"language-cpp line-numbers\\\">void Console::BlueText(string text, int option)<br />
{<br />
    // \\\"\\\\x1B[34m\\\" ==> ici, c\\\'est la couleur bleu<br />
    // \\\"\\\\x1B[0m\\\" ==> ici, c\\\'est la remise à l\\\'état initial (afin de pas garder ce style jusqu\\\'à la fin du programme...<br />
    cout<<\\\"\\\\x1B[34m\\\"<&lt;text<<\\\"\\\\x1B[0m\\\"<&lt;endl;<br />
}</code></pre><br />
<br />
Grâce à d\\\'autres codes, on peut donc changer le style de code et grâce à ces deux fichiers tout fait, on peut le faire encore plus facilement:<br />
<br />
console.cpp:<br />
<pre><code class=\\\"language-cpp line-numbers\\\">#include \\\"console.h\\\"<br />
<br />
void Console::BlueText(string text, int option)<br />
{<br />
    cout&lt;&lt;\\\"\\\\x1B[34m\\\"&lt;&lt;StyleText(option)&lt;&lt;text&lt;&lt;\\\"\\\\x1B[0m\\\"&lt;&lt;endl;<br />
}<br />
<br />
void Console::RedText(string text, int option)<br />
{<br />
    cout&lt;&lt;\\\"\\\\x1B[31m\\\"&lt;&lt;StyleText(option)&lt;&lt;text&lt;&lt;\\\"\\\\x1B[0m\\\"&lt;&lt;endl;<br />
}<br />
<br />
void Console::GreenText(string text, int option)<br />
{<br />
    cout&lt;&lt;\\\"\\\\x1B[32m\\\"&lt;&lt;StyleText(option)&lt;&lt;text&lt;&lt;\\\"\\\\x1B[0m\\\"&lt;&lt;endl;<br />
}<br />
<br />
void Console::YellowText(string text, int option)<br />
{<br />
    cout&lt;&lt;\\\"\\\\x1B[33m\\\"&lt;&lt;StyleText(option)&lt;&lt;text&lt;&lt;\\\"\\\\x1B[0m\\\"&lt;&lt;endl;<br />
}<br />
<br />
void Console::MagentaText(string text, int option)<br />
{<br />
    cout&lt;&lt;\\\"\\\\x1B[35m\\\"&lt;&lt;StyleText(option)&lt;&lt;text&lt;&lt;\\\"\\\\x1B[0m\\\"&lt;&lt;endl;<br />
}<br />
<br />
void Console::CyanText(string text, int option)<br />
{<br />
    cout&lt;&lt;\\\"\\\\x1B[36m\\\"&lt;&lt;StyleText(option)&lt;&lt;text&lt;&lt;\\\"\\\\x1B[0m\\\"&lt;&lt;endl;<br />
}<br />
<br />
void Console::WhiteText(string text, int option)<br />
{<br />
    cout&lt;&lt;\\\"\\\\x1B[37m\\\"&lt;&lt;StyleText(option)&lt;&lt;text&lt;&lt;\\\"\\\\x1B[0m\\\"&lt;&lt;endl;<br />
}<br />
<br />
<br />
string Console::StyleText(int option)<br />
{<br />
    string textOption;<br />
<br />
    switch(option)<br />
    {<br />
	// Italique<br />
    case 2:<br />
        textOption = \\\"\\\\x1B[1m\\\";<br />
        break;<br />
	// Gras<br />
    case 3:<br />
        textOption = \\\"\\\\x1B[3m\\\";<br />
        break;<br />
    }<br />
<br />
    return textOption;<br />
}<br />
</code></pre><br />
<br />
console.h<br />
<pre><code class=\\\"language-cpp line-numbers\\\">#ifndef CONSOLE_H<br />
#define CONSOLE_H<br />
<br />
#include &lt;string><br />
#include &lt;iostream><br />
#include &lt;QTime><br />
<br />
using namespace std;<br />
<br />
class Console<br />
{<br />
<br />
public:<br />
    static void BlueText(string text, int option);<br />
    static void RedText(string text, int option);<br />
    static void GreenText(string text, int option);<br />
    static void YellowText(string text, int option);<br />
    static void MagentaText(string text, int option);<br />
    static void CyanText(string text, int option);<br />
    static void WhiteText(string text, int option);<br />
    static string StyleText(int option);<br />
};<br />
<br />
#endif // CONSOLE_H<br />
</code></pre><br />
<br />
Amusez-vous bien ! :D','2016-04-27','0','1','3');



-- Suppression & Insertion de la table brain_menu
DROP TABLE IF EXISTS brain_menu;
CREATE TABLE brain_menu (
menuID tinyint(4) PRIMARY KEY auto_increment,
menuName varchar(50) NOT NULL
)engine=innodb default charset=utf8;
-- Insertion dans la table brain_menu
INSERT INTO brain_menu VALUES('1','Accueil');
INSERT INTO brain_menu VALUES('2','JAVA (Android)');
INSERT INTO brain_menu VALUES('3','C++ (Qt)');



-- Suppression & Insertion de la table brain_user
DROP TABLE IF EXISTS brain_user;
CREATE TABLE brain_user (
userID smallint(6) PRIMARY KEY auto_increment,
userPrenom varchar(20) NOT NULL,
userLogin varchar(20) NOT NULL,
userPassword varchar(32) NOT NULL,
userLevel varchar(1) NOT NULL
)engine=innodb default charset=utf8;
-- Insertion dans la table brain_user
INSERT INTO brain_user VALUES('1','Pierre','pbouffier','4352072b0da2133c0192c9bdabf42037','5');



