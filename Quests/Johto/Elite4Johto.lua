-- Copyright � 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @WiWi__33[NetPaPa] @Melt


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Elite 4 johto'
local description = 'Tain Rattata, beat Elite Johto 4 and Joey'
local level = 80
local teamManaged = false

local dialogs = {
	leagueDefeated = Dialog:new({ 
		"I am already the Champ, don't need to go in there..."
	}),
	will = Dialog:new({ 
		"xxx"
	}),
	koga = Dialog:new({ 
		"xxx"
	}),
	karen = Dialog:new({ 
		"Good luck on facing"
	}),
	bruno = Dialog:new({ 
		"xxx"
	}),
	champ = Dialog:new({ 
		"Go, your destiny waits you!"
	})
}

local Elite4Johto = Quest:new()

function Elite4Johto:new()
	local o = Quest.new(Elite4Johto, name, description, level, dialogs)
	o.pokemon = "Rattata"
	o.forceCaught = false
	o.qnt_revive = 32
	o.qnt_hyperpot = 32
	return o
	
end

function Elite4Johto:PokecenterBlackthorn()
	self:pokecenter("Blackthorn City")
	--if not teamManaged then
		-- TManager.manage() -- Get e4 team ready from PC
	--end
end

function Elite4Johto:isDoable()
	if self:hasMap() and not hasItem("Stone Badge") then
		return true
	end
	return false
end

function Elite4Johto:isDone()
	return getMapName() == "Littleroot Town Truck"
end

function Elite4Johto:BlackthornCityGym()
	moveToCell(22,115)
end

function Elite4Johto:BlackthornCity()
	if game.isTeamFullyHealed() or not self.registeredPokecenter == "Pokecenter Blackthorn City" then
		return moveToMap("Pokecenter Blackthorn")
	else 
		return moveToMap("Route 45")
	end
end

function Elite4Johto:Route45()
	return moveToMap("Route 46")
end

function Elite4Johto:Route46()
	return moveToMap("Route 29 Stop House")
end

function Elite4Johto:Route29StopHouse()
	return moveToMap("Route 29")
end

function Elite4Johto:Route29()
	return moveToMap("New Bark Town")
end

function Elite4Johto:NewBarkTown()
	return moveToMap("Route 27")
end

function Elite4Johto:NewBarkTownPlayerHouseBedroom()
	dialogs.leagueDefeated.state = true
	if hasItem("Escape Rope") then
		return useItem("Escape Rope") -- tp Back to indigo plateau center
	else
		return moveToMap("New Bark Town Player House")
	end
end

function Elite4Johto:NewBarkTownPlayerHouse()
	return moveToMap("New Bark Town")
end

function Elite4Johto:Route27()
	if game.inRectangle(0,0,62,28) then 
		return moveToMap("Tohjo Falls")
	else 
		return moveToMap("Route 26")
	end
end

function Elite4Johto:TohjoFalls()
	return moveToCell(46,32)
end

function Elite4Johto:Route26()
	return moveToMap("Pokemon League Reception Gate")
end

function Elite4Johto:PokemonLeagueReceptionGate()
	if checkRattata() then
		 return moveToMap("Victory Road Kanto 1F")
	else
		 return moveToMap("Route 22")
	end		
end

function Elite4Johto:Route22()
	if checkRattata() then 
		return moveToMap("Pokemon League Reception Gate")
	else 
		return moveToMap("Viridian City")
	end
end

function Elite4Johto:ViridianCity()
	if checkRattata() then 
		return moveToMap("Route 22")
	else 
		return moveToMap("Route 1 Stop House")
	end
end

function Elite4Johto:Route1StopHouse()
	if checkRattata() then 
		return moveToMap("Viridian City")
	else 
		return moveToMap("Route 1")
	end
end

function Elite4Johto:Route1()
	if checkRattata() then 
		return moveToMap("Route 1 Stop House")
	else
		return moveToMap("Pallet Town")
	end
