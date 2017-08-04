// Lorsque la page est chargé
$(document).ready(function() {
   // Appel de la fonction de chargement de la page
   $startPage();
   
   // Lors du click sur un menu
   $('.menuItem').click(function(e) {
      // On retire le chargement par défaut
      e.preventDefault();
      // On appel la procédure de chargement de catégorie avec le menuID passé en paramètre
      $loadCategorie($(this).attr("menuID"));
   });
   
});

// #########################################################################################
//       Procédure de chargement de la page
// #########################################################################################
$startPage = function()
{
   // On rend le logo un peu invisible
   $("#logo").css("opacity", "0.4");
   
   // On met en place le contenu principal
   $("#content").delay(600).animate({"opacity": 1, "marginTop": "-=80"}, 600, function() {
      // Une fois le contenu mis en place, on appel un chargement de catégorie
      $loadCategorie(1);
   });
   
   // Animation de la bannière des menus
   $("#bannerMenu").delay(600).animate({"opacity": 1}, 600);
   
   // A un interval de 6 seconde, on anime le logo
   setInterval(function() {
        $("#logo")
        .animate({"opacity": 1}, 1000)
        .animate({"opacity": 0.4}, 1500)
   }, 6000);
}

$loadCategorie = function(menuID)
{

   $(document).off("mouseover", ".catItem");
   $(document).off("mouseleave", ".catItem");
   $(document).off("click", ".catItem");

   $(".catItem").animate({"marginLeft": "35px", "opacity": 0}, 100, function() {
      $(this).remove();
   });
   
   setTimeout(function() {
   var url = "include/getCategorie.php?menuID=" + menuID;
      $.getJSON(url, function(result) {
         
         for(var cpt = 0; cpt < result.length; cpt++)
         {
            
            if (cpt%2 == 0) {
               $("#catList").append('<div class="catItem right hidden" isOpened="0" artID="' + result[cpt]['artID'] + '">' + result[cpt]['artTitleShort'] + '</div>');
            }
            if (cpt%2 == 1) {
               $("#catList").append('<div class="catItem left hidden" isOpened="0" artID="' + result[cpt]['artID'] + '">' + result[cpt]['artTitleShort'] + '</div>');
            }
            
         }
         
         $(".catItem").animate({"marginLeft": "0px", "opacity": 1}, 500);
      
      });
      
   }, 700);
   
   $(document).on("mouseover", ".catItem", function() {
      if($(this).attr("isOpened") == "0")
      {
         $(this).stop().animate({"marginLeft": "35px", "opacity": 1}, 100);
      }
   });
   $(document).on("mouseleave", ".catItem", function() {
      if($(this).attr("isOpened") == "0")
      {
         $(this).stop().animate({"marginLeft": "0px", "opacity": 1}, 100);
      }
   });
   $(document).on("click", ".catItem", function() {
      if ($(this).attr("isOpened") != "1") {
         $('.catItem[isOpened="1"]').attr("isOpened", "0").stop().animate({"marginLeft": "0px"}, 100);
         $(this).attr("isOpened", "1");
         $loadArticle($(this).attr("artID"));
      }
   });
   
}

$loadArticle = function(artID)
{
   $("#columnRight").fadeOut(300, function() {
      $(this).html('<div class="loading"><center><br><br><img src="images/loading.gif"><br><br></center></div>');
      $(this).fadeIn(300, function() {
         
         $.ajax({
            url: 'include/getArticle.php?artID=' + artID,
            datatype: 'html',
            success: function(result) {
               $("#columnRight").fadeOut(300, function() {
                  $(this).html(result);
                  $(this).fadeIn(300);
               })
            }
         });
      });
   });
}