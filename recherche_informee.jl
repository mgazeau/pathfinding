"""
Procedure qui ajoute element à dictionnaire, si la clé est déjà présente on l'ajoute à la liste, sinon on créé la liste avec l'element
"""
function ajouter_dico(dictionnaire::Dict{Int64, Vector{Tuple{Int,Int}}}, cle::Int64, element::Tuple{Int,Int})
    if haskey(dictionnaire, cle)
        push!(dictionnaire[cle], element)
    else
        dictionnaire[cle] = [element]
    end
end

"""
Fonction qui, si le dictionnaire contient au moins un élement, supprime et renvoie un element de la liste qui a la plus petite cle sinon renvoie (-1,-1) 
"""
function defile_dico(dictionnaire::Dict{Int64, Vector{Tuple{Int,Int}}})
    #cas de fin
    isempty(dictionnaire) && return (-1,-1)

    cle_min::Int64 = minimum(collect(keys(dictionnaire)))
    valeur::Tuple{Int,Int} = popfirst!(dictionnaire[cle_min])
    isempty(dictionnaire[cle_min]) && delete!(dictionnaire, cle_min)

    return valeur
end

"""
Procedure qui supprime element du dictionnaire
Precondition : le dictionnaire n'est pas vide 
"""
function enlever_dico(dictionnaire, cle, element)
    filter!(x -> x != element, dictionnaire[cle])
    isempty(dictionnaire[cle]) && delete!(dictionnaire, cle)
end

"""
Fonction qui recupère dans un vecteur les prédecesseurs de chaque case en partant de l'arrivee jusqu'au depart et le retourne
Precondition : Matrice n'est pas vide et il existe n un entier tel que predecesseur(arrivee)^n = depart
"""
function plus_court_chemin(pred::Matrix{Tuple{Int64, Tuple{Int64, Int64}}}, depart::Tuple{Int, Int}, arrivee::Tuple{Int, Int})
    chemin::Vector{Tuple{Int64,Int64}} = []
    sommet_courant::Tuple{Int, Int} = arrivee

    while sommet_courant != depart
        pushfirst!(chemin, sommet_courant)
        sommet_courant = pred[sommet_courant[1],sommet_courant[2]][2]
    end
    pushfirst!(chemin, depart)
    return chemin
end

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------- Algo Dijkstra-----------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------


