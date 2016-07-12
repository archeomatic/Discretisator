# Discretisator
shiny Rstudio webapp to analyse and make a good discretisation for a continuous variable

La discrétisation est l’opération qui permet de découper en classes une série de données qualitatives ou quantitatives en vue de sa représentation graphique ou cartographique.

La discrétisation simplifie l’information en regroupant dans des classes différentes les objets géographiques qui présentent les mêmes caractéristiques. Cette information est liée à la forme de la distribution initiale.

## Les règles de base:

- Les classes doivent couvrir l’ensemble de la distribution, elles doivent être contiguës (jointives)
- Une valeur ne doit appartenir qu’à une classe et une seule
- Les classes ne doivent pas être vides
- Les valeurs limites doivent être précises et rapidement appréhendables
- Éviter de placer dans deux classes distinctes des valeurs non significativement différentes
- Ne pas définir des seuils avec un nombre de décimales supérieur à celui de la précision des données


## Comment ca marche:

Onglet Import:
- Charger un fichier .csv contenant une variable continue
- A minima, parametrez les séparateur de colonnes et de décimales
  jusqu'à ce que votre tableau apparaisse
- Choisissez le nom de la variable à étudier dans le menu déroulant
 
Onglet Discretisation:
- Discrétisez !!!
