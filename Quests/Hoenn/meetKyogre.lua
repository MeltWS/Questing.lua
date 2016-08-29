-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @WiWi__33[NetPapa]


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'meetKyogre'
local description = ' Learn Dive, dive to Seafloor Cavern and defeat admin Matt'
local level = 63
local diveID = nil 

local dialogs = {
	xxx = Dialog:new({ 
		" "
	})
}

local meetKyogre = Quest:new()

function meetKyogre:new()
	o = Quest.new(meetKyogre, name, description, level, dialogs)
	o.pokemonId = 1

	return o
end

function meetKyogre:isDoable()
	return self:hasMap() and  hasItem("Blue Orb") and hasItem("Mind Badge")
end

function meetKyogre:isDone()
	return not hasItem("Blue Orb")
end

function meetKyogre:MossdeepGym()
	if game.inRectangle(51,48,58,65) then
		return moveToCell(54,65)
	elseif game.inRectangle(6,3,18,11) then 
		return moveToCell(7,3)
	elseif game.inRectangle(4,27,16,34) then
		return moveToCell(10,34)
	elseif game.inRectangle(47,6,56,12) then 
		return moveToCell(56,6)
	elseif game.inRectangle(29,59,35,68) then 
		return moveToCell(29,60)
	elseif game.inRectangle(4,52,18,67) or game.inRectangle(2,60,20,67) then
		return moveToMap("Mossdeep City")
	end
end

function meetKyogre:MossdeepCity()
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Mossdeep City" then
		return moveToMap("Pokecenter Mossdeep City")
	elseif isNpcOnCell(83,22) then 
		return talkToNpcOnCell(83,22)
	elseif not hasItem("HM06 - Dive") then 
		return moveToMap("Mossdeep City Space Center 1F")
	elseif not self:isTrainingOver() then
		return moveToRectangle(4,8,12,19)
	elseif game.tryTeachMove("Dive", "HM06 - Dive") then
		return moveToMap("Route 127")
	end
end

function meetKyogre:MossdeepCitySpaceCenter1F()
	if not hasItem("HM06 - Dive") then
		return talkToNpcOnCell(12,6)
	else
		return moveToMap("Mossdeep City")
	end
end

function meetKyogre:PokecenterMossdeepCity()
	self:pokecenter("Mossdeep City")
end

function meetKyogre:Route127()
	if game.tryTeachMove("Dive", "HM06 - Dive") then
		for i=1, getTeamSize(), 1 do
			if hasMove(i, "Dive") then
				pushDialogAnswer(1)
				pushDialogAnswer(i)
				return moveToCell(37,25)
			end
		end
	end
end


function meetKyogre:Route127Underwater()
	return moveToMap("Route 128 Underwater")
end

function meetKyogre:Route128Underwater()
	return moveToMap("Secret Underwater Cavern")
end

function meetKyogre:SecretUnderwaterCavern()
	if game.tryTeachMove("Dive", "HM06 - Dive") then
		for i=1, 6, 1 do
			if hasMove(i, "Dive") then
				pushDialogAnswer(1)
				pushDialogAnswer(i)
				return moveToCell(8,6)
			end
		end
	end
end

function meetKyogre:SeafloorCavernEntrance()
	return moveToMap("Seafloor Cavern R1")
end

function meetKyogre:SeafloorCavernR1()
	return moveToMap("Seafloor Cavern R2")
end

function meetKyogre:SeafloorCavernR2()
	return moveToMap("Seafloor Cavern R3")
end

function meetKyogre:SeafloorCavernR3()
	return moveToMap("Seafloor Cavern R4")
end

function meetKyogre:SeafloorCavernR4()
	if game.tryTeachMove("Rock Smash", "TM114") then
		return moveToMap("Seafloor Cavern R6")
	end
end

function meetKyogre:SeafloorCavernR6()
	if game.inRectangle(4,19,4,19) then
		return moveToCell(5,19)
	elseif game.inRectangle(5,19,5,19) then
		return moveToCell(6,19)
	elseif game.inRectangle(6,19,6,19) then
		return moveToCell(7,19)
	elseif game.inRectangle(7,19,7,19) then
		return moveToCell(7,18)
	elseif game.inRectangle(7,18,7,18) then
		return moveToCell(8,18)
	elseif game.inRectangle(8,18,8,18) then
		return moveToCell(9,18)
	elseif game.inRectangle(9,18,9,18) then 
		return moveToCell(10,18)
	elseif game.inRectangle(11,18,14,18) then
		return moveToCell(15,18)
	elseif game.inRectangle(19,12,19,12) then
		return moveToCell(20,12)
	elseif game.inRectangle(19,8,19,8) then
		return moveToCell(19,7)
	elseif game.inRectangle(11,8,11,8) then
		return moveToCell(11,7)
	elseif game.inRectangle(3,3,8,7) then
		return moveToMap("Seafloor Cavern R7")
	end
end

function meetKyogre:SeafloorCavernR7()
	return moveToMap("Seafloor Cavern R8")
end

function meetKyogre:SeafloorCavernR8()
	return moveToMap("Seafloor Cavern R9")
end

function meetKyogre:SeafloorCavernR9()
	return talkToNpcOnCell(16,37)
end

return meetKyogre