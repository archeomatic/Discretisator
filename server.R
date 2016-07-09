
# This is the server logic for a Shiny web application. look at http://shiny.rstudio.com
# A Shiny webapp by www.archeomatic.wordpress.com - sylvain.badey@inrap.fr

library(shiny)
library(classInt)

shinyServer(function(input, output) {
  
  # Import du tableau csv d'après les paramètres, il sera contenu dans Data()
  Data <- reactive({ 
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header=input$header, sep=input$sep,
             dec = input$dec, quote=input$quote )
  })
  
  # Affichage du tableau importé tel qu'il est interprété
  output$userdata <- renderTable({
    if (is.null(input$file1)) { return() }
    Data()
  })
  
  # Menu déroulant des variables du tableau importé
  output$choice <- renderUI({
    if (is.null(input$file1)) { return() }
    d = Data()
    ## ne montrer que les variables numériques
    nums <- sapply(d, is.numeric)
    items=names(nums[nums])
    ## la variable choisie est contenue dans [var.et]
    selectInput("var.et", "variable à analyser:",items)
  })  
  
  # Histogramme de distribution et ++ de la variable choisie
  output$distPlot <- renderPlot({
    if (is.null(input$file1)) { return() }
    # Déclaration de variables pour la suite
    ## le tableau importé est contenu dans [d]
    d = Data()
    ## la variable continue choisie est contenue dans [var.con]
    var.con = d[[input$var.et]]
    ## le nombre de classes choisies avec le slider est contenu dans [k]
    k <- input$k
    ##la méthode de discretisation choisie par menu déroulant est contenue dans [m]
    # elle est recodée ici pour correspondre aux options du package classInt 
    ### A FAIRE: ajouter méthodes: prog arithm, prog géom, moyenne emboitees
    ### + faire apparaitre un petit texte explicatif à chaque choix de méthode
    m <- switch(input$method,
                "amplitudes egales" = "equal",
                "ecarts-types" = "sd",
                "effectifs egaux (quantiles)" = "quantile",
                "algorithme de Jenks" = "jenks" )
    
    # je sais plus a quoi cette ligne servait
    # k <- seq(min(x), max(x), length.out = input$k + 1)
    
    ## Application de la fonction classIntervals avec la variable, le nombre de classe et la méthode choisies
    klass <- classIntervals(var.con, k, style = m)
    ## récupération des bornes sous forme d'un vecteur (une liste sous la forme c(1,2,3))
    brks <- klass$brks
    
    # préparer les paramètres graphiques généraux
    # par (xpd = TRUE) # permet de dessiner au dela des marges
    # mfrow = c(2,1)) # sur 2 lignes et 1 colonne
    
    ## A FAIRE: ajouter les efectifs par classes
    ## un résumé statistique (nottament N=effectif), peut être en légende ou dans le titre
    
    # Dessiner l'histogramme
    ## en déclarant la variable
    hist(var.con,
         ## les bornes de classes
         breaks = brks,
         ## densité en ordonnées (et non pas la frequency = affectif) 
         freq = FALSE, 
         ## couleurs(palette(nbre,transparence))/pas de bordure
         col = grey.colors(input$k, start = 0.5, end = 0.1), border = "white",
         ## titre principal
         main = paste("Histogramme de distribution de la variable",input$var.et),
         ## titre axe des abcisses
         xlab = "classes",
         ## titre axe des ordonnées
         ylab = "densité d'effectif",
         ## sans titre axe des abcisses
         axes = FALSE)
    # paramétrer les axes (1 = abcisse, at = implantation des taquets)
    axis(1, pos = 0, at = round(brks, digits = 1))
    axis(1, pos = 10, at = mean(var.con, na.rm=T))
    
    # Tracer la moyenne et la médiane
    abline( v= mean(var.con, na.rm=T), col = "royalblue", lwd = 1.5)
    abline( v= median(var.con, na.rm=T), col = "red", lwd = 1.5)
    mo = mean(var.con, na.rm=T)
    # Tracer les écarts-types en positif puis en négatif
    abline( v= seq(mean(var.con, na.rm=T)+sd(var.con, na.rm=T),max(var.con, na.rm=T), along.with = sd(var.con, na.rm=T) ), col = "gold", lty = 2)
    abline( v= seq(mean(var.con, na.rm=T)-sd(var.con, na.rm=T),min(var.con, na.rm=T), along.with = sd(var.con, na.rm=T) ), col = "gold", lty = 2)
    
    # Afficher une légende
    legend(
      ## position de la légende
      "topleft",
      ## textes
      legend=c(
        paste("moyenne ", round(mean(var.con, na.rm=T), digits = 1)),
        paste("écarts-types +/-", round(sd(var.con, na.rm=T), digits = 1)),
        paste("médiane ", round(median(var.con, na.rm=T), digits = 1))
      ),
      ## couleurs
      col=c("royalblue", "gold", "red"),
      ## types de traits
      lty= c(1.5,2,1.5),
      ## position des élements
      horiz = TRUE,
      ## taille de police
      cex=0.8)
    
    # Affichage d'un scalogramme si coché
    # PROBLEME de superposition, il faudrait le mettre sur l'axe des abcisses
    if (input$scalo) {
      # ajouter un stripchart
      par(new= TRUE)
      stripchart(var.con, 
                 ## methode de dispersion des points (stack=empilé)
                 method = "stack",
                 ## forme des points
                 pch = 20,
                 ## couleur des points
                 col = "blue",
                 ## sans axe
                 axes = FALSE)
    } # scalo
    
    # Affichage d'une boîte à moustache si coché
    # PROBLEME de superposition, il faudrait la mettre juste en dessous ou sans fond
    if (input$stach) {
      # Ajouter une Boite à Moustache
      ## le prochain graph s'ajoutera au suivant
      par (new = TRUE    )
      # ajouter une box plot
      boxplot(var.con, horizontal = TRUE,
              # sans axes
              axes = FALSE)
      # Ajouter la moyenne et la médiane
      # il faudrait le faire plus joliment en se limitant à la largeur de la boxplot
      #abline( v= mean(var.con, na.rm = T), col = "royalblue", lwd = 1.5)
      #abline( v= median(var.con), col = "red", lwd = 1.5)
    } # stach
    
    ### A FAIRE Ajouter la possibilité de télécharger la figure finale !!!
    
  }) # renderPlot 'Distplot'
}) # shinyserver