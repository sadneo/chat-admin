local Players = game:GetService("Players")

local Settings = require(script.Settings)
local Commands

for _, package in ipairs(script.PackageFolder) do
	local commandPackage = require(package)
	for name, command in pairs(commandPackage) do
		Commands[name] = command
	end
end

Players.PlayerAdded:Connect(function(player)
	if Settings.Admins[player.UserId] == nil then
		Settings.Admins[player.UserId] = 0
	end
	player.Chatted:Connect(function(message)
		local adminLevel = Settings.Admins[player.UserId]
		if adminLevel then
			if string.sub(message, 1, 1) == Settings.Prefix then
				local splitMessage = message:sub(2, -1):split(" ")
				local command = splitMessage:remove(1):lower()
				if Commands[command].Level >= adminLevel then
					local log = Commands[command].Command(player, splitMessage:unpack())
					Settings.Logs:insert(#Settings.Logs+1, log)
				end
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if Settings.Admins[player.UserId] == 0 then
		Settings.Admins[player.UserId] = nil
	end
end)