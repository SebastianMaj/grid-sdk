--========= Copyright © 2013-2016, Planimeter, All rights reserved. ==========--
--
-- Purpose: vaplayer
--
--============================================================================--

require( "engine.shared.entities.player" )

class "vaplayer" ( "player" )

function vaplayer:vaplayer()
	player.player( self )

	-- TODO: Make this affected by skill level.
	self:networkNumber( "health", 100 )

	self.stats   = {
		health   = 0,
		prayer   = 0,
		attack   = 0,
		defense  = 0,
		range    = 0,
		magic    = 0,
		fishing  = 0,
		cooking  = 0,
		mining   = 0,
		smithing = 0
	}

	self.inventory = {}
end

function vaplayer:addExperience( stat, xp )
	self.stats[ stat ] = self.stats[ stat ] + xp
	game.call( "shared", "onPlayerGainedExperience", self, stat, xp )
end

function vaplayer:cast( spellName, target, position )
	require( "game.shared.spells" )
	local spell = spell.getSpell( spellName )
	spell:setCaster( self )
	spell:setTarget( target )
	spell:setPosition( position )
	spell:cast()

	if ( _CLIENT and not _SERVER ) then
		local payload = payload( "playerCast" )
		payload:set( "spell", spell )
		payload:set( "target", target )
		payload:set( "position", position )
		networkclient.sendToServer( payload )
	end
end

if ( _SERVER ) then
	local function onPlayerCast( payload )
		local player   = payload:getPlayer()
		local spell    = payload:get( "spell" )
		local target   = payload:get( "target" )
		local position = payload:get( "position" )
		player:cast( spell, target, position )
	end

	payload.setHandler( onPlayerCast, "playerCast" )
end

function vaplayer:getExperience( stat )
	return self.stats[ stat ] or -1
end

function vaplayer:getInventory()
	return self.inventory
end

function vaplayer:getLevel( stat )
	if ( stat ) then
		return self.stats[ stat ] or -1 / 1
	end

	return -1
end

function vaplayer:give( item, count )
	count = count or 1
	self.inventory[ item ] = ( self.inventory[ item ] or 0 ) + count
	game.call( "shared", "onPlayerGotItem", self, item, count )
end

function vaplayer:hasInventorySpace()
	local total = 0
	for item, count in pairs( self:getInventory() ) do
		local itemdata = _G.item.getData( item )
		if ( not itemdata.stackable ) then
			total = total + count
		else
			total = total + 1
		end
	end
	return total < 28
end

local function moveTo( position )
	return function( character, next )
		character:moveTo( position, next )
	end
end

local function pickup( item )
	return function( vaplayer, next )
		if ( _SERVER ) then
			if ( not vaplayer:hasInventorySpace() ) then
				local text = "You don't have enough inventory space to do that."
				vaplayer:sendText( text )
				return
			end

			local classname = item:getClassname()
			item:remove()
			vaplayer:give( classname )
		end

		next()
	end
end

function vaplayer:pickup( item )
	self:removeTasks()

	local position = item:getPosition()
	self:addTask( moveTo( position ) )
	self:addTask( pickup( item ) )

	if ( _CLIENT and not _SERVER ) then
		local payload = payload( "playerPickup" )
		payload:set( "item", item )
		networkclient.sendToServer( payload )
	end
end

if ( _SERVER ) then
	local function onPlayerPickup( payload )
		local player = payload:getPlayer()
		local item   = payload:get( "item" )
		player:pickup( item )
	end

	payload.setHandler( onPlayerPickup, "playerPickup" )
end

entities.linkToClassname( vaplayer, "vaplayer" )
