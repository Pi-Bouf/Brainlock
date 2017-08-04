-- ######   #
-- #     #  #
-- #     #  #
-- ######   #
-- #     #  #
-- #     #  #
-- ######   #######
-- Sauvegarde Automatique
-- Effectuée le 23-07-2016 04:09:21

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
INSERT INTO brain_article VALUES('2','Socket Asynchrone','Les Sockets Asynchrones pour un plus beau serveur !','<p><strong><em>Qu\\\'est-ce que des sockets synchrone ?</em></strong></p><br />
<p>Pour expliquer correctement, je vais commencer par un contre exemple: les sockets synchrone (bloquante). <br />Ces derni&egrave;res, en th&eacute;orie, sont bloquante: un client se connecte, le serveur fait une action en fonction de ce qu\\\'il re&ccedil;oit et reprend du d&eacute;but, comme une boucle. <br />Il n\\\'y a aucun &eacute;v&eacute;nement lors de la r&eacute;ception d\\\'un message: le serveur attend gentiment qu\\\'un message arrive, fais une action et se remet &agrave; &eacute;couter, sans faire autre chose.</p><br />
<pre class=\\\"line-numbers language-cpp\\\"><code>while(true)<br />
{<br />
    Serveur read(); // Il attend qu\\\'un message arrive et ne fait rien d\\\'autre<br />
    Serveur enTrainDeLire; // Il lit un message qui arrive<br />
    if(message == \\\"...\\\")<br />
    {<br />
        jeFaisUneAction(); // On fait une action<br />
    }<br />
    // On se remet &agrave; attendre...<br />
}</code></pre><br />
<p><em>O&ugrave; est le probl&egrave;me dans ce cas l&agrave; ?</em> <br />1) Et s\\\'il y avait autre chose &agrave; faire ? <br />2) Et si on a plusieurs client ? (Chat, serveur de jeu,...)</p><br />
<p>En gros, en dernier exemple, imaginons un chat: le client envoie un message, le serveur lui r&eacute;pond, puis le client, puis le serveur,... Alors qu\\\'en asynchrone, on envoie plusieurs message, le serveur r&eacute;pond (ou pas), puis on en envoie encore 3, il nous en r&eacute;pond 2,...</p><br />
<p><strong><em>Donc, qu\\\'est-ce que des sockets asynchrone ?</em></strong></p><br />
<p>Il s\\\'agit de l\\\'oppos&eacute; ! Il peut recevoir de multiple messages et connexions et il peut les traiter s&eacute;par&eacute;ment. <br />Dans cas l&agrave;, il s\\\'agit d\\\'un serveur recevant un &eacute;v&eacute;nement d\\\'une nouvelle connexion, qui va nous permettre de cr&eacute;er une instance de classe Client, qui donc sera destin&eacute; uniquement &agrave; cette connexion. <br />Des &eacute;v&eacute;nements seront connect&eacute;, comme par exemple le Client#2 enverra un message au serveur, seulement son instance pourra le traiter, alors que le Client#1 et Client#3 ne le pourront pas. <br />Tout sera cloisonn&eacute; et fait par &eacute;v&eacute;nement: donc socket <strong>asynchrone</strong> !</p><br />
<p><u>Petit sch&eacute;ma:</u></p><br />
<center><img src=\\\"down/data_img/socketcpp/Graph.png\\\" /></center><br />
<p><strong>Ici, le main.cpp</strong></p><br />
<pre class=\\\"line-numbers language-cpp\\\"><code>#include <br />
#include <br />
<br />
using namespace std;<br />
<br />
int main(int argc, char *argv[])<br />
{<br />
    QCoreApplication a(argc, argv);<br />
<br />
	// Instanciation du serveur<br />
    Serveur server;<br />
	// Appel de la proc&eacute;dure pour lancer le serveur sur le port 9999<br />
    server.startServer(9999);<br />
<br />
    return a.exec();<br />
}<br />
</code></pre><br />
<p><strong>Ici, le serveur.cpp</strong></p><br />
<pre class=\\\"line-numbers language-cpp\\\"><code>#include \\\"serveur.h\\\"<br />
#include \\\"client.h\\\"<br />
<br />
Serveur::Serveur(QObject *parent) : QTcpServer(parent)<br />
{<br />
    // Constructeur vide, parce que dans ce cas, c\\\'est pas important !<br />
}<br />
<br />
// Proc&eacute;dure de lancement du serveur<br />
void Serveur::startServer(int port)<br />
{<br />
    // Ici, condition: si le serveur est lanc&eacute; ou pas<br />
    if(listen(QHostAddress(\\\"127.0.0.1\\\"), port))<br />
    {<br />
        // Le serveur est enfin d&eacute;marr&eacute;<br />
    }<br />
    else<br />
    {<br />
        // Le serveur n\\\'a pas pu... port d&eacute;j&agrave; pris ?<br />
    }<br />
}<br />
<br />
// Ev&eacute;nement appel&eacute; lors d\\\'une connexion<br />
void Serveur::incomingConnection(int handle)<br />
{<br />
	// On cr&eacute;e un nouveau client<br />
    Client* nouveauClient = new Client(this);<br />
	// On lui attribue la valeur de la connexion socket<br />
    nouveauClient-&gt;setSocket(handle);<br />
}<br />
</code></pre><br />
<p><strong>Et pour finir, le client.cpp</strong></p><br />
<pre class=\\\"line-numbers language-cpp\\\"><code>#include \\\"client.h\\\"<br />
#include <br />
#include <br />
<br />
using namespace std;<br />
<br />
Client::Client(QObject *parent) :<br />
    QObject(parent)<br />
{<br />
	// Toujours un constructeur vide<br />
}<br />
<br />
// Proc&eacute;dure attribuant la valeur du socket<br />
void Client::setSocket(int socketDescriptor)<br />
{<br />
	// On cr&eacute;e un nouveau socket<br />
    socket = new QTcpSocket(this);<br />
<br />
	// On connecte les &eacute;v&eacute;nements &agrave; des proc&eacute;dures pr&eacute;sentes dans cette classe<br />
    connect(socket, SIGNAL(disconnected()), this, SLOT(disconnected()));<br />
    connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));<br />
<br />
	// On attribue la valeur du socket au socket cr&eacute;&eacute;<br />
    socket-&gt;setSocketDescriptor(socketDescriptor);<br />
}<br />
<br />
// Proc&eacute;dure d\\\'appel lors de la d&eacute;connexion du client<br />
void Client::disconnected()<br />
{<br />
    qDebug()&lt;&lt;\\\"D&eacute;connexion !\\\";<br />
}<br />
<br />
// Proc&eacute;dure d\\\'appel lors d\\\'un message arrivant<br />
void Client::readyRead()<br />
{<br />
	// On affiche le message re&ccedil;us<br />
    QString text = socket-&gt;readAll();<br />
    qDebug()&lt;&lt;\\\"Message: \\\" + text;<br />
}<br />
</code></pre><br />
<p><em><strong>Code source: </strong></em> <a href=\\\"../down/data_img/socketcpp/Socket.zip\\\">cliquez ici</a> !</p>','2016-04-26','0','1','3');
INSERT INTO brain_article VALUES('3','[Console] Couleur de texte','Mettre de la couleur dans vos consoles !','<p><em><strong>Voici une librairie permettant d\\\'afficher un texte color&eacute; dans la console !</strong></em></p><br />
<p>La biblioth&egrave;que nous permet d\\\'utiliser le <u>cout</u>, mais celui-ci ne s\\\'affiche qu\\\'en blanc sur noir, ou selon le style de la console. Et c\\\'est moche. En ajoutant certain code dans le <em>cout</em>, on permet de le mettre en couleur, en gras ou bien italique (voir les 3 !)</p><br />
<p><strong><em>Exemple:</em></strong></p><br />
<pre class=\\\"line-numbers language-cpp\\\"><code>void Console::BlueText(string text, int option)<br />
{<br />
    // \\\"\\\\x1B[34m\\\" ==&gt; ici, c\\\'est la couleur bleu<br />
    // \\\"\\\\x1B[0m\\\" ==&gt; ici, c\\\'est la remise &agrave; l\\\'&eacute;tat initial (afin de pas garder ce style jusqu\\\'&agrave; la fin du programme...<br />
    cout&lt;&lt;\\\"\\\\x1B[34m\\\"&lt;&lt;text&lt;&lt;\\\"\\\\x1B[0m\\\"&lt;&lt;endl;<br />
}</code></pre><br />
<p>Gr&acirc;ce &agrave; d\\\'autres codes, on peut donc changer le style de code et gr&acirc;ce &agrave; ces deux fichiers tout fait, on peut le faire encore plus facilement: console.cpp:</p><br />
<pre class=\\\"language-cpp line-numbers\\\"><code>#include \\\"console.h\\\"<br />
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
<p>console.h</p><br />
<pre class=\\\"line-numbers language-cpp\\\"><code>#ifndef CONSOLE_H<br />
#define CONSOLE_H<br />
<br />
#include <br />
#include <br />
#include <br />
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
<p>Amusez-vous bien ! :D</p>','2016-04-27','0','1','3');
INSERT INTO brain_article VALUES('4','Mode Immersif','Profiter de TOUT son écran grâce au mode immersif !','<p><span style=\\\"font-family: impact, sans-serif;\\\">Le mode immersif permet de retirer la barre noir du haut, mais &eacute;galement la barre de navigation du bas.</span></p><br />
<p><span style=\\\"font-family: impact, sans-serif;\\\">Mais dans ce code, on peut &eacute;galement remettre le mode immersif APRES ouverture du clavier.</span></p><br />
<p style=\\\"text-align: center;\\\"><span style=\\\"font-family: impact, sans-serif;\\\"><img src=\\\"../down/data_img/modeimmersif/Screen.png\\\" alt=\\\"Screen\\\" width=\\\"315\\\" height=\\\"560\\\" /></span></p><br />
<pre class=\\\"line-numbers language-java\\\"><code>public class MainActivity extends Activity {<br />
<br />
<br />
    @Override<br />
    protected void onCreate(Bundle savedInstanceState) {<br />
        super.onCreate(savedInstanceState);<br />
        // Mise en place du contenu<br />
        setContentView(R.layout.layout_login);<br />
        // R&eacute;cup&eacute;ration des donn&eacute;es de la vue<br />
        final View decorView = getWindow().getDecorView();<br />
        // Cr&eacute;ation de l\\\'&eacute;v&eacute;nement, appelant le mode immersif<br />
        // Il permet aussi de retourner en immersif apr&egrave;s ouverture clavier<br />
        decorView.setOnSystemUiVisibilityChangeListener(<br />
                new View.OnSystemUiVisibilityChangeListener() {<br />
                    @Override<br />
                    public void onSystemUiVisibilityChange(int i) {<br />
                        setImmersiveMode();<br />
                    }<br />
                });<br />
    }<br />
<br />
<br />
    // Proc&eacute;dure mettant en place le mode immersif<br />
    private void setImmersiveMode()<br />
    {<br />
        // Ajout du mode immersif<br />
        getWindow().getDecorView().setSystemUiVisibility(<br />
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE<br />
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION<br />
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN<br />
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION<br />
                        | View.SYSTEM_UI_FLAG_FULLSCREEN<br />
                        | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);<br />
    }<br />
<br />
<br />
    @Override<br />
    public void onWindowFocusChanged(boolean hasFocus) {<br />
        super.onWindowFocusChanged(hasFocus);<br />
        // Lorsque l\\\'on retrouve le focus, on retourne en mode immersif<br />
        setImmersiveMode();<br />
    }<br />
<br />
    @Override<br />
    protected void onResume() {<br />
        super.onResume();<br />
        // Lorsque l\\\'on retrouve le focus, on retourne en mode immersif<br />
        setImmersiveMode();<br />
    }<br />
<br />
}</code></pre>','2016-05-03','0','1','2');
INSERT INTO brain_article VALUES('5','Procédure','Les procédures stockés','<p>qsd</p>','2016-06-12','0','1','4');



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
INSERT INTO brain_menu VALUES('4','SQL');



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



