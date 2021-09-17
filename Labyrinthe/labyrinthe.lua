-- CE SCRIPT PERMET DE DEPLACER UN BONHOMME SUR UNE MAP
-- LE SPRITE BOUGE SUR LA MAP, QUAND IL ARRIVE AUX BORDS, LA MAP AVANCE
-- le but : trouver la sortie !!


------------------------------------------------ initialisation

x = 0
y = 0
persoX = 0
persoY = 0
persoX2 = 0
persoY2 = 0
touche = false
quitter=false

-- image en haut :
imageFondUp= Image.load("images/fondUp2.png", VRAM)

-- gestion de la carte :
img = Image.load("images/tilesSol3.png", VRAM)        -- tiles             
map = Map.new(img, "mapSol.map", 15, 15, 32, 32)		-- la map
-- "15, 15", ce sont la longueur et la largeur de la map, en tiles.
-- "32 , 32", ce sont les dimensions d'une tile, en pixels.

-- gestion du sprite : ( fichier, longueur_frame : 72/3, hauteur_frame : 128/4, destination )
perso = Sprite.new("images/sprite.png", 24, 32, VRAM)
-- Direction du perso (utilisé pour le choix de l'animation)
	-- 1 : bas | 2 : gauche | 3 : haut | 4 : droite
direction = 1

-- addAnimation(les numéros des frames dont se compose l'animation début à 0,délai (en millièmes de seconde) entre l'affichage de chaque frame)
perso:addAnimation ({6,7,8,7}, 300)		-- Marcher vers le bas
perso:addAnimation ({9,10,11,10}, 300)	-- Marcher vers la gauche
perso:addAnimation ({0,1,2,1}, 300)		-- Marcher vers le haut
perso:addAnimation ({3,4,5,4}, 300)		-- Marcher vers la droite


function mvtPerso()

	touche = true
	if Keys.held.Up and persoY > 0 then -- attention le perso ne doit pas sortir de l'écran ni aller dans le ciel!
		direction,persoY2 = 3,persoY-1
	elseif Keys.held.Down and persoY < 165 then
		direction,persoY2 = 1,persoY+1
	elseif Keys.held.Left and persoX > 0 then
		direction,persoX2 = 2,persoX-1
	elseif Keys.held.Right and persoX < 237 then
		direction,persoX2 = 4,persoX+1
	else
		touche = false
	end

	-- on regarde si pour les nouvelle coordonnées, on reste bien sur le chemin (un mur a pour numéro de tile 3):
	-- Pour obtenir la tile présente sous les pieds du perso :
	-- il faut convertir les coordonnées pixels du perso en tiles : on divise par la taille en pixel d'une tiles (32), on le transforme en int
	-- attention persoX2 et persoY2 sont les coordonnées en haut à gauche du perso : on les ramene au milieu (taille perso 32x32 donc le milieu 16x16)
	-- il faut translater par les coordonnées du tiles en haut a gauche de l'écran (car la map bouge avec le perso) : par x et y
	
	if Map.getTile(map, math.floor((persoX2+16)/32)+x, math.floor((persoY2+16)/32)+y)== 3 then
		return direction, persoX, persoY, touche -- si on va sur un mur, on ne bouge pas, on remet les anciennes coordonnées
	else
		return direction, persoX2, persoY2, touche -- si on reste sur le chemin on lui attribue les nouvelles coordonnées
	end
	
end


------------------------------------------------- boucle principale

while not quitter and not Keys.newPress.Start do
    Controls.read()
	
	-- Gestion de l'ecran en haut :
	screen.blit(SCREEN_UP, 0, 0, imageFondUp)
	screen.drawFillRect(SCREEN_UP, 80, 25, 242, 40, Color.new(31, 31, 31)) -- le fond
	screen.print(SCREEN_UP, 85, 30, "Labyrinthe Passe-muraille",Color.new(31, 0, 31))
	screen.drawFillRect(SCREEN_UP, 18, 145, 150, 170, Color.new(31, 31, 31)) -- le fond
	screen.print(SCREEN_UP, 20, 150, "Pour recommencer : B",Color.new(0, 0, 31))
	screen.print(SCREEN_UP, 20, 160, "Pour quitter : A",Color.new(0, 0, 31))
	
	Map.draw(SCREEN_DOWN, map, 0, 0, 15, 15) 		-- pour afficher la map
	--  l'écran, la map à afficher, les coordonnées X et Y du coin haut-gauche de la map, 
	-- 	et le nombre de tiles à afficher, sur la longueur et sur la hauteur.
	perso:playAnimation (SCREEN_DOWN,persoX,persoY,direction) 	-- On affiche le sprite

	-- pour faire bouger le perso
	direction, persoX, persoY, touche = mvtPerso()
	if touche then						 -- Si le sprite doit bouger, on lance l'animation (playAnimation le fait déjà, mais il
		perso:startAnimation (direction) -- faut quand même faire startAnimation si l'animation a été réinitialisée, et donc arrêtée
	else
		perso:resetAnimation (direction) -- Sinon, on remet l'animation à zéro pour le prochain déplacement
	end
	
	-- pour faire bouger la map quand on arrive aux bords : on remet le perso sur le carré préceddent pour qu'il ne puisse pas sortir du chemin
	if Keys.newPress.Up and y > 0 and persoY <= 2 then
			y, persoY = y-1, persoY+32
	elseif Keys.newPress.Down and  y < 9 and persoY >= 164 then
			y, persoY = y+1, persoY-32
	elseif Keys.newPress.Left and  x > 0 and persoX <= 2 then
			x, persoX = x-1, persoX+32
	elseif Keys.newPress.Right and x < 7 and persoX >= 236 then
			x, persoX = x+1, persoX-32	
	end
		Map.scroll(map, x, y)
	    
	if Map.getTile(map, math.floor((persoX)/32)+x, math.floor((persoY)/32)+y)== 0 then
		screen.drawFillRect(SCREEN_UP, 80, 45, 242, 100, Color.new(31, 31, 31)) -- le fond
		screen.print(SCREEN_UP, 85, 50, "Utilisez les fleches",Color.new(11, 0, 31))
		screen.print(SCREEN_UP, 85, 60, "pour vous deplacer",Color.new(11, 0, 31))
		screen.print(SCREEN_UP, 85, 70, "En vous approchant du bord",Color.new(11, 0, 31))
		screen.print(SCREEN_UP, 85, 80, "Recliquez sur une flèche",Color.new(11, 0, 31))
		screen.print(SCREEN_UP, 85, 90, "pour bouger la carte",Color.new(11, 0, 31))
	elseif Map.getTile(map, math.floor((persoX)/32)+x, math.floor((persoY)/32)+y)== 1 then
		screen.drawFillRect(SCREEN_UP, 80, 55, 242, 70, Color.new(31, 31, 31)) -- le fond
		screen.print(SCREEN_UP, 85, 60, "Bravo vous avez gagné !!",Color.new(11, 0, 31))
	end

	if Keys.newPress.A then
		quitter = true
	elseif Keys.newPress.B then
		-- on réinitialise les données :
		x = 0
		y = 0
		persoX = 0
		persoY = 0
		persoX2 = 0
		persoY2 = 0
		touche = false
		quitter = false
	end
	
	render()	
end



----------------------------------------------------- destructeur
Image.destroy(imageFondUp)
imageFondUp = nil
Image.destroy(img)                                   
img = nil
Map.destroy(map)                                         
map = nil
perso:destroy()
perso = nil
x = nil
y = nil
persoX = nil
persoY = nil
persoX2 = nil
persoY2 = nil
touche = nil
quitter = nil