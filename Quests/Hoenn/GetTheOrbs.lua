-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @WiWi__33[NetPapa] @Melt


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local level = 60
local name		  = 'GetTheOrbs'
local description = ' Clear Rival, level ' .. level .. ' in lillycove and go to Mt. Pyre get the Orbs'

local dialogs = {
	jack = Dialog:new({ 
		"Many lives were lost"
	})
}

local GetTheOrbs = Quest:new()

function GetTheOrbs:new()
	return Quest.new(GetTheOrbs, name, description, level, dialogs)
end

function GetTheOrbs:isDoable()
	return self:hasMap() and hasItem("Feather Badge") and not hasItem("Blue Orb")
end

function GetTheOrbs:isDone()
	return hasItem("Blue Orb")
end

function GetTheOrbs:PokecenterFortreeCity()
	return self:pokecenter("Fortree City")
end

function GetTheOrbs:FortreeCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Fortree City" then
		return moveToMap("Pokecenter Fortree City")
	else
		return moveToMap("Route 120")
	end
end

function GetTheOrbs:FortreeGym()
	return moveToMap("Fortree City")
end

function GetTheOrbs:Route120()
	return moveToMap("Route 121")
end

function GetTheOrbs:Route121()
	if not self:isTrainingOver() then
		return moveToMap("Lilycove City")
	end
	return moveToMap("Route 122")
end

function GetTheOrbs:LilycoveCity()
	if isNpcOnCell(3,23) then
		return talkToNpcOnCell(3,23)
	elseif self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Lilycove City" then
		return moveToMap("Pokecenter Lilycove City")
	elseif self:isTrainingOver() then
		return moveToMap("Route 121")
	else
		return moveToRectangle(78,30,87,37)
	end
end

function GetTheOrbs:PokecenterLilycoveCity()
	self:pokecenter("Lilycove City")
end

function GetTheOrbs:Route122()
	return moveToMap("Mt. Pyre 1F")
end

function GetTheOrbs:MtPyre1F()
	return moveToMap("Mt. Pyre 2F")
end

function GetTheOrbs:MtPyre2F()
	return moveToMap("Mt. Pyre 3F")
end

function GetTheOrbs:MtPyre3F()
	if isNpcOnCell(13,26) then
		return moveToCell(13,22)
	else
		return moveToMap("Mt. Pyre Exterior")
	end
end


function GetTheOrbs:MtPyreExterior()
	return moveToMap("Mt. Pyre Summit")
end

function GetTheOrbs:MtPyreSummit()
	if isNpcOnCell(27,12) then 
		return talkToNpcOnCell(27,12)
	elseif isNpcOnCell(26,11) then
		return talkToNpcOnCell(26,11)
	elseif not dialogs.jack.state then
		return moveToCell(27,6)
	else
		return talkToNpcOnCell(26,4)
	end	
end

return GetTheOrbs