"""
Algorithme de recherche informé optimale dijkstra du plus court chemin entre la case de depart et d'arrivee en fonction du cout de traversé des cases
La matrice carte represente les cases du fichier map par le cout nécessaire pour les traverser 
"""
function dijkstra(carte::Matrix{Int64},depart::Tuple{Int64,Int64},arrivee::Tuple{Int64,Int64})

    (dep_x::Int64,dep_y::Int64) = depart
    (arr_x::Int64,arr_y::Int64) = arrivee

    #On gère le cas où l'arrivee et/ou le depart sont des cases impraticable
    if carte[dep_x,dep_y] <= 0 || carte[arr_x,arr_y] <= 0
        println("Les cases de depart et/ou d'arrivee sont incorrects")
        return []
    else

        m::Int64, n::Int64 = size(carte)
        
        # g est la matrice qui represente pour chaque case de la carte : son "poids" totale depuis la case de départ et la case qui le précède dans le chemin qui a le poids le plus faible à un moment donné depuis la case de depart
        # On l'initialise à des valeurs très grande sauf pour la case de départ qui à son poids à 0
        g::Matrix{Tuple{Int64, Tuple{Int64, Int64}}} = fill((typemax(Int), (typemax(Int), typemax(Int))), m, n)
        g[dep_x,dep_y] = (0,(typemax(Int), typemax(Int)))

        # file_dico represente une file de priorité, qui permet d'acceder rapidement à la case en cours de traitement qui possède le meilleur coût depuis la case de départ
        # Ici le coût,representé par les clés du dictionnaire, correspond à au poids de la case stocké dans g
        file_dico::Dict{Int, Vector{Tuple{Int,Int}}} = Dict()

        directions = [(1, 0), (0, 1), (-1, 0), (0, -1)]

        for (x, y) in directions
            n_x, n_y = x + dep_x, y + dep_y

            if 1 <= n_x <= m && 1 <= n_y <= n
                if carte[n_x,n_y] > 0

                    #Le poids de la nouvelle case correspond au point de l'ancienne + son cout de traversée
                    n_g = g[dep_x,dep_y][1] + carte[dep_x,dep_y]
                    #La matrice g est actualisé pour la nouvelle case
                    g[n_x,n_y] = (n_g,(dep_x,dep_y))
                    #On ajoute à la file la nouvelle case en focntion de sont cout
                    ajouter_dico(file_dico,n_g,(n_x,n_y))
                end
            end
        end

        #on recupère le premier élement de la file
        premier = defile_dico(file_dico)

        #Parcours de la carte jusqu'à l'arrivee ou jusqu'à ce que la file soit vide : cas où premier = (-1,-1)
        while premier != (-1,-1) && premier != arrivee
            (p_x,p_y) = premier

            #On étudie les cases voisines de la case courante
            for (x, y) in directions
                n_x, n_y = x + p_x, y + p_y

                if 1 <= n_x <= m && 1 <= n_y <= n
                    if carte[n_x,n_y] > 0

                        n_g = g[p_x,p_y][1] + carte[p_x,p_y]

                        #Si la case n'a jamais été visité
                        if g[n_x,n_y][1] == typemax(Int)
                            g[n_x,n_y] = (n_g,(p_x,p_y))
                            ajouter_dico(file_dico,n_g,(n_x,n_y))
                        else
                        #Si la case a déjà été visité on vérifie si le poids de l'ancien chemin est meilleur
                            if n_g < g[n_x,n_y][1] 
                                #On remplace les anciennes information si le cout du nouveau chemin est meilleur
                                enlever_dico(file_dico,g[n_x,n_y][1],(n_x,n_y))
                                g[n_x,n_y]=(n_g,(p_x,p_y))
                                ajouter_dico(file_dico,n_g,(n_x,n_y))
                            end
                        end
                    end
                end
            end
            premier = defile_dico(file_dico)
        end


        if premier == arrivee
            #Renvoie le vecteur du chemin trouvé par l'algorithme
            return plus_court_chemin(g, depart, arrivee)
        else
            #Cas où il n'existe pas de chemin entre le depart et l'arrivee
            return []
        end
    end
end


function recherche_dijkstra(fichier::String,depart::Tuple{Int64,Int64}, arrivee::Tuple{Int64,Int64})
	carte::Matrix{Int64} = lire_fichier_map(fichier)
	chemin::Vector{Tuple{Int64,Int64}} = dijkstra(carte,depart,arrivee)
	
	if chemin != []
        #Affichage de la liste des cases du chemin sur le terminal
	    println("Chemin obtenu avec dijkstra : $chemin")

        #création de l'image avec le chemin
        image = matrice_to_image(carte, chemin, arrivee, depart)
        save_image(image,"chemin_dijkstra.png")
	else
	    println("Pas de chemin possible")
	end
end


#--------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------Algo A*--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------


"""
Fonction qui retourne la distance entre deux points de dimension 2
"""
function distance(point1::Tuple{Int, Int}, point2::Tuple{Int, Int})
    x1, y1 = point1
    x2, y2 = point2

    return round(Int,sqrt((x2 - x1)^2 + (y2 - y1)^2))
end

