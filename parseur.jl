using FileIO

"""
Fonction qui transforme le contenu d'un fichier map comprenant les caractère {'@','T','.','W'} en matrice d'entier 
"""
function lire_fichier_map(nom_fichier::String)

    # Recupèration du contenu du fichier
    fichier = open(nom_fichier, "r")
    contenu::String = read(fichier, String)
    close(fichier)

    # Divise le contenu en lignes
    lignes::Array{String} = split(contenu, '\n')

    # Recupèration de la hauteur et de la largeur de la carte
    hauteur::Int64, largeur::Int64 = parse(Int, split(lignes[2])[2]), parse(Int, split(lignes[3])[2])

    # Initialise la matrice avec des zéros
    matrice::Matrix{Int64} = zeros(Int, hauteur, largeur)

    # Remplit la matrice en fonction des caractères du fichier .map
    for i in 1:hauteur
        for (j, char) in enumerate(lignes[4 + i])
            if char == '@'
                matrice[i, j] = -1  
            elseif char == 'T'
                matrice[i, j] = 0   
            elseif char == '.'
                matrice[i, j] = 1 
            elseif char == 'S'
                matrice[i, j] = 2 
            elseif char == 'W'
                matrice[i, j] = 3 
            end
        end
    end

    return matrice
end

