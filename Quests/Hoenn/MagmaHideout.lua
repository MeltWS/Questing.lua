-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @WiWi__33[NetPapa]


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Magma Hideout'
local description = ' Clear Magma Hideout'
local level = 60

local dialogs = {
	xxx = Dialog:new({ 
		" "
	})
}

local MagmaHideOut = Quest:new()

function MagmaHideOut:new()
	return Quest.new(MagmaHideOut, name, description, level, dialogs)
end

function MagmaHideOut:isDoable()
	return self:hasMap() and hasItem("Blue Orb") and hasItem("Red Orb")
end

function MagmaHideOut:isDone()
	return not hasItem("Red Orb")
end

function MagmaHideOut:PokecenterLilycoveCity()
	self:pokecenter("Lillycove City")
end

function MagmaHideOut:LillycoveCity()
	return moveToMap("Route 121")
end

function MagmaHideOut:Route120()
	return moveToMap("Route 121")
end

function MagmaHideOut:Route121()
	return moveToMap("Route 122")
end

function MagmaHideOut:MtPyreSummit()
	return moveToMap("Mt. Pyre Exterior")
end

function MagmaHideOut:MtPyreExterior()
	return moveToMap("Mt. Pyre 3F")
end

function MagmaHideOut:MtPyre3F()
	return moveToMap("Mt. Pyre 2F")
end

function MagmaHideOut:MtPyre2F()
	return moveToMap("Mt. Pyre 1F")
end

function MagmaHideOut:MtPyre1F()
	return moveToMap("Route 122")
end

function MagmaHideOut:Route122()
	return moveToMap("Route 123")
end

function MagmaHideOut:Route123()
	return moveToMap("Route 118")
end

function MagmaHideOut:Route118()
	return moveToMap("Mauville City Stop House 4")
end

function MagmaHideOut:MauvilleCityStopHouse4()
	return moveToMap("Mauville City")
end

function MagmaHideOut:MauvilleCity()
	if  self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Mauville City" then
		return moveToMap("Pokecenter Mauville City")
	else
		return moveToMap("Mauville City Stop House 3")
	end
end

function MagmaHideOut:PokecenterMauvilleCity()
	self:pokecenter("Mauville City")
end

function MagmaHideOut:MauvilleCityStopHouse3()
	return moveToMap("Route 111 South")
end

function MagmaHideOut:Route111South()
	return moveToMap("Route 112")
end

function MagmaHideOut:Route112()
	return moveToMap("Cable Car Station 1")
end

function MagmaHideOut:CableCarStation1()
	return talkToNpcOnCell(10,6)
end

function MagmaHideOut:CableCarStation2()
	return moveToMap("Mt. Chimney")
end

function MagmaHideOut:MtChimney()
	return moveToMap("Jagged Pass")
end

function MagmaHideOut:JaggedPass()
	return talkToNpcOnCell(30,35)
end

function MagmaHideOut:MagmaHideout1F()
	return moveToMap("Magma Hideout 2F1R")
end

function MagmaHideOut:MagmaHideout2F1R()
	return moveToMap("Magma Hideout 3F1R")
end

function MagmaHideOut:MagmaHideout3F1R()
	return moveToMap("Magma Hideout 4F")
end

function MagmaHideOut:MagmaHideout4F()
	if isNpcOnCell(16,31) then
		return talkToNpcOnCell(16,31)
	else
		return moveToMap("Magma Hideout 3F3R")
	end
end

return MagmaHideOut