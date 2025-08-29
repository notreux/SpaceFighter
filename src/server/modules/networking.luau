local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local donationRanking = require(ServerScriptService.server.lib.donationRanking)
local packets = require(ReplicatedStorage.shared.packets)
-- imports

local exports = {}

function exports.load()
	-- initialization code
	local ranking = donationRanking.getRanking()
	local function playerSetup(player)
		packets.donationRankingUpdate.sendTo(ranking, player)
	end

	for _, player in Players:GetPlayers() do
		playerSetup(player)
	end

	exports.playerAddedCn = Players.PlayerAdded:Connect(playerSetup)
	exports.donactionCn = donationRanking.newDonation:Connect(function(player, ranking)
		packets.donationCompleted.sendTo(ranking, player)
		packets.donationRankingUpdate.sendToAll(ranking)
	end)
end

function exports.start()
	-- code to run once everything is ready
	local lastUpdate = os.clock()
	exports.heartbeatCn = RunService.Heartbeat:Connect(function()
		local now = os.clock()
		if now - lastUpdate < 30 then
			return
		end

		lastUpdate = os.clock()
		local ranking = donationRanking.getRanking()
		packets.donationRankingUpdate.sendToAll(ranking)
	end)
end

function exports.unload()
	-- code to run before the server is closed
	exports.heartbeatCn:Disconnect()
	exports.playerAddedCn:Disconnect()
	exports.donactionCn:Disconnect()
end

return exports
