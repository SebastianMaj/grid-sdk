--========= Copyright © 2013-2016, Planimeter, All rights reserved. ==========--
--
-- Purpose: Game Menu Borderless Drop-Down List class
--
--============================================================================--

class "borderlessdropdownlist" ( gui.dropdownlist )

function borderlessdropdownlist:borderlessdropdownlist( parent, name )
	gui.dropdownlist.dropdownlist( self, parent, name )
	self.width = point( 202 )
end

function borderlessdropdownlist:drawBackground()
end

function borderlessdropdownlist:drawForeground()
end

gui.register( borderlessdropdownlist, "borderlessdropdownlist" )
