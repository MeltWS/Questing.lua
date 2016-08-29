-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Melt


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local level = 50
local name		  = 'Feather Badge'
local description = " Level to " .. level .. " and clean Fortree Gym"

local dialogs = {
	xxx = Dialog:new({ 
		" "
	})
}

local FeatherBadgeQuest = Quest:new()

function FeatherBadgeQuest:new()
	return Quest.new(FeatherBadgeQuest, name, description, level, dialogs)
end

function FeatherBadgeQuest:isDoable()
	return self:hasMap() and not hasItem("Feather Badge")
end

function FeatherBadgeQuest:isDone()
	return hasItem("Feather Badge")
end

function FeatherBadgeQuest:Route120()
    if self:isTrainingOver() or self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Fortree City" then
        return moveToMap("Fortree City")
    else
        return moveToWater()
    end
end

function FeatherBadgeQuest:FortreeCity()
    if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Fortree City" then
        return moveToMap("Pokecenter Fortree City")
    elseif not self:isTrainingOver() then
        return moveToMap("Route 120")
    else
        return moveToMap("Fortree Gym")
    end
end

function FeatherBadgeQuest:PokecenterFortreeCity()
	self:pokecenter("Fortree City")
end

function FeatherBadgeQuest:FortreeGym()
	if isNpcOnCell(19,7) then
        return talkToNpcOnCell(19,7)
    end
end

return FeatherBadgeQuest