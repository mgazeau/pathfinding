# pathfinding

Ce projet implémente en Julia quatre algorithmes pour trouver le plus court chemin entre deux cases à partir d'un fichier avec l'extension .map   
Les algorithmes implémentés sont :

1. Recherche Aveugle : Floodfill
2. Recherche informée optimale : Dijkstra
3. Recherche informée heuristique : A*
4. Recherche informée heuristique pondérée : WA*

## Packages Nécessaires

1. FileIO
2. Colors
3. Images

## Exécution du Code

Une fois dans le dossier pathfinding dans un REPL il faut inclure les 4 fichiers du dossier sources dans l'ordre suivant : 
1. include("src/parseur.jl")
2. include("src/creation_image.jl")
3. include("src/recherche_aveugle.jl")
4. include("src/recherche_informee.jl")

Il est maintenant possible d'utiliser les 4 fonctions de recherches de plus court chemin.  
Elles prennent en paramètre le chemin vers un fichier .map et deux tuples représentant les coordonnées du point de départ et du point d'arrivée.  
Les 4 fonctions à utilisées sont :
1. recherche_aveugle("path",(x1,y1), (x2,y2))
2. recherche_dijkstra("path",(x1,y1), (x2,y2))
3. recherche_a_etoile("path",(x1,y1), (x2,y2))
4. recherche_wa_etoile("path",(x1,y1), (x2,y2),w)

path doit correspondre à la chaine de caractère du chemin vers un fichier .map (Supporte les fichiers .map contenants les caractères : {'@','T','.','W','S'}).  
(x1,y1),(x2,y2) sont des coordonées des points de la carte compris dans la taille du fichier map.  
Pour WA* w est le coefficient qui pondère l'heuristique.  
Si les coordonées sont des cases impraticable les algorithmes de recherche rendront un chemin vide.  

Si un chemin existe alors le terminal affichera :
1. Le nombre d'opérations effectuées
2. Un vecteur de coordonnées représentant le chemin trouver via l'algo
3. La taille/poids du chemin trouvé
4. Temps d'éxécution de l'algorithme

Une image en couleur sera généré dans un dossier tests

# Exemples

Quelques exemples sont stockés dans le dossier exemple : les images correspondent aux instructions ci-desssous 
1. recherche_aveugle("dat/theglaive.map",(189,193), (226,437))
2. recherche_aveugle("dat/theglaive.map",(88,263), (419,221))
3. recherche_dijkstra("dat/theglaive.map",(189,193), (226,437))
4. recherche_dijkstra("dat/theglaive.map",(88,263), (419,221))
5. recherche_a_etoile("dat/theglaive.map",(189,193), (226,437))
6. recherche_a_etoile("dat/theglaive.map",(88,263), (419,221))
7. recherche_a_etoile("dat/8room_009.map",(46,22), (509,477))
8. recherche_wa_etoile("dat/8room_009.map",(46,22), (509,477))
