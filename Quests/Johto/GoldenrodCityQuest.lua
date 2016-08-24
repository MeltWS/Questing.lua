-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex @Melt

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Goldenrod City'
local description = " Complete Guard's Quest"
local level = 20

local dialogs = {
	guardQuestPart1 = Dialog:new({ 
		"any information on his whereabouts"
	}),
	directorQuestPart1 = Dialog:new({ 
		"there is nothing to see here"
	}),
	guardQuestPart2 = Dialog:new({ 
		"where did you find him",
		"he might be able to help"
	}),
	guardElevatorB1F = Dialog:new({
		"Which floor would you like to go to?",
		"You have arrived on the Underground"
	}),
	guardElevator6F = Dialog:new({
		"You have arrived on the sixth floor.",
	}),
	guardSleepingPart2 = Dialog:new({ 
		"Ugh, where is this store's manager? He usually delivers a drink at this juncture, and I am parched!",
		"Zzz-zzzzz-zzzzz....."
	}),
	UndergroundWarehouseStart = Dialog:new({ -- unused for now, can be used to walk to (15,10) and trigger the crate event the first time if needed.
		"And Team Rocket agents are patrolling around the area...",
	}),
	UndergroundWarehouseFinish = Dialog:new({ 
		"Now to see what is stored beyond these doors",
	}),
	LeverA = Dialog:new({
		"This lever controls doors 1 and 6; do you want to proceed?"
	}),
	LeverB = Dialog:new({
		"This lever controls doors 5 and 7; do you want to proceed?"
	}),
	LeverC = Dialog:new({
		"This lever controls doors 1 and 4; do you want to proceed?"
	}),
	LeverD = Dialog:new({
		"This lever controls doors 2 and 5; do you want to proceed?"
	}),
	LeverE = Dialog:new({
		"This lever controls doors 6 and 8; do you want to proceed?"
	}),
	LeverF = Dialog:new({
		"This lever controls doors 2 and 3; do you want to proceed?"
	}),
	UndergroundDefeated = Dialog:new({
		"You just told your listenership all they need to know about your culpability..."
	}),
}

local LeversOrder = {"A","C","D","C","B","C","D","E","F","BOSS", ["Current"] = 1}

local UndergroundCratesNPC = {
	["Current"] = 1,
	{27,11},
	{26,11},
	{26,11},
	{26,12},
	{26,12},
	{27,12},
	{23,13},
	{23,13},
	{20,8},
	{20,8},
	{20,7},
	{18,10},
	{18,9},
	{18,9},
	{17,9},
	{17,9},
	{17,10},
	{15,12},
	{15,12},
	{15,13},
	{15,13},
	{17,15},
	{17,16},
	{17,16},
	{18,16},
	{19,16},
	{19,16},
	{20,15},-- super potion blocking the way
	{19,15},
	{24,14},
	{25,14},
	{26,14},
	{25,15},
	{26,16},
	{26,16},
	{26,17},
	{26,18},
	{26,18},
	{25,18},
	{25,18},
	{24,17},
	{24,17},
	{24,16},
	{24,15},
	{24,14},
	{23,13},
	{26,22},
	{26,22},
	{25,23},
	{24,23},
	{23,22},
	{23,22},
	{22,22},-- maxpotion on the way
	{23,22},
	{22,23},
	{21,23},
	{20,22},
	{20,22},
	{20,22},
	{20,23},
	{20,24},
	{16,21},
	{16,22},
	{16,22},
	{15,22},
	{15,22},
	{15,21},
	{12,24},
	{12,23},
	{12,22},
	{12,22},
	{11,22},
	{11,13},
	{11,13},
	{11,13},
	{11,10},
	{11,10},
	{11,9},
	{11,9},
	{6,8},
	{7,8},
	{7.8},
	{7,9},
	{7,10},
	{7,10},
	{6,10},
	{6,10},
	{6,9},
	{6,8},
	{5,14},
	{6,13},
	{6,12},
	{6,12},
	{7,12},
	{7,12},
	{7,13},
	{7,13},
	{6,14},
	{6,14},
	{5,15},
	{5,15},
	{4,17},
	{3,17},
	{2,16}
}