"""
Algorithme de recherche informé heuristique A* du plus court chemin entre la case de depart et d'arrivee en fonction du cout de traversé des cases et de la distance au point d'arrivee
La matrice carte represente les cases du fichier map par le cout nécessaire pour les traverser 
"""
function a_etoile(carte::Matrix{Int64},depart::Tuple{Int64,Int64},arrivee::Tuple{Int64,Int64})

    (dep_x::Int64,dep_y::Int64) = depart
    (arr_x::Int64,arr_y::Int64) = arrivee

    #On gère le cas où l'arrivee et/ou le depart sont des cases impraticable
    if carte[dep_x,dep_y] <= 0 || carte[arr_x,arr_y] <= 0
        println("Les cases de depart et/ou d'arrivee sont incorrects")
        return []
    else

        m::Int64, n::Int64 = size(carte)
        
        # g est la matrice qui represente pour chaque case de la carte : son "poids" totale depuis la case de départ et la case qui le précède dans le chemin qui a le poids le plus faible à un moment donné depuis la case de depart
        # On l'initialise à des valeurs très grande sauf pour la case de départ qui à son poids à 0
        g::Matrix{Tuple{Int64, Tuple{Int64, Int64}}} = fill((typemax(Int), (typemax(Int), typemax(Int))), m, n)
        g[dep_x,dep_y] = (0,(typemax(Int), typemax(Int)))

        # file_dico represente une file de priorité, qui permet d'acceder rapidement à la case en cours de traitement qui possède le meilleur coût depuis la case de départ
        # Ici le coût,representé par les clés du dictionnaire, correspond à l'addition du poids de la case stocké dans g et de sa distance par rapport à l'arrivee 
        file_dico::Dict{Int, Vector{Tuple{Int,Int}}} = Dict()

        directions = [(1, 0), (0, 1), (-1, 0), (0, -1)]

        # On initialise le dictionnaire avec les cases voisines du depart si elles sont praticable 
        for (x, y) in directions
            n_x::Int64, n_y::Int64 = x + dep_x, y + dep_y

            if 1 <= n_x <= m && 1 <= n_y <= n
                if carte[n_x,n_y] > 0
                    
                    #Le poids de la nouvelle case correspond au point de l'ancienne + son cout de traversée
                    n_g = g[dep_x,dep_y][1] + carte[dep_x,dep_y]
                    #La matrice g est actualisé pour la nouvelle case
                    g[n_x,n_y] = (n_g,(dep_x,dep_y))
                    #On ajoute à la file la nouvelle case en focntion de sont cout
                    f = n_g + distance((n_x,n_y),arrivee)
                    ajouter_dico(file_dico,f,(n_x,n_y))
                end
            end
        end

        #on recupère le premier élement de la file
        premier = defile_dico(file_dico)

        #Parcours de la carte jusqu'à l'arrivee ou jusqu'à ce que la file soit vide : cas où premier = (-1,-1)
        while premier != (-1,-1) && premier != arrivee
            (p_x,p_y) = premier

            #On étudie les cases voisines de la case courante
            for (x, y) in directions
                n_x, n_y = x + p_x, y + p_y

                if 1 <= n_x <= m && 1 <= n_y <= n
                    if carte[n_x,n_y] > 0

                        n_g = g[p_x,p_y][1] + carte[p_x,p_y]
                        h = distance((n_x,n_y),arrivee)
                        f = n_g + h

                        #Si la case n'a jamais été visité
                        if g[n_x,n_y][1] == typemax(Int)
                            g[n_x,n_y] = (n_g,(p_x,p_y))
                            ajouter_dico(file_dico,f,(n_x,n_y))
                        else
                        #Si la case a déjà été visité on vérifie si le cout de l'ancien chemin est meilleur
                            if f < g[n_x,n_y][1] + h
                                #On remplace les anciennes information si le cout du nouveau chemin est meilleur
                                enlever_dico(file_dico,g[n_x,n_y][1]+h,(n_x,n_y))
                                g[n_x,n_y]=(n_g,(p_x,p_y))
                                ajouter_dico(file_dico,f,(n_x,n_y))
                            end
                        end
                    end
                end
            end
            premier = defile_dico(file_dico)
        end


        if premier == arrivee
            #Renvoie le vecteur du chemin trouvé par l'algorithme
            return plus_court_chemin(g, depart, arrivee)
        else
            #Cas où il n'existe pas de chemin entre le depart et l'arrivee
            return []
        end
    end
end


function recherche_a_etoile(fichier::String,depart::Tuple{Int64,Int64}, arrivee::Tuple{Int64,Int64})
	carte::Matrix{Int64} = lire_fichier_map(fichier)
	chemin::Vector{Tuple{Int64,Int64}} = a_etoile(carte,depart,arrivee)
	
	if chemin != []
        #Affichage de la liste des cases du chemin sur le terminal
	    println("Chemin obtenu avec A* : $chemin")

        #création de l'image avec le chemin
        image = matrice_to_image(carte, chemin, arrivee, depart)
        save_image(image,"chemin_A*.png")
	else
	    println("Pas de chemin possible")
	end
end


recherche_aveugle("theglaive.map",(88,263), (419,221))
