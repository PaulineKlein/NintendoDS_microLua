-- initialisation :
symboles = {{"", "", ""}, {"", "", ""}, {"", "", ""}} -- le tableau
ligne= 0
colonne=0
compteur = 0
joueur= 'X'
joueurP= ""
booleen=false
booleen2=false
quitter=false

-- On charge l'image dans la VRAM
imageRond = Image.load("images/rond.png", VRAM)
imageCroix = Image.load("images/croix.png", VRAM)
imageFondUp= Image.load("images/fondUp.png", VRAM)


-- Déclaration de la fonction qui délimite ou se trouve le stylet
function positionStylet(x,y)
	local i = 0
	local j= 0
	
	 if y < 64 then
		if x < 85 then
			i,j=1,1
		elseif x > 170 then
			i,j=3,1
		else
			i,j=2,1
		end
			
	 elseif y > 128 then
        if x < 85 then
			i,j=1,3
		elseif x > 170 then
			i,j=3,3
		else
			i,j=2,3
		end
	
	else
		if x < 85 then
			i,j=1,2
		elseif x > 170 then
			i,j=3,2
		else
			i,j=2,2
		end
     end
	
	return i,j
end

function gagner(symboles,joueur)

	-- on regarde s'il y a un alignement en ligne :
	for j=1, 3 do
		if symboles[1][j]== joueur and symboles[2][j]== joueur and symboles[3][j]== joueur then
			return true
		end
	end
	
	-- on regarde s'il y a un alignement en colonne :
	for j=1, 3 do
		if symboles[j][1]== joueur and symboles[j][2]== joueur and symboles[j][3]== joueur then
			return true
		end
	end
	
	-- on regarde s'il y a un alignement en diagonale :
	if symboles[1][1]== joueur and symboles[2][2]== joueur and symboles[3][3]== joueur then
		return true
	end
	if symboles[3][1]== joueur and symboles[2][2]== joueur and symboles[1][3]== joueur then
		return true
	end
	
	-- si rien ne marche, on retourne faux
	return false

end

-- boucle principale pour jouer au Morpion :
while not quitter and not Keys.newPress.Start do

	symboles = {{"", "", ""}, {"", "", ""}, {"", "", ""}} -- le tableau
	ligne= 0
	colonne=0
	booleen=false
	booleen2=false
	joueur= 'X'
	joueurP= ""
	

	-- tant que le jeu n'est pas fini ou qu'on ne quitte pas, ca continue :
	while not booleen and not Keys.newPress.Start do

		Controls.read() -- pour mettre à jour les contrôles des boutons

		-- dessin de la croix du morpion :
		 screen.drawFillRect(SCREEN_DOWN, 0, 0, 256, 192, Color.new(31, 31, 31)) -- le fond
		 screen.drawLine(SCREEN_DOWN, 85, 0, 85, 192, Color.new(0, 0, 31))
		 screen.drawLine(SCREEN_DOWN, 170, 0, 170, 192, Color.new(0, 0, 31))	 
		 screen.drawLine(SCREEN_DOWN, 0, 64, 256, 64, Color.new(0, 0, 31))
		 screen.drawLine(SCREEN_DOWN, 0, 128, 256, 128, Color.new(0, 0, 31))
		 
		screen.blit(SCREEN_UP, 0, 0, imageFondUp) 
		screen.print(SCREEN_UP, 90, 30, "GRAND MORPION DS",Color.new(31, 0, 31))
		screen.print(SCREEN_UP, 50, 100, "c'est au joueur "..joueur.." de jouer !",Color.new(0, 31, 0))
		
		-- on dessine la croix ou le rond dans la grille :
		for i = 1, 3 do
			for j = 1, 3 do
				if symboles[i][j] == 'X' then
				screen.blit(SCREEN_DOWN, 90 * (i-1), 65 * (j-1), imageCroix)
				end
				if symboles[i][j] == 'O' then
				screen.blit(SCREEN_DOWN, 90 * (i-1), 65 * (j-1), imageRond)
				end
			end
		end
		
		-- on récupère la position du stylet :
		if Stylus.held then
			ligne,colonne=positionStylet(Stylus.X,Stylus.Y)
			
			-- on regarde ou le joueur a cliqué
			if symboles[ligne][colonne] == "" then
				symboles[ligne][colonne] = joueur		

				-- on passe au joueur suivant :
				if joueur == 'X' then
					joueurP = 'X'
					joueur = 'O'
				else
					joueurP =  'O'
					joueur = 'X'
				end
				
			end	
			
			booleen= gagner(symboles,joueurP) -- si qq gagne on sort de la boucle
		end	
		
		-- si la grille est pleine on sort aussi de la boucle :
		compteur = 0
		for i = 1, 3 do
			for j = 1, 3 do
				if symboles[i][j] == 'X' or symboles[i][j] == 'O' then
					compteur=compteur+1
				end
			end
		end
		if compteur == 9 then
			booleen = true
		end
		
		render()
	end

	
	-- tant qu'on ne veut pas quitter ou recommencer, on affiche les résultats :
	while not booleen2 and not Keys.newPress.Start do
		Controls.read()	

		-- dessin de la croix du morpion :
		 screen.drawFillRect(SCREEN_DOWN, 0, 0, 256, 192, Color.new(31, 31, 31)) -- le fond
		 screen.drawLine(SCREEN_DOWN, 85, 0, 85, 192, Color.new(0, 0, 31))
		 screen.drawLine(SCREEN_DOWN, 170, 0, 170, 192, Color.new(0, 0, 31))	 
		 screen.drawLine(SCREEN_DOWN, 0, 64, 256, 64, Color.new(0, 0, 31))
		 screen.drawLine(SCREEN_DOWN, 0, 128, 256, 128, Color.new(0, 0, 31))
		 screen.blit(SCREEN_UP, 0, 0, imageFondUp) 
		
		-- on dessine la croix ou le rond dans la grille :
		for i = 1, 3 do
			for j = 1, 3 do
				if symboles[i][j] == 'X' then
				screen.blit(SCREEN_DOWN, 90 * (i-1), 65 * (j-1), imageCroix)
				end
				if symboles[i][j] == 'O' then
				screen.blit(SCREEN_DOWN, 90 * (i-1), 65 * (j-1), imageRond)
				end
			end
		end
		
		-- affichage des résultats :
		if compteur == 9 then
			screen.print(SCREEN_UP, 100, 30, "Personne n'a gagné !",Color.new(31, 0, 0))
		else
			screen.print(SCREEN_UP, 100, 30, "le joueur "..joueurP.." a gagné !",Color.new(31, 0, 0))
		end
		
		-- menu pour recommencer :
		screen.print(SCREEN_UP, 10, 100, "Voulez-vous recommencer (A oui, B non) ?",Color.new(0, 0, 31))

		if Keys.held.A then
			booleen = false
			booleen2=true
		end
		if Keys.held.B then
			quitter = true
			booleen2=true
		end
		
		render()
	end
	 
 end


-- destructeurs :
Image.destroy(imageRond)
imageRond = nil
Image.destroy(imageCroix)
imageCroix = nil
Image.destroy(imageFondUp)
imageFondUp = nil
symboles = nil
ligne= nil
colonne= nil
compteur = nil
booleen=nil
booleen2=nil
quitter=nil
joueur=nil
joueurP=nil

