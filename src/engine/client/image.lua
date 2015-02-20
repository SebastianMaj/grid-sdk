--========= Copyright © 2013-2015, Planimeter, All rights reserved. ==========--
--
-- Purpose: Image class
--
--============================================================================--

-- These values are preserved during real-time scripting.
local images = image and image.images or {}

local graphics = love.graphics

class( "image" )

image.images = images

function image:image( filename )
	self.filename = filename
end

function image:getDrawable()
	local filename = self:getFilename()
	local images   = image.images
	if ( not images[ filename ] ) then
		images[ filename ] = graphics.newImage( filename )
	end
	return images[ filename ]
end

function image:getFilename()
	return self.filename
end

function image:getHeight()
	local image = self:getDrawable()
	return image:getHeight()
end

function image:getWidth()
	local image = self:getDrawable()
	return image:getWidth()
end

function image:setFilename( filename )
	self.filename = filename
end

function image:setWrap( horiz, vert )
	local image = self:getDrawable()
	image:setWrap( horiz, vert )
end

function image:__tostring()
	local t = getmetatable( self )
	setmetatable( self, {} )
	local s = string.gsub( tostring( self ), "table", "image" )
	setmetatable( self, t )
	return s
end
