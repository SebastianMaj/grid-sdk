--========= Copyright © 2013-2016, Planimeter, All rights reserved. ==========--
--
-- Purpose: Frame Tab class
--
--============================================================================--

class "frametab" ( gui.radiobutton )

function frametab:frametab( parent, name, text )
	gui.radiobutton.radiobutton( self, parent, name, text )
	self.text   = text or "Frame Tab"
	local font  = self:getScheme( "font" )
	self.width  = font:getWidth( self.text ) + 2 * point( 24 )
	self.height = point( 61 )
end

function frametab:draw()
	self:drawBackground()
	self:drawText()

	gui.panel.draw( self )
end

function frametab:drawBackground()
	local property = "frametab.backgroundColor"
	local width    = self:getWidth()
	local height   = self:getHeight()

	if ( self:isSelected() ) then
		property = "frametab.selected.backgroundColor"
	elseif ( self.mouseover ) then
		graphics.setColor( self:getScheme( property ) )
		graphics.rectangle( "fill", 0, 0, width, height )
		property = "frametab.mouseover.backgroundColor"
	end

	graphics.setColor( self:getScheme( property ) )

	local selected  = self.mouseover or      self:isSelected()
	local mouseover = self.mouseover and not self:isSelected()
	graphics.rectangle(
		"fill",
		0,
		0,
		width  - ( selected  and point( 1 ) or 0 ),
		height - ( mouseover and point( 1 ) or 0 )
	)

	local lineWidth = point( 1 )
	if ( selected ) then
		graphics.setColor( self:getScheme( "frametab.backgroundColor" ) )
		graphics.line(
			width - lineWidth / 2, 0,     -- Top-left
			width - lineWidth / 2, height -- Bottom-left
		)
	end

	selected = self:isSelected()
	graphics.setColor( self:getScheme( "frametab.outlineColor" ) )
	graphics.line(
		width - lineWidth / 2, 0,
		width - lineWidth / 2, height - ( selected and 0 or point( 1 ) )
	)

	if ( not selected ) then
		graphics.line(
			0,     height - lineWidth / 2, -- Top-right
			width, height - lineWidth / 2  -- Bottom-right
		)
	end
end

function frametab:drawText()
	local property = "button.textColor"

	if ( self:isDisabled() ) then
		property = "button.disabled.textColor"
	end

	graphics.setColor( self:getScheme( property ) )

	local font = self:getScheme( "font" )
	graphics.setFont( font )
	local x = self:getWidth()  / 2 - font:getWidth( self:getText() ) / 2
	local y = self:getHeight() / 2 - font:getHeight()                / 2
	graphics.print( self:getText(), x, y )
end

function frametab:mousepressed( x, y, button, istouch )
	if ( self.mouseover and button == 1 ) then
		self.mousedown = true

		if ( not self:isDisabled() ) then
			local frametabgroup = self:getGroup()
			if ( frametabgroup ) then
				frametabgroup:setSelectedId( self.id )
				self:onClick()
			end
		end
	end

	self:invalidate()
end

function frametab:mousereleased( x, y, button, istouch )
	self.mousedown = false
	self:invalidate()
end

gui.register( frametab, "frametab" )
