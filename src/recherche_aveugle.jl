"""
Algorithme de recherche aveugle d'un chemin entre la case de depart et d'arrivee en inondant la carte depuis le point de départ
"""
function flood_fill(carte::Matrix{Int64}, depart::Tuple{Int64,Int64}, arrivee::Tuple{Int64,Int64})
    
    #Pour compter le nombre de case visité
    i::Int64 = 0
    
    m::Int64, n::Int64 = size(carte)

    directions::Vector{Tuple{Int64,Int64}} = [(1, 0), (0, 1), (-1, 0), (0, -1)]
    
    #Vecteur qui représente l'ensemble des chemins en cours de traitement tel que chaque élement corresponde : la case actuelle, la distance entre la case actuelle et le depart, le vecteur des cases par lesquelles le chemin est passé depuis le depart 
    file::Vector{Tuple{Tuple{Int64, Int64}, Int64, Vector{Tuple{Int64, Int64}}}} = [(depart, 0, Vector{Tuple{Int, Int}}(undef, 0))]
    
    #Ensemble des cases déjà visitées
    visite::Set{Tuple{Int, Int}} = Set{Tuple{Int, Int}}()


    while !isempty(file)
    	i=i+1 #On compte une opération
        (x::Int64, y::Int64), distance::Int64, chemin::Vector{Tuple{Int64,Int64}} = popfirst!(file)

	#Condition d'arrêt : la case actuelle est la case d'arrivée
        if (x, y) == arrivee
            println("Nombre de cases évaluées : $i")
            return chemin,visite
        end
	
	#Si le point regardé est une case non praticable on passe au prochain chemin
        if (x, y) in visite || carte[x, y] == 0 || carte[x, y] == -1 
            continue
        end

	#La case est ajouté aux case visitées
        push!(visite, (x, y))
	
	#On regarde les 4 cases voisines
        for (dx::Int64, dy::Int64) in directions
            n_x, n_y = x + dx, y + dy

            if 1 <= n_x <= m && 1 <= n_y <= n && (carte[n_x, n_y] >= 1 )
            	#Si la case voisine est praticable alors on ajoute dans la file de de traitement de nos chemins
                push!(file, ((n_x, n_y), distance + 1, vcat(chemin, [(n_x, n_y)])))
            end
        end
    end
    
    return [],visite  # Pas de chemin trouvé
end


function recherche_aveugle(fichier::String,depart::Tuple{Int64,Int64}, arrivee::Tuple{Int64,Int64})
	carte::Matrix{Int64} = lire_fichier_map(fichier)
	
        getTime = time()
	
	chemin::Vector{Tuple{Int64,Int64}},visite = flood_fill(carte,depart,arrivee)
	
	temps = round(time() - getTime,digits=6)
	
	if chemin != []
        #Affichage des données
	    println("Chemin obtenu avec flood_fill : $chemin")
	    taille = length(chemin)
	    println("Taille du chemin $taille")
	    println("Temps d'execution $temps")

        #Création de l'image avec le chemin
        image = matrice_to_image(carte, chemin, visite, arrivee, depart)
        save_image(image,"tests/chemin_aveugle.png")
	else
	    println("Pas de chemin possible")
	end
end