local UndergroundCratesPos = {
	{27,10},
	{26,10},
	{25,11},
	{25,12},
	{26,13},
	{27,13},
	{24,13},
	{23,12},
	{20,9},
	{19,8},
	{19,7},
	{19,10},
	{19,9},
	{18,8},
	{17,8},
	{16,9},
	{16,10},
	{15,11},
	{16,12},
	{16,13},
	{15,14},
	{16,15},
	{16,16},
	{17,17},
	{18,17},
	{19,17},
	{20,16},
	{20,16},-- super potion blocking the way
	{20,15},
	{24,13},
	{25,13},
	{26,14},
	{26,15},
	{26,15},
	{27,16},
	{27,17},
	{27,18},
	{26,19},
	{25,19},
	{24,18},
	{24,18},
	{23,17},
	{23,16},
	{23,15},
	{23,14},
	{23,14},
	{26,21},
	{25,22},
	{25,22},
	{24,22},
	{24,22},
	{23,21},
	{22,21}, -- pick up item
	{22,22}, 
	{22,22},
	{21,22},
	{21,22},
	{20,21},
	{19,22},
	{19,23},
	{19,24},
	{17,21},
	{17,22},
	{16,23},
	{15,23},
	{14,22},
	{14,21},
	{13,24},
	{13,23},
	{13,22},
	{12,21},
	{11,21},
	{11,14},
	{12,13},
	{11,12},
	{11,11},
	{12,10},
	{12,9},
	{11,8},
	{6,7},
	{7,7},
	{8,8},
	{8,9},
	{8,10},
	{7,11},
	{6,77},
	{5,10},
	{5,9},
	{5,8},
	{5,13},
	{5,13},
	{5,12},
	{6,11},
	{7,11},
	{8,12},
	{8,13},
	{7,14},
	{7,14},
	{6,15},
	{6,15},
	{5,16},
	{4,16},
	{3,16},
	{3,16}
}

local GoldenrodCityQuest = Quest:new()

function GoldenrodCityQuest:new()
	return Quest.new(GoldenrodCityQuest, name, description, level, dialogs)
end

function GoldenrodCityQuest:isDoable()
	if self:hasMap() then
		if getMapName() == "Goldenrod City" then 
			return isNpcOnCell(48,34)
		else
			return true
		end
	end
	return false
end

function GoldenrodCityQuest:isDone()
	if getMapName() == "Goldenrod City" and not isNpcOnCell(48,34) then
		return true
	else
		return false
	end
end

function GoldenrodCityQuest:PokecenterGoldenrod()
	if hasItem("Basement Key") and not (hasPokemonInTeam("Oddish") or hasPokemonInTeam("Bellsprout")) and not hasItem("spruzzino") and dialogs.guardQuestPart2.state and not dialogs.guardQuestPart3.state then
		fatal("Need Wait FIX for ProShine API [ usePC() ] -  No other quests for now")
	else
		self:pokecenter("Goldenrod City")
	end	
end

function GoldenrodCityQuest:GoldenrodCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Goldenrod" then
		return moveToMap("Pokecenter Goldenrod")
	elseif hasItem("Bike Voucher") then
		return moveToMap("Goldenrod City Bike Shop")
	elseif hasItem("Basement Key") and not hasItem("spruzzino") and dialogs.guardQuestPart2.state and not dialogs.guardQuestPart3.state then --get Oddish on PC and start leveling
		if hasPokemonInTeam("Oddish") or hasPokemonInTeam("Bellsprout") then
			if not game.hasPokemonWithMove("Sleep Powder") then
				return moveToMap("Route 34")
			else
				return moveToMap("Goldenrod Mart 1")
			end
		else
			return moveToMap("Pokecenter Goldenrod")
		end
	elseif isNpcOnCell(48,34) then
		if dialogs.guardQuestPart2.state then
			return moveToMap("Goldenrod City House 2")
		elseif dialogs.guardQuestPart1.state then
			return moveToMap("Goldenrod Underground Entrance Top")
		else
			pushDialogAnswer(2)
			return talkToNpcOnCell(48,34)
		end
	end
end

function GoldenrodCityQuest:GoldenrodCityBikeShop()
	if hasItem("Bike Voucher") then
		return talkToNpcOnCell(11,3)
	else
		return moveToMap("Goldenrod City")
	end
end

function GoldenrodCityQuest:GoldenrodUndergroundEntranceTop()
	if dialogs.UndergroundDefeated.state then
		return moveToMap("Goldenrod City")
	end
	 dialogs.guardQuestPart1.state = false
	if dialogs.directorQuestPart1.state then
		return moveToMap("Goldenrod City")
	else
		return moveToMap("Goldenrod Underground Path")
	end
	
end

function GoldenrodCityQuest:GoldenrodUndergroundPath()
	if isNpcOnCell(7,2) then
		return talkToNpcOnCell(7,2) --Item: TM-46   Psywave
	elseif dialogs.directorQuestPart1.state or dialogs.UndergroundDefeated.state then
		return moveToMap("Goldenrod Underground Entrance Top")
	else
		return talkToNpcOnCell(17,10)
	end
end

function GoldenrodCityQuest:GoldenrodCityHouse2()
	if not hasItem("Basement Key") then
		return talkToNpcOnCell(9,5)
	else
		return moveToMap("Goldenrod City")
	end
end

function GoldenrodCityQuest:Route34()
	if not self:isTrainingOver() or self:needPokecenter() then
		return moveToGrass()
	end
	return moveToMap("Goldenrod City")
end

function GoldenrodCityQuest:GoldenrodMart1()
	if hasItem("Basement Key") and game.hasPokemonWithMove("Sleep Powder") and not hasItem("spruzzino") and dialogs.guardQuestPart2.state and not dialogs.guardQuestPart3.state then
		return moveToMap("Goldenrod Mart Elevator")
	end
	return moveToMap("Goldenrod City")
end

function GoldenrodCityQuest:GoldenrodMartElevator()
	if not (hasItem("Fresh Water") and not dialogs.guardSleepingPart2.state) then
		if dialogs.guardElevator6F.state then			
			return moveToCell(3,6)
		else
			pushDialogAnswer(5)
			pushDialogAnswer(3)
		end
		return talkToNpcOnCell(1,6)
	elseif not dialogs.guardElevatorB1F.state then
		pushDialogAnswer(1)
		return talkToNpcOnCell(1,6)
    end
	return moveToCell(3,6)
end

function GoldenrodCityQuest:GoldenrodMart6()
	if not hasItem("Fresh Water") then
		if not isShopOpen() then
			return talkToNpcOnCell(12,3)
		else
			return buyItem("Fresh Water", 1)
		end
	else
		return moveToMap("Goldenrod Mart Elevator")
	end
end

function GoldenrodCityQuest:GoldenrodMartB1F()
	dialogs.guardElevatorB1F.state = false -- in case of black out
	if isNpcOnCell(13,8) then
		local sleepID
		for i=1,6 do
			if hasMove("Sleep Powder") then
				sleepID = i
			end
		end
		pushDialogAnswer(2)
		pushDialogAnswer(sleepID)
		talkToNpcOnCell(13,8)
		return
	end
	return moveToMap("Underground Warehouse")	
end

function GoldenrodCityQuest:UndergroundWarehouse()
	local current = UndergroundCratesNPC["Current"]
	if dialogs.UndergroundWarehouseFinish.state then
		return moveToMap("Goldenrod Underground Basement")
	else 
		local NPCx = UndergroundCratesNPC[current][1]
		local NPCy = UndergroundCratesNPC[current][2]
		if isNpcOnCell(NPCx, NPCy) then
			local locX = UndergroundCratesPos[current][1]
			local locY = UndergroundCratesPos[current][2]
			if not (getPlayerX() == locX) and (getPlayerY() == locY) then
				return moveToCell(locX,locY)
			end
			talkToNpcOnCell(NPCx, NPCy)
		end
		if (current < 104) then
			UndergroundCratesNPC["Current"] = current + 1 -- max 70
		else
			fatal("Could not find enought pokemon in crates")
		end
	end
end

function GoldenrodCityQuest:GoldenrodUndergroundBasement() -- open full path in case of black out, will break if user dc or change script before opening the full path.TY
	local current = LeversOrder["Current"]
	if dialogs.LeverC.state and dialogs.LeverD.state and current < 4 then
		dialogs.LeverC.state = false
		LeversOrder["Current"] = 4
	elseif dialogs.LeverC.state and dialogs.LeverB.state and current < 6 then
		dialogs.LeverC.state = false
		LeversOrder["Current"] = 6 
	elseif dialogs.LeverD.state and dialogs.LeverB.state and current < 7 then
		dialogs.LeverD.state = false
		LeversOrder["Current"] = 7 
	end
	if dialogs.UndergroundDefeated.state then
		return moveToMap("Goldenrod Underground Path")
	elseif not dialogs.LeverA.state then
		pushDialogAnswer(1)
		return talkToNpc("Lever A")
	elseif not dialogs.LeverC.state then
		pushDialogAnswer(1)
		return talkToNpc("Lever C")
	elseif not dialogs.LeverD.state then
		pushDialogAnswer(1)
		return talkToNpc("Lever D")
	elseif not dialogs.LeverB.state then
		pushDialogAnswer(1)
		return talkToNpc("Lever B")
	elseif not dialogs.LeverE.state then
		pushDialogAnswer(1)
		return talkToNpc("Lever E")				
	elseif not dialogs.LeverF.state then
		pushDialogAnswer(1)
		return talkToNpc("Lever F")		
	else
		talkToNpcOnCell(5,4)
	end
end
return GoldenrodCityQuest