end

function Elite4Johto:PalletTown()
	if checkRattata() then 
		return moveToMap("Route 1")
	else
		return moveToMap("Route 21")
	end
end

function Elite4Johto:Route21()
	if checkRattata() then 
		return moveToMap("Pallet Town")
	else
		return moveToMap("Cinnabar Island")
	end
end

function Elite4Johto:CinnabarIsland()
	if checkRattata() then 
		return moveToMap("Route 21")
	elseif hasPokemonInTeam("Rattata") then
		return moveToMap("Route 20")
	elseif self:needPokecenter() or not self.registeredPokecenter == "Pokecenter Cinnabar Island"
		or (self.forceCaught and not hasPokemonInTeam("Rattata")) then
		return moveToMap("Pokecenter Cinnabar")
	elseif self:needPokemart() and not (getItemQuantity("Great Ball") > 9)then
		return moveToMap("Cinnabar Pokemart")
	else
		return moveToMap("Cinnabar mansion 1")
	end
end

function Elite4Johto:Cinnabarmansion1()
	if self:needPokecenter() or self.forceCaught 
	or self:needPokemart() and not (getItemQuantity("Great Ball") > 9) then
		return moveToMap("Cinnabar Island")
	else
		return moveToRectangle(3,16,18,37)
	end
end

function Elite4Johto:CinnabarPokemart()
	local greatBallCount = getItemQuantity("Great Ball")
	local money         = getMoney()
	if money >= 600 and greatBallCount < 10 then
		if not isShopOpen() then
			return talkToNpcOnCell(3,5)
		else
			local greatBallToBuy = 10 - greatBallCount
			local maximumBuyableGreatBalls = money / 600
			if maximumBuyableGreatBalls < greatBallToBuy then
				greatBallToBuy = maximumBuyableGreatBalls
			end
			return buyItem("Great Ball", greatBallToBuy)
		end
	else
		return moveToMap("Cinnabar Island")
	end
end

function Elite4Johto:PokecenterCinnabar()
	self:pokecenter("Cinnabar Island")
	if self.forceCaught and not hasPokemonInTeam("Rattata") then
		fatal("Need PC Lib Fix")-- get Rattata in PC
	end
end

function Elite4Johto:Cinnabarmansion2()
	return moveToMap("Cinnabar mansion 1")
end

function Elite4Johto:Route20()
	if not self:isTrainingOver() then
		return moveToCell(73,40) --Seafoam 1F
	else
		return moveToMap("Cinnabar Island")
	end
end

function Elite4Johto:Seafoam1F()
	if not self:isTrainingOver() then
		return moveToCell(64,8) --Seafoam B1F
	else
		return moveToMap("Route 20")
	end
end

function Elite4Johto:SeafoamB1F()
	if not self:isTrainingOver() then
		return moveToCell(64,25) --Seafoam B2F
	else
		return moveToCell(85,22)
	end
end

function Elite4Johto:SeafoamB2F()
	if not self:isTrainingOver() then
		return moveToCell(63,19) --Seafoam B3F
	else
		return moveToCell(51,27)
	end
end
function Elite4Johto:SeafoamB3F()
	if not self:isTrainingOver() then
		return moveToCell(57,26) --Seafoam B4F
	else
		return moveToCell(64,16)
	end
end

function Elite4Johto:SeafoamB4F()
	if self:isTrainingOver() then
		return moveToCell(53,28)
	elseif self:needPokecenter() and self:canUseNurse() then -- if have 1500 money
		return talkToNpcOnCell(59,13)
	elseif getUsablePokemonCount() then
	    return moveToRectangle(50,10,62,32)			
	else
		fatal("don't have enough Pokemons for farm 1500 money and heal the team")
	end
end

function Elite4Johto:canUseNurse()
	return getMoney() > 1500
end

function Elite4Johto:VictoryRoadKanto1F()
	return moveToMap("Victory Road Kanto 2F")
end

