# Conducting social network analysis with animal telemetry data: applications and methods using spatsoc



[![DOI](https://zenodo.org/badge/186687068.svg)](https://zenodo.org/badge/latestdoi/186687068)



- Authors:
  - [Alec L. Robitaille](http://robitalec.ca)
  - [Quinn M.R. Webber](https://qwebber.weebly.com/)
  - [Eric Vander Wal](http://weel.gitlab.io)


`spatsoc` [paper](https://doi.org/10.1111/2041-210X.13215), [website](http://spatsoc.robitalec.ca/) and [repository](https://github.com/ropensci/spatsoc). 


### Summary
1. We present `spatsoc`: an R package for conducting social network analysis with animal telemetry data.

1. Animal social network analysis is a method for measuring relationships between individuals to describe social structure. Proximity-based social networks are generated from animal telemetry data by grouping relocations temporally and spatially, using thresholds that are informed by the characteristics of the species and study system.

1. `spatsoc` fills a gap in R packages by providing flexible functions, explicitly for animal telemetry data, to generate edge lists and gambit-of-the-group data, perform data-stream randomization and generate group by individual matrices. 

1. The implications of `spatsoc` are that current users of animal telemetry or otherwise georeferenced data for movement or spatial analyses will have access to efficient and intuitive functions to generate social networks.

----

1. Voici `spatsoc`: un R package pour effectuer l’analyse des réseaux sociaux d’espèces animales à partir de données télémétriques.

1. L’analyse des réseaux sociaux est une méthode pour évaluer les relations entre les individus pour comprendre leur structure sociale. Les données télémétriques peuvent être complexes et la fréquence des déplacements peuvent varier, il est donc nécessaire d’avoir la capacité de sélectionner des limites temporelles et spatiales précises selon les caractéristiques des espèces étudiées.

1. `spatsoc` comble une lacune du langage de programmation R en offrant des fonctions flexibles, créées spécifiquement pour les suivis télémétriques d'espèces animales. Il produit des réseaux sociaux, effectue des randomisations des données et génère des matrices de groupes.

1. L'utilisation de `spatsoc` permettra aux usagers de suivi télémétrique d'animau, d'avoir accès à un outil d'analyse de données spatiales et temporelles efficace et intuitif reproduisant les réseaux sociaux des populations animales. 



### Data

Data used for most figures and tables is the example data from `spatsoc` (also `data/DT.csv`). The exception is the small mock dataset provided in this repository (`data/example-pts.Rds`).

```r
# install.packages('spatsoc')

library(data.table)
library(spatsoc)

DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))
```
