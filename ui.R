
# This is the user-interface definition of a Shiny web application. http://shiny.rstudio.com
# by www.archeomatic.wordpress.com - sylvain.badey@inrap.fr

library(shiny)
library(classInt)
# library(markdown)

# shinyUI(fluidPage(
shinyUI(navbarPage("Discretisator",
                   
                   # ONGLET Intro
                   tabPanel("Introduction",
                            # Menu côté droit 
                            sidebarPanel(
                              p ("on CONTINU à rester DISCRET,"),
                              p("mais avec raison:"),
                              h1 ("Discretisator"),
                              img(src = "archeomatic200.png", height = 40, width = 40),
                              br(),
                              a ("par www.archeomatic.wordpress.com", href = "www.archeomatic.wordpress.com")
                            ), # sidebarPanel
                            
                            # Texte de présentation / définition de la discrétisation.         
                            mainPanel(
                              br(),
                              p("La discrétisation est l’opération qui permet de découper en classes une série de données qualitatives ou quantitatives en vue de sa représentation graphique ou cartographique."),
                              p("La discrétisation simplifie l’information en regroupant dans des classes différentes les objets géographiques qui présentent les mêmes caractéristiques. Cette information est liée à la forme de la distribution initiale."),
                              br(),
                              p(strong("Les règles de base:")),
                              p("    - Les classes doivent couvrir l’ensemble de la distribution, elles doivent être contiguës (jointives)"),
                              p("    - Une valeur ne doit appartenir qu’à une classe et une seule"),
                              p("    - Les classes ne doivent pas être vides"),
                              p("    - Les valeurs limites doivent être précises et rapidement appréhendables"),
                              p("    - Éviter de placer dans deux classes distinctes des valeurs non significativement différentes"),
                              p("    - Ne pas définir des seuils avec un nombre de décimales supérieur à celui de la précision des données"),
                              br(),
                              p(strong("Comment ca marche:")),
                              p("Onglet Import:"),
                              p("- Charger un fichier .csv contenant une variable continue"),
                              p("- A minima, parametrez les séparateur de colonnes et de décimales"),
                              p("  jusqu'à ce que votre tableau apparaisse"),
                              p("- Choisissez le nom de la variable à étudier dans le menu déroulant"),
                              p("Onglet Discretisation:"),
                              p("- Discrétisez !!!")
                              ) # mainPanel
                   ), # tabPanel Introduction
                   
                   # ONGLET import de données
                   tabPanel("Import", 
                            sidebarLayout(
                              sidebarPanel(
                                fileInput('file1', 'Charger le fichier csv',
                                          accept=c('text/csv', 
                                                   'text/comma-separated-values,text/plain', 
                                                   '.csv')),
                                tags$hr(), ## ????
                                # menu déroulant pour choisir lavariable à étudier
                                ## n'apparait qu'après import du tableau
                                uiOutput("choice"),
                                checkboxInput('header','tableau avec titre en 1ere ligne', TRUE),
                                radioButtons('sep', 'Délimiteur de colonnes',
                                             c(virgule=',',
                                               point_virgule=';',
                                               tabulation='\t'),
                                             ','),
                                radioButtons('dec', 'Délimiteur de décimales',
                                             c(virgule=',',
                                               point='.'),
                                             '.'),
                                radioButtons('quote', 'Délimiteur de texte',
                                             c(None='',
                                               'guillemet double'='"',
                                               'guillemet simple (apostrophe)'="'"),
                                             '"')
                              ), # sidebarPanel
                              # Affichage du tableau tel qu'interprété
                              mainPanel(
                                tableOutput('userdata')
                              ) # mainPanel
                            ) # sidebarLayout
                   ), # tabPanel Import
                   
                   # ONGLET Discrétisation
                   tabPanel("Discrétisation",                 
                            # Sidebar
                            # slider pour le nombre de classes
                            sidebarLayout(
                              sidebarPanel(
                                sliderInput("k",
                                            "Nombre de classes:",
                                            ### Il faudrait ici réussier à récupérer les
                                            ### valeurs min et max de la variable
                                            min = 2,
                                            max = 20,
                                            value = 10),
                                
                                
                                # menu déroulant (select input) pour la méthode de discretisation
                                selectInput(
                                  ## inputID
                                  "method",
                                  ## étiquette
                                  "méthode de \n discrétisation:",
                                  ## choix du menu déroulant
                                  c("amplitudes egales", "ecarts-types", "effectifs egaux (quantiles)", "algorithme de Jenks", "progression geometrique (min > 0)"),
                                  ## sélection par défaut
                                  selected = "amplitudes egales"),
                                
                                # case à cocher pour afficher moyenne, mediane et ecart-type
                                checkboxInput(
                                  "param",
                                  label = strong("Afficher afficher moyenne, mediane et ecart-type"),
                                  value = FALSE),
                                # case à cocher pour afficher les effectifs
                                checkboxInput(
                                  "lab.eff",
                                  label = strong("Afficher les effectifs"),
                                  value = FALSE),
                                # case à cocher pour afficher un scalogramme
                                checkboxInput(
                                  "scalo",
                                  label = strong("Afficher le scalogramme"),
                                  value = FALSE),
                                # case à cocher pour afficher une boite à moustache
                                checkboxInput(
                                  "stach",
                                  label = strong("Afficher une boîte à moustache"),
                                  value = FALSE)
                                
                              ), # sidebarPanel
                              
                              
                              # Affichage de l'histogramme de distribution et ++
                              mainPanel(
                                plotOutput("distPlot")
                              ) # mainPanel     
                            ) # sidebarLayout
                   ) # tabPanel Discrétisation
) # navbarPage Discretisator
) # ShinyUI
