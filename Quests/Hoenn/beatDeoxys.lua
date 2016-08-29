-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @WiWi__33[NetPapa] @Melt


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Beat Deoxys'
local description = 'Will earn the 8th Badge and beat Deoxys on the moon.'
local level = 80
local deoxys = false
local dialogs = {
	goSky = Dialog:new({ 
		"He is currently at Sky Pillar"
	}),
	firstChamp = Dialog:new({ 
		"He is somewhere in this Gym..."
	})
}

local beatDeoxys = Quest:new()

function beatDeoxys:new()
	return Quest.new(beatDeoxys, name, description, level, dialogs)
end

function beatDeoxys:isDoable()
	return self:hasMap() and not hasItem("Blue Orb") and not  hasItem("Rain Badge")
end

function beatDeoxys:isDone()
	return hasItem("Rain Badge") and getMapName() == "Sootopolis City Gym B1F"
end

function beatDeoxys:Route128()
	if not dialogs.goSky.state then 
		return moveToMap("Route 127")
	else
		return moveToMap("Route 129")
	end
end

function beatDeoxys:PokecenterMossdeepCity()
	self:pokecenter("Mossdeep City")
end

function beatDeoxys:MossdeepCity()
	return moveToMap("Route 127")
end

function beatDeoxys:Route127()
	if not dialogs.goSky.state then
		return moveToMap("Route 126")
	else
		return moveToMap("Route 128")
	end
end

function beatDeoxys:Route126()
	if not dialogs.goSky.state and game.tryTeachMove("Dive", "HM06 - Dive") then
		for i=1, getTeamSize(), 1 do
			if hasMove(i, "Dive") then
				pushDialogAnswer(1)
				pushDialogAnswer(i)
				return moveToCell(15,71)
			end
		end
	else
		return moveToMap("Route 127")
	end
end

function beatDeoxys:Route126Underwater()
	if isNpcOnCell(58,97) then 
		return talkToNpcOnCell(58,97)
	elseif not dialogs.goSky.state then 
		return moveToMap("Sootopolis City Underwater")
	elseif game.tryTeachMove("Dive", "HM06 - Dive") then
		for i=1, getTeamSize(), 1 do
			if hasMove(i, "Dive") then
				pushDialogAnswer(1)
				pushDialogAnswer(i)
				return moveToCell(15,71)
			end
		end
	end
end

function beatDeoxys:SootopolisCityUnderwater()
	if dialogs.goSky.state then 
		return moveToMap("Route 126 Underwater")
	elseif game.tryTeachMove("Dive", "HM06 - Dive") then
		for i=1, getTeamSize(), 1 do
			if hasMove(i, "Dive") then
				pushDialogAnswer(1)
				pushDialogAnswer(i)
				return moveToCell(17,11)
			end
		end
	end
end

function beatDeoxys:SootopolisCity()
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Sootopolis City" then
		return moveToMap("Pokecenter Sootopolis City")
	elseif isNpcOnCell(48,68) and not dialogs.goSky.state then 
		return talkToNpcOnCell(50,17)
	elseif dialogs.goSky.state and game.tryTeachMove("Dive", "HM06 - Dive") then
		for i=1, getTeamSize(), 1 do
			if hasMove(i, "Dive") then
				pushDialogAnswer(1)
				pushDialogAnswer(i)
				return moveToCell(50,91)
			end
		end
	elseif not isNpcOnCell(48,68) and not hasItem("Rain Badge") then
		return moveToMap("Sootopolis City Gym 1F")
	end
end

function beatDeoxys:Route129()
	return moveToMap("Route 130")
end

function beatDeoxys:Route130()
	return moveToMap("Route 131")
end

function beatDeoxys:Route131()
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Pacifidlog Town" then
		return moveToMap("Pacifidlog Town")
	else
		return moveToMap("Sky Pillar Entrance")
	end
end

