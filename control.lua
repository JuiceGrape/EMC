function AddPollutionToPlayer(luaPlayer, pollution)
	global.playerPollution[luaPlayer.index] = global.playerPollution[luaPlayer.index] + pollution
end

function GetPollutionOfPlayer(luaPlayer)
	return global.playerPollution[luaPlayer.index]
end

function CheckPlayerBreath(tableIn)

	for _, player in ipairs(game.connected_players) do
		local pollution = player.surface.get_pollution(player.position)
		AddPollutionToPlayer(player, pollution)
		player.print("You now have " .. GetPollutionOfPlayer(player) .. " pollution")
	end

end

function Command_HealPlayer(tableIn)
	local player = game.get_player(tableIn.player_index)
	local pollution = GetPollutionOfPlayer(player)
	player.print("You had: " .. pollution .. " pollution")
	AddPollutionToPlayer(player, -pollution)
	player.print("You now have: " .. GetPollutionOfPlayer(player) .. " pollution")
end

script.on_event(defines.events.on_player_joined_game, function(tableIn)
	if (not global.playerPollution) then global.playerPollution = {} end
	if (not global.playerPollution[tableIn.player_index]) then global.playerPollution[tableIn.player_index] = 0 end
	game.print("Player joined event called")
end)


commands.add_command("heal_player", "Heals the player of any pollution sickness.", Command_HealPlayer)
script.on_nth_tick(600, CheckPlayerBreath)