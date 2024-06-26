using Colors
using Images

"""
Fonction qui retourne la matrice qui associe des couleurs aux cases de la carte
"""
function matrice_to_image(carte::Matrix{Int}, chemin::Vector{Tuple{Int64, Int64}}, g::Matrix{Tuple{Int64, Tuple{Int64, Int64}}}, depart::Tuple{Int, Int}, arrivee::Tuple{Int, Int})
    hauteur::Int64, largeur::Int64 = size(carte)
    img::Matrix{RGB} = zeros(RGB, hauteur, largeur)  # Initialise la matrice de couleurs

    for i in 1:hauteur
        for j in 1:largeur
            #On differencie les points du chemin
            if (i,j) in chemin
                if (i,j) == depart
                    img[i, j] = RGB(0.0, 1.0, 0.0)  # Vert
                elseif (i,j) == arrivee
                    img[i, j] = RGB(1.0, 1.0, 0.0)  # Jaune
                else
                    img[i, j] = RGB(1.0, 0.0, 0.0)  # Rouge
                end
            #On differencie les points visités
            elseif carte[i,j] == -1
                img[i, j] = RGB(0.0, 0.0, 0.0)  # Noir
            elseif carte[i,j] == 0
                img[i, j] = RGB(0.5, 0.5, 0.5)  # Gris
            elseif carte[i,j] == 1
                if g[i,j][1] != typemax(Int)
                    img[i, j] = RGB(0.75, 0.5, 0.0)  # Orange
                else
                    img[i, j] = RGB(1.0, 1.0, 1.0)  # Blanc
                end
            elseif carte[i,j] == 5
                if g[i,j][1] != typemax(Int)
                    img[i, j] = RGB(0.75, 0.75, 0.5)  
                else
                    img[i, j] = RGB(0, 1.0, 1.0)  # Cyan
                end
            else
                if g[i,j][1] != typemax(Int)
                    img[i, j] = RGB(0.75, 0.5, 0.5)  
                else
                    img[i, j] = RGB(0.0, 0.0, 1.0)  # Bleu
                end
            end
        end
    end
     
    return img
end


function matrice_to_imageflood(carte::Matrix{Int}, chemin::Vector{Tuple{Int64, Int64}}, visite::Set{Tuple{Int, Int}}, depart::Tuple{Int, Int}, arrivee::Tuple{Int, Int})
    hauteur::Int64, largeur::Int64 = size(carte)
    img::Matrix{RGB} = zeros(RGB, hauteur, largeur)  # Initialise la matrice de couleurs

    for i in 1:hauteur
        for j in 1:largeur
            #On differencie les points du chemin
            if (i,j) in chemin
                if (i,j) == depart
                    img[i, j] = RGB(0.0, 1.0, 0.0)  # Vert
                elseif (i,j) == arrivee
                    img[i, j] = RGB(1.0, 1.0, 0.0)  # Jaune
                else
                    img[i, j] = RGB(1.0, 0.0, 0.0)  # Rouge
                end
            #On differencie les points visités
            elseif carte[i,j] == -1
                img[i, j] = RGB(0.0, 0.0, 0.0)  # Noir
            elseif carte[i,j] == 0
                img[i, j] = RGB(0.5, 0.5, 0.5)  # Gris
            elseif carte[i,j] == 1
                if (i,j) in visite
                    img[i, j] = RGB(0.75, 0.5, 0.0)  # Orange
                else
                    img[i, j] = RGB(1.0, 1.0, 1.0)  # Blanc
                end
            elseif carte[i,j] == 5
                if (i,j) in visite
                    img[i, j] = RGB(0.75, 0.75, 0.5)  # Orange
                else
                    img[i, j] = RGB(0, 1.0, 1.0)  # Cyan
                end
            else
                if (i,j) in visite
                    img[i, j] = RGB(0.75, 0.5, 0.5)  # Orange
                else
                    img[i, j] = RGB(0.0, 0.0, 1.0)  # Bleu
                end
            end
        end
    end
     
    return img
end


function save_image(img::Matrix{RGB}, nomfic::AbstractString)
    save(nomfic, img)
end
