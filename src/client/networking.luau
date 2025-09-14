local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script.Parent
local spaceship = require(client.modules.game.spaceship)
local selectors = require(client.producers.selectors)

local donations = require(client.modules.menu.donations)
local producers = require(client.producers)
local packets = require(ReplicatedStorage.shared.packets)
local oldRanking = {}

packets.donationRankingUpdate.listen(function(ranking)
	oldRanking = producers:getState(selectors.selectDonors)
	producers.setDonors(ranking)
end)

packets.donationCompleted.listen(function(ranking)
	local oldSkin = spaceship.getSpaceshipSkin(oldRanking)
	local newSkin = spaceship.getSpaceshipSkin(ranking)

	if oldSkin ~= newSkin then
		donations.cutscene()
	end
end)

packets.requestRankingUpdate.send()
return {}
