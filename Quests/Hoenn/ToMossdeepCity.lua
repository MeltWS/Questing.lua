-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @WiWi__33[NetPapa]


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'ToMossdeepCity'
local description = 'Go to Mossdeep City, clear the Gym.'
local level = 60
local shelly = false

local dialogs = {
	aquaHideoutOver = Dialog:new({ 
		"Route 128"
	}),
	gymLeader1 = Dialog:new({ 
		"My name is Liza",
		"He is inside this Gym"
	})
}

local ToMossdeepCity = Quest:new()

function ToMossdeepCity:new()
	return Quest.new(ToMossdeepCity, name, description, level, dialogs)
end

function ToMossdeepCity:isDoable()
	return self:hasMap() and not hasItem("Red orb") and not hasItem("Mind Badge")
end

function ToMossdeepCity:isDone()
	return hasItem("Mind Badge")
end
function ToMossdeepCity:MagmaHideout4F()
	return moveToMap("Magma Hideout 3F3R")
end

function ToMossdeepCity:MagmaHideout3F3R()
	return moveToMap("Magma Hideout 2F3R")
end

function ToMossdeepCity:MagmaHideout2F3R()
	return moveToMap("Magma Hideout 1F")
end

function ToMossdeepCity:MagmaHideout1F()
	return moveToMap("Jagged Pass")
end

function ToMossdeepCity:JaggedPass()
	return moveToMap("Route 112")
end

function ToMossdeepCity:Route112()
	return moveToMap("Route 111 South")
end

function ToMossdeepCity:Route111South()
	return moveToMap("Mauville City Stop House 3")
end


function ToMossdeepCity:MauvilleCityStopHouse3()
	return moveToMap("Mauville City")
end

function ToMossdeepCity:MauvilleCity()
	return moveToMap("Mauville City Stop House 4")
end


function ToMossdeepCity:MauvilleCityStopHouse4()
	return moveToMap("Route 118")
end

function ToMossdeepCity:Route118()
	return moveToMap("Route 119B")
end


function ToMossdeepCity:Route119B()
	return moveToMap("Route 119A")
end

function ToMossdeepCity:Route119A()
	return moveToMap("Fortree City")
end

function ToMossdeepCity:FortreeCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Fortree City" then
		return moveToMap("Pokecenter Fortree City")
	else
		return moveToMap("Route 120")
	end
end

function ToMossdeepCity:PokecenterFortreeCity()
	self:pokecenter("Fortree City")
end

function ToMossdeepCity:Route120()
	return moveToMap("Route 121")
end

function ToMossdeepCity:Route121()
	return moveToMap("Lilycove City")
end

function ToMossdeepCity:LilycoveCity()
	if isNpcOnCell(3,23) then
		return talkToNpcOnCell(3,23)
	elseif self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Lilycove City" then
		return moveToMap("Pokecenter Lilycove City")
	elseif not dialogs.aquaHideoutOver.state then
		return moveToMap("Team Aqua Hideout  Entrance")
	else
		return moveToMap("Route 124")
	end
end


function ToMossdeepCity:PokecenterLilycoveCity()
	return self:pokecenter("Lilycove City")
end

function ToMossdeepCity:TeamAquaHideoutEntrance()
	return moveToMap("Team Aqua Hideout 1F")
end


function ToMossdeepCity:TeamAquaHideout1F()
	if game.inRectangle(38,25,42,45) or game.inRectangle(37,26,60,31) or game.inRectangle(55,4,60,31) then
		return moveToCell(58,5)
	elseif game.inRectangle(7,20,26,31) and isNpcOnCell(17,20) then
		return talkToNpcOnCell(17,20)
	else
		return moveToCell(11,22)
	end
end

function ToMossdeepCity:TeamAquaHideoutB1F()
	if game.inRectangle(2,26,40,30) and isNpcOnCell(38,18) then
		return moveToCell(3,29)
	elseif game.inRectangle(2,26,40,30) and not isNpcOnCell(38,18) then
		shelly = true
		return moveToCell(3,29)
	elseif game.inRectangle(35,3,38,9) then
		return moveToCell(35,8)
	elseif game.inRectangle(33,13,40,22) and isNpcOnCell(38,18) then
		return talkToNpcOnCell(38,18)
	elseif game.inRectangle(33,13,40,22) and not isNpcOnCell(38,18) then
		shelly = true
		return moveToCell(35,20)
	end
end



function ToMossdeepCity:TeamAquaHideoutWarpHallway()
	if game.inRectangle(12,32,36,32) then 
		return moveToCell(19,32)
	elseif game.inRectangle(12,32,36,32) and not shelly then
		return moveToCell(19,32)
	elseif game.inRectangle(12,32,36,32) and shelly then
		return moveToCell(24,32)
	elseif game.inRectangle(12,17,36,17) and not shelly then
		return moveToCell(19,17)
	elseif game.inRectangle(12,17,36,17) and shelly then
		return moveToCell(24,17)
	elseif game.inRectangle(12,24,36,24) and not shelly then
		return moveToCell(14,24)
	elseif game.inRectangle(12,24,36,24) and shelly then
		return moveToCell(19,24)
	elseif game.inRectangle(23,39,40,47) and not shelly then 
		return moveToCell(24,41)
	elseif game.inRectangle(23,39,40,47) and shelly then 
		return moveToCell(39,42)
	elseif game.inRectangle(12,5,24,11) then
		return moveToCell(19,5)
	end	
end

function ToMossdeepCity:TeamAquaHideoutB2F()
	if game.inRectangle(7,3,14,11) and not shelly then 
		return moveToCell(12,4)
	elseif game.inRectangle(7,3,14,11) and  shelly then 
		return moveToCell(9,10)
	elseif game.inRectangle(21,3,40,19) then
		return moveToCell(23,17)
	elseif game.inRectangle(29,24,40,35) and not isNpcOnCell(31,30) then
		return talkToNpcOnCell(28,30)
	else
		return talkToNpcOnCell(31,30)
	end
end

function ToMossdeepCity:Route124()
	return moveToMap("Mossdeep City")
end

function ToMossdeepCity:MossdeepCity()
	if isNpcOnCell(36,22) then
		return talkToNpcOnCell(36,22)
	elseif self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Mossdeep City" then
		return moveToMap("Pokecenter Mossdeep City")
	elseif not self:isTrainingOver() then
		return moveToRectangle(4,8,12,19)
	else
		return moveToMap("Mossdeep Gym")
	end
end

function ToMossdeepCity:MossdeepGym()
	if game.inRectangle(4,52,18,67) then
		return moveToCell(5,52)
	elseif game.inRectangle(51,48,58,65) then
		return moveToCell(54,65)
	elseif game.inRectangle(6,3,18,11) and not dialogs.gymLeader1.state then 
		return talkToNpcOnCell(18,6)
	elseif game.inRectangle(6,3,18,11) and dialogs.gymLeader1.state then 
		return moveToCell(7,3)
	elseif game.inRectangle(4,27,16,34) then
		return moveToCell(10,34)
	elseif game.inRectangle(47,6,56,12) then
		return talkToNpcOnCell(52,8)
	elseif game.inRectangle(47,6,56,12) then 
		return moveToCell(56,6)
	elseif game.inRectangle(29,59,35,68) then 
		return moveToCell(29,60)
	end
end

function ToMossdeepCity:PokecenterMossdeepCity()
	return self:pokecenter("Mossdeep City")
end





return ToMossdeepCity