function beatDeoxys:PacifidlogTown()
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Pacifidlog Town" then
		return moveToMap("Pokecenter Pacifidlog Town")
	else
		return moveToMap("Route 131")
	end
end

function beatDeoxys:SkyPillarEntrance()
	if not game.inRectangle(25,7,36,26) then
		if self:needPokecenter() then 
			return moveToMap("Route 131")
		else
			return moveToMap("Sky Pillar Entrance Cave 1F")
		end
	else 
		 if isNpcOnCell(27,7) then	
			return talkToNpcOnCell(27,7)
		 elseif self:needPokecenter() then
			return moveToMap("Sky Pillar Entrance Cave 1F")
		else
			return moveToMap("Sky Pillar 1F")
		 end
	end
		
end

function beatDeoxys:SkyPillar1F()
	if self:needPokecenter() then	
		return moveToMap("Sky Pillar Entrance")
	else
		-- return moveToRectangle(3,6,11,12)
		return moveToCell(13,5)
	end
end

function beatDeoxys:SkyPillarEntranceCave1F()
	if self:needPokecenter() then 
		return moveToCell(7,17)
	else
		return moveToCell(17,6)
	end
end

function beatDeoxys:PacifidlogTown()
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Pacifidlog Town" then
		return moveToMap("Pokecenter Pacifidlog Town")
	else
		return moveToMap("Route 131")
	end
end


function beatDeoxys:PokecenterPacifidlogTown()
	return self:pokecenter("Pacifidlog Town")
end


function beatDeoxys:PokecenterSootopolisCity()
	return self:pokecenter("Sootopolis City")
end


function beatDeoxys:SkyPillar2F()
	if self:needPokecenter() then	
		return moveToMap("Sky Pillar 1F")
	else
		return moveToCell(7,5)
	end
end

function beatDeoxys:SkyPillar3F()
	if self:needPokecenter() then	
		return moveToMap("Sky Pillar 2F")
	else
		return moveToCell(4,12)
	end
end

function beatDeoxys:SkyPillar4F()
	if self:needPokecenter() then
		return moveToMap("Sky Pillar 3F")
	else
		return moveToCell(8,12)
	end
end

function beatDeoxys:SkyPillar5F()
	if self:needPokecenter() then
		return moveToMap("Sky Pillar 4F")
	if not self:isTrainingOver() then
		moveToRectangle(2,5,12,5)
	else
		return moveToCell(13,12)
	end
end

function beatDeoxys:SkyPillar6F()
	if self:needPokecenter() then
		return moveToMap("Sky Pillar 5F")
	else
		return talkToNpcOnCell(25,19)
	end
end

function beatDeoxys:Moon()
	if game.inRectangle(25,48,8,33) then
		return moveToCell(7,40)
	elseif game.inRectangle(8,31,26,11) then
		return moveToCell(15,10)
	elseif game.inRectangle(39,11,52,41) and deoxys then
		return moveToCell(53,19)
	elseif game.inRectangle(39,11,52,41) and not deoxys then
		return moveToCell(53,40)
	elseif isNpcOnCell(30,28) then
		return talkToNpcOnCell(30,28)
	else deoxys = true
		return moveToMap("Moon 2F")
		
	end
end

function beatDeoxys:Moon1F()
	if game.inRectangle(4,24,9,45) or game.inRectangle(3,31,11,33)  then
		return moveToCell(8,24)
	elseif game.inRectangle(16,4,47,14) then
		return moveToCell(47,15)
	elseif game.inRectangle(57,43,61,47) then
		return moveToCell(59,45)
	elseif game.inRectangle(5,3,8,3) then
		return moveToCell(6,8)
	elseif game.inRectangle(57,23,61,25) then
		return moveToCell(59,23)
	end
end

function beatDeoxys:MoonB1F()
	if game.inRectangle(55,15,60,23) then
		dialogs.goSky.state = false
		return talkToNpcOnCell(60,23)
	elseif not deoxys then
		return moveToCell(32,19)
	else
		return moveToCell(5,32)
	end
