local FilterValues = {
	["personal-filter-mk1"] = 100,
	["personal-filter-mk2"] = 500,
	["personal-filter-mk3"] = 1000,
	["personal-filter-mk4"] = 5000
}

local maxSpeed = 0.2
local minSpeed = -0.5

function AddPollutionToPlayer(luaPlayer, pollution)
	global.playerPollution[luaPlayer.index] = global.playerPollution[luaPlayer.index] + pollution
end

function GetPollutionOfPlayer(luaPlayer)
	return global.playerPollution[luaPlayer.index]
end

local playerBaseResistance = 100 --TODO: Change this to a constants file or settings
function GetPlayerResistance(player)
	if (not player.character) then
		return -1
	end
	if (not player.character.grid) then
		return playerBaseResistance
	end
	local calculatedResistance = playerBaseResistance
	for _, equipment in pairs(player.character.grid.equipment) do
		if (FilterValues[equipment.name]) then
			local filterConsumption = equipment.max_energy / 4
			if (filterConsumption <= equipment.energy) then
				calculatedResistance = calculatedResistance + FilterValues[equipment.name]
				equipment.energy = equipment.energy - filterConsumption
			end
		end
	end

	return calculatedResistance
end

function CheckPlayerBreath()
	for _, player in ipairs(game.connected_players) do
		local pollution = player.surface.get_pollution(player.position)
		local playerPollution = GetPollutionOfPlayer(player)
		local addedPollution = (pollution - playerPollution)
		if addedPollution > 0 then
			addedPollution = addedPollution * 0.0001
		else
			addedPollution = addedPollution * 0.00001
		end
		AddPollutionToPlayer(player, addedPollution)
		print(GetPollutionOfPlayer(player))

		local resistance = GetPlayerResistance(player)
		print(player.name .. " has a resistance of: " .. resistance)
		if (resistance > 0) then
			player.character_running_speed_modifier = 
		end
	end
end

function Command_HealPlayer(tableIn)
	local player = game.get_player(tableIn.player_index)
	local pollution = GetPollutionOfPlayer(player)
	player.print("You had: " .. pollution .. " pollution")
	AddPollutionToPlayer(player, -pollution)
	player.print("You now have: " .. GetPollutionOfPlayer(player) .. " pollution")
end

function Command_Test(tableIn)
	local player = game.get_player(tableIn.player_index)
end

function InitializePlayer(playerIndex)
	if (not global.playerPollution[playerIndex]) then global.playerPollution[playerIndex] = 0 end
end

script.on_event(defines.events.on_player_joined_game, function(tableIn)
	if (not global.playerPollution) then global.playerPollution = {} end
	InitializePlayer(tableIn.player_index)
end)

script.on_init(function ()
	if (not global.playerPollution) then global.playerPollution = {} end
	for _, player in pairs(game.players) do
		game.print(player.name)
		InitializePlayer(player.index)
	end

	if remote.interfaces["silo_script"] then
		remote.call("silo_script", "set_no_victory", true)
	end
end)

script.on_event(defines.events.on_rocket_launched, function (tableIn)
	game.print("Rocket launched")
	for name, amount in pairs(tableIn.rocket.get_inventory(defines.inventory.rocket).get_contents()) do
		if (name == "FTL-Module") then
			game.reset_game_state()
			game.set_game_state{
				game_finished = true,
				player_won = true,
				can_continue = true,
				victorious_force = game.forces.player,
			}
		end
	end
end)

commands.add_command("heal_player", "Heals the player of any pollution sickness.", Command_HealPlayer)
commands.add_command("EMC", "EMC test command. If you see this, I messed up.", Command_Test)
script.on_nth_tick(30, CheckPlayerBreath)