function Elite4Johto:VictoryRoadKanto2F()
	return moveToCell(14,9) 
end

function Elite4Johto:VictoryRoadKanto3F()
	return moveToMap("Indigo Plateau")
end

function Elite4Johto:IndigoPlateau()
	if isNpcOnCell(10,13) then
		talkToNpcOnCell(10,13)
	elseif not dialogs.leagueDefeated.state then
		return moveToMap("Indigo Plateau Center Johto")
	elseif dialogs.leagueDefeated.state and isNpcOnCell(21,10) then -- Joey
		return talkToNpcOnCell(21,10) -- Joey
	else
		return talkToNpcOnCell(7,21)
	end
end

function Elite4Johto:IndigoPlateauCenterJohto()
	self.registeredPokecenter = "Indigo Plateau Center Johto"
	if self:needPokecenter() or not game.isTeamFullyHealed() then
		return talkToNpcOnCell(4,22)
	elseif leagueDefeated then
		return moveToMap("Indigo Plateau")
	elseif (getMoney() > 1500) and (getItemQuantity("Revive") < self.qnt_revive or getItemQuantity("Hyper Potion") < self.qnt_hyperpot) then
		if not isShopOpen() then	
			return talkToNpcOnCell(16,22)
		else
			if getItemQuantity("Revive") < self.qnt_revive then
				return buyItem("Revive", (self.qnt_revive - getItemQuantity("Revive")))
			end
			if getItemQuantity("Hyper Potion") < self.qnt_hyperpot then
				return buyItem("Hyper Potion", (self.qnt_hyperpot - getItemQuantity("Hyper Potion")))
			end
		end
	else
		return moveToCell(10,3)
	end
end

function Elite4Johto:EliteFourWillRoom()
	if self:useReviveItems() ~= false then
		return
	elseif not dialogs.will.state then	
		if not game.inRectangle(6,13) then
			return moveToCell(6,13)
		else 
			dialogs.will.state = true
			return talkToNpcOnCell(6,12) 
		end
	else
		return moveToCell(6,3)
	end
end

function Elite4Johto:EliteFourKogaRoom()
	if self:useReviveItems() ~= false then
		return
	elseif not dialogs.koga.state then
		if not not game.inRectangle(20,25) then
			return moveToCell(20,25)
		else
			dialogs.koga.state = true 
			return talkToNpcOnCell(20,24) 
		end
	else
		return moveToCell(20,12)
	end
end

function Elite4Johto:EliteFourBrunoRoomJohto()
	if self:useReviveItems() ~= false then
		return
	elseif not dialogs.bruno.state then
		if not game.inRectangle(22,25) then	
			return moveToCell(22,25)
		else
			dialogs.bruno.state = true
			return talkToNpcOnCell(22,24) 
		end
	else
		return moveToCell(21,14)
	end
end


function Elite4Johto:EliteFourKarenRoomJohto()
	if self:useReviveItems() ~= false then
		return
	elseif not dialogs.karen.state then
		return talkToNpcOnCell(6,14) 
	else
		return moveToCell(6,3)
	end
end

function Elite4Johto:EliteFourChampionRoomJohto()
	if self:useReviveItems() ~= false then
		return
	elseif not dialogs.champ.state then
		return talkToNpcOnCell(6,15) 
	else
		return talkToNpcOnCell(6,4)
	end
end

function checkRattata()
    if getPokemonName(1) == "Rattata" and getPokemonLevel(1) >= 80
    or getPokemonName(2) == "Rattata" and getPokemonLevel(2) >= 80
    or getPokemonName(3) == "Rattata" and getPokemonLevel(3) >= 80
    or getPokemonName(4) == "Rattata" and getPokemonLevel(4) >= 80
    or getPokemonName(5) == "Rattata" and getPokemonLevel(5) >= 80
    or getPokemonName(6) == "Rattata" and getPokemonLevel(6) >= 80 then
        return true
    end
    return false
end

return Elite4Johto