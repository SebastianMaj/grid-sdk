--========= Copyright © 2013-2016, Planimeter, All rights reserved. ==========--
--
-- Purpose: Dialogue interface
--
--============================================================================--

local _CLIENT  = _CLIENT
local _SERVER  = _SERVER

local engine   = engine
local select   = select
local table    = table
local tostring = tostring
local _G       = _G

module( "dialogue" )

function

function addText( ... )
	local args = { ... }
	for i = 1, select( "#", ... ) do
		args[ i ] = tostring( args[ i ] )
	end

	if ( _CLIENT ) then
		local chat = _G.g_Chat.output
		local text = table.concat( args, "\t" )
		chat:activate()
		chat:insertText( text .. "\n" )

		-- TODO: Set hide time based on reading-time algorithm.
		chat:setHideTime( engine.getRealTime() + 5 )
	end
end
