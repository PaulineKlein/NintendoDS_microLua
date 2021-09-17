-- On charge l'image dans la VRAM
image = Image.load("images/image.png", VRAM)

while not Keys.held.Start do

	Controls.read() -- pour mettre à jour les contrôles des boutons
	-- On affiche l'image en haut à gauche de l'écran tactile
	screen.blit(SCREEN_DOWN, 0, 0, image) -- Affiche l'image
	
	screen.print(SCREEN_UP, 128, 96, "Bonjour toi !") -- écrit un message
	
	render()
end

-- Et on efface l'image de la mémoire
Image.destroy(image)
image = nil