end

function beatDeoxys:Moon2F()
	if not deoxys then
		if game.inRectangle(6,3,6,3) then 
			return moveToCell(5,3)
		elseif game.inRectangle(5,3,5,3) then 
			return moveToCell(5,4)
		elseif game.inRectangle(5,4,5,4) then 
			return moveToCell(5,5)
		else
			return moveToMap("Moon")
		end
	else
		return moveToCell(6,4)
	end
end

function beatDeoxys:SootopolisCityGym1F()
	if game.inRectangle(22,38,22,38)  then
		return moveToCell(22,47)
	elseif game.inRectangle(21,38,23,47) then
		return moveToCell(22,38)
	elseif game.inRectangle(22,38,22,38)  then
		return moveToCell(22,47)
	elseif game.inRectangle(19,27,25,34) then
		return moveToCell(22,29)
	elseif game.inRectangle(17,5,25,23) and not dialogs.firstChamp.state then
		return talkToNpcOnCell(22,6)
	elseif game.inRectangle(17,4,27,16) and dialogs.firstChamp.state then
		return moveToCell(22,17)
	end
end

function beatDeoxys:SootopolisCityGymB1F()
	if game.inRectangle(10,34,15,42) then
		return moveToCell(13,34)
	elseif game.inRectangle(13,21,22,28) then
		return moveToCell(13,21)
	elseif game.inRectangle(10,5,16,14) then
		return talkToNpcOnCell(13,6)
	end
end

function beatDeoxys:isCustomBattle()
	return getOpponentName() == "Deoxys" and game.hasPokemonWithMove("Sucker Punch")
end

function beatDeoxys:customBattle() -- Custom battle for deoxys using Sucker Punch
	log("CUSTOM BATTLE")
	local ppItem = hasItem("Elexir") or hasItem("Max Elexir") or nil
	local sweepMove = "Sucker Punch"
	local active = getActivePokemonNumber()
	local sweeper = game.getPokemonNumberWithMove(sweepMove)
	local sweepMovePP = getRemainingPowerPoints(sweeper, sweepMove)
	local activeHP = getPokemonHealth(active)
	local sweeperHP = getPokemonHealth(sweeper)


	if activeHP == 0 then
		if active == sweeper then
			log("active sweeper fainted, sending anyone")
			return sendAnyPokemon()
		elseif sweepMovePP > 0 and sweeperHP > 0 then
			log("active fainted, sweeper ready, attempting to send sweeper")
			return sendPokemon(sweeper)
		else -- Attempt to switch on any Pokemon alive expet sweeper.
			for i=1, getTeamSize(), 1 do
				if getPokemonHealth(i) > 0 and i ~= sweeper then
					if sendPokemon(i) then
						return true
					end
				end	
			end
			log("Switching to " .. sweeper .. " as it is the last Pokemon alive.") 
		end
	elseif active == sweeper then
		log("active is sweeper, sending attack request, using priority for move : " .. sweepMove)
		return useMove(sweepMove) or attack() or game.useAnyMove()
	else -- active pokemon alive
		log("active alive and not sweeper")
		if sweepMovePP == 0 then
			if not ppItem then
				log(sweepMove .. " has no more PP and no items available to refill.")
				return attack() or game.useAnyMove()
			else -- refill PP
				log("attempting to refill PP") -- Need API function to handle 2step use Item
				return useItemOnPokemon(ppItem, sweeper)
			end
		elseif sweeperHP == 0 then
			log("attempting to revive sweeper")
			if useItemOnPokemon("Revive", sweeper) then
				return true
			else
				log("No Revive for pokemon : " .. sweeper)
				return attack() or game.useAnyMove()				
			end
		else -- if sweeper is ready and pokemon active is not fainted
			return attack() or game.useAnyMove()
		end
	end
end

return beatDeoxys