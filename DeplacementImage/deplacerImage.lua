-- ou comment faire bouger une image avec le stylet :

img = Image.load("images/tp.png", VRAM) -- On charge l'image

while not Keys.held.Start do -- On crée la boucle de pause
	Controls.read() -- On met à jour les commandes
	
	 screen.blit(SCREEN_DOWN, Stylus.X- Image.width(img) / 2, Stylus.Y- Image.height(img) / 2, img)
	
	render()

end

-- On efface l'image de la mémoire
Image.destroy(img)
img = nil