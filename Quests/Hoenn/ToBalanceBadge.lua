-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @WiWi__33[NetPapa] @Melt


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'ToBalanceBadge'
local description = ' Questing up to Balance Badge'
local level = 45
local trainersBeaten = 0

local dialogs = {
	trainerDone = Dialog:new({
		"Come back later!"
	})
}

local ToBalanceBadge = Quest:new()

function ToBalanceBadge:new()
	return Quest.new(ToBalanceBadge, name, description, level, dialogs)
end

function ToBalanceBadge:isDoable()
	return self:hasMap() and hasItem("Heat Badge") and not hasItem("Balance Badge")
end

function ToBalanceBadge:isDone()
	return hasItem("Balance Badge")
end

function ToBalanceBadge:LavaridgeTownGym1F()
	return moveToMap("Lavaridge Town")
end

function ToBalanceBadge:PokecenterLavaridgeTown()
	self:pokecenter("Lavaridge Town")
end

function ToBalanceBadge:LavaridgeTown()
	if isNpcOnCell(15,25) then
		return talkToNpcOnCell(15,25)
	elseif self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Lavaridge Town" then
		return moveToMap("Pokecenter Lavaridge Town")
	else
		return moveToMap("Route 112")
	end
end

function ToBalanceBadge:Route112()
	if self:needPokecenter() then
	 	return moveToMap("Lavaridge Town")
	elseif not self:isTrainingOver() then
		return moveToMap("Cable Car Station 1")
	else
		return moveToMap("Route 111 South")
	end
end

function ToBalanceBadge:JaggedPass()
	if self:needPokecenter() or self:isTrainingOver() then
	 	return moveToMap("Route 112")
	else
		return moveToGrass()
	end
end

function ToBalanceBadge:CableCarStation1()
	return talkToNpcOnCell(10,6)
end

function ToBalanceBadge:CableCarStation2()
	return moveToMap("Mt. Chimney")
end

function ToBalanceBadge:MtChimney()
	return moveToMap("Jagged Pass")
end

function ToBalanceBadge:Route111South()
	if not self:isTrainingOver() then
		return moveToMap("Route 112")
	else
		return moveToMap("Mauville City Stop House 3")
	end
end

function ToBalanceBadge:MauvilleCityStopHouse3()
	if not self:isTrainingOver() then
		return moveToMap("Route 111 South")
	else
		return moveToMap("Mauville City")
	end
end

function ToBalanceBadge:MauvilleCity()
	if not self:isTrainingOver() then
		return moveToMap("Mauville City Stop House 3")
	else
		return moveToMap("Mauville City Stop House 2")
	end
end

function ToBalanceBadge:MauvilleCityStopHouse2()
	if not self:isTrainingOver() then
		return moveToMap("Mauville City")
	else
		return moveToMap("Route 117")
	end
end

function ToBalanceBadge:Route117()
	if not self:isTrainingOver() then
		return moveToMap("Mauville City Stop House 2")
	else
		return moveToMap("Verdanturf Town")
	end
end

function ToBalanceBadge:VerdanturfTown()
	if not self:isTrainingOver() then
		return moveToMap("Route 117")
	else
		return moveToMap("Rusturf Tunnel")
	end
end

function ToBalanceBadge:RusturfTunnel()
	if not self:isTrainingOver() then
		return moveToMap("Verdanturf Town")
	elseif game.tryTeachMove("Rock Smash", "TM114") then
		return moveToCell(11,19)
	end
end

function ToBalanceBadge:Route116()
	if not self:isTrainingOver() then
		return moveToMap("Rusturf Tunnel")
	else
		return moveToMap("Rustboro City")
	end
end

function ToBalanceBadge:RustboroCity()
	if not self:isTrainingOver() then
		return moveToMap("Route 116")
	else
		return moveToCell(37,65)
	end
end

function ToBalanceBadge:Route104()
	if game.inRectangle(7,0,41,67) then
		if not self:isTrainingOver() then
			return moveToMap("Rustboro City")
		else
			return moveToMap("Petalburg Woods")
		end
	else
		if not self:isTrainingOver() then
			return moveToMap("Petalburg Woods")
		else
			return moveToMap("Petalburg City")
		end
	end
end

function ToBalanceBadge:PetalburgWoods()
	if not self:isTrainingOver() then
		return moveToCell(23,0)
	else
		return moveToCell(24,60)
	end
end

function ToBalanceBadge:PetalburgCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Petalburg City" then
		return moveToMap("Pokecenter Petalburg City")
	elseif not self:isTrainingOver() then
		return moveToMap("Route 104")
	else
		return moveToMap("Petalburg City Gym")
	end
end

function ToBalanceBadge:PokecenterPetalburgCity()
	return self:pokecenter("Petalburg City")
end

function ToBalanceBadge:PetalburgCityGym()
	if dialogs.trainerDone.state == true then
		dialogs.trainerDone.state = false
		trainersBeaten = trainersBeaten + 1
	end

	if isNpcOnCell (73,104) then
		return talkToNpcOnCell(73,104)
	elseif game.inRectangle(68,101,79,109) then
		return moveToCell(77,100)
	elseif game.inRectangle(36,82,47,90) and (trainersBeaten < 1)  and not game.inRectangle(42,86,42,86)  then
		return moveToCell(42,86)
	elseif game.inRectangle(36,82,47,90) and (trainersBeaten < 1) and game.inRectangle(42,86,42,86)  then
		return talkToNpcOnCell(41,86)
	elseif game.inRectangle(36,82,47,90) then
		return moveToCell(38,81)
	elseif game.inRectangle(35,55,46,63) and (trainersBeaten < 2) and not game.inRectangle(41,58,41,58)  then
		return moveToCell(41,58)
	elseif game.inRectangle(35,55,46,63) and not (trainersBeaten < 2) and game.inRectangle(41,58,41,58)  then
		trainersBeaten = 1
		return talkToNpcOnCell(40,58)
	elseif game.inRectangle(35,55,46,63) then
		return moveToCell(44,54)
	elseif game.inRectangle(35,28,46,36) and (trainersBeaten < 3) and not game.inRectangle(41,31,41,31)  then
		return moveToCell(41,31)
	elseif game.inRectangle(35,28,46,36) and (trainersBeaten < 3) and game.inRectangle(41,31,41,31)  then
		trainersBeaten = 2
		return talkToNpcOnCell(40,31)
	elseif game.inRectangle(35,28,46,36) then
		return moveToCell(37,27)
	elseif game.inRectangle(18,4,29,11) then
		return talkToNpcOnCell(23,4)
	end
end

return ToBalanceBadge