local Players = game:GetService("Players")
local Settings = require(script.Parent.Settings)

local function getFullPlayerName(name)
	for _,player in ipairs(game.Players:GetChildren()) do
		if string.sub(player.Name, 1, #name) == name then
			return player
		end
	end
end

local Commands = {
	["admin"] = {
		Level = 255,
		function(speaker, username, level)
			if Settings.Admin[speaker.UserId] > level then
				local userId = getFullPlayerName(username).UserId
				Settings.Admins[userId] = level
			end
		end,
	},
	["unadmin"] = {
		Level = 255,
		function(speaker, username)
			local userId = getFullPlayerName(username).UserId
			if Settings.Admin[speaker.UserId] > Settings.Admin[userId] then
				Settings.Admins[userId] = nil
			end
		end,
	},
	["logs"] = {
		Level = 1,
		function(speaker)
			for i, log in ipairs(Settings.Logs) do
				print(tostring(i)..": "..log)
			end
		end,
	},
	["kick"] = {
		Level = 200,
		Command = function(speaker, username, message)
			local player = getFullPlayerName(username)
			if Settings.Admin[speaker.UserId] > Settings.Admin[player.UserId] then
				player:Kick(message)
			end
		end,
	},
}

return Commands
