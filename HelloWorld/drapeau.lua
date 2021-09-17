coefficient = 50    -- Coefficient de transparence, par défaut à 50

while not Keys.newPress.Start do
    Controls.read()
    
    -- Gestion de la modification du coefficient
    -- Il doit rester entre 1 et 99 !
    if Keys.held.Up and coefficient < 99 then
        coefficient = coefficient + 1
    end
    if Keys.held.Down and coefficient > 1 then
        coefficient = coefficient - 1
    end
    
    -- Affichage du coefficient
    screen.print(SCREEN_UP, 0, 0, "Coefficient de transparence : "..coefficient)

    -- Dessin du premier rectangle
    --screen.setAlpha(coefficient)
    screen.drawFillRect(SCREEN_DOWN, 0, 0, 85, 192, Color.new(0, 0, 31))

    -- Dessin du second rectangle, de transparence "opposée" au premier
    --screen.setAlpha(100 - coefficient)
    screen.drawFillRect(SCREEN_DOWN, 85, 0, 170, 192, Color.new(31, 31, 31))
	
	-- troisième rectangle
	screen.drawFillRect(SCREEN_DOWN, 170, 0, 256, 192, Color.new(31, 0, 0))

    render()
end

coefficient = nil