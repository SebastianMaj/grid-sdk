--========= Copyright © 2013-2016, Planimeter, All rights reserved. ==========--
--
-- Purpose: Game Menu Prayer class
--
--============================================================================--

class "hudgamemenuprayer" ( gui.panel )

function hudgamemenuprayer:hudgamemenuprayer( parent )
	gui.panel.panel( self, parent, "Prayer" )
	self:setScheme( "Default" )
	self:setSize( parent:getSize() )
end

function hudgamemenuprayer:draw()
	local property = "button.disabled.textColor"

	graphics.setColor( self:getScheme( property ) )

	local font = self:getScheme( "fontBold" )
	graphics.setFont( font )
	local text = "Panel not implemented"
	local x = self:getWidth()  / 2 - font:getWidth( text ) / 2
	local y = self:getHeight() / 2 - font:getHeight()      / 2 - point( 2 )
	graphics.print( text, x, y )
end

gui.register( hudgamemenuprayer, "hudgamemenuprayer" )
