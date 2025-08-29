local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local DonationRanking = DataStoreService:GetDataStore("DonationRanking")
local Players = game:GetService("Players")

local newDonation = Instance.new("BindableEvent")
local exports = {}
exports.newDonation = newDonation.Event

local function sortRanking(ranking)
	local sorted = {}
	for userId, amount in ranking do
		table.insert(sorted, {
			name = Players:GetNameFromUserIdAsync(tonumber(userId)),
			amount = amount,
		})
	end

	table.sort(sorted, function(a, b)
		return a.amount > b.amount
	end)

	return sorted
end

function exports.getRanking()
	return sortRanking(DonationRanking:GetAsync("ranking") or {})
end

local function processDonation(player, receiptInfo)
	local currencySpent = receiptInfo.CurrencySpent
	local userId = tostring(player.UserId)

	local newRanking = DonationRanking:UpdateAsync("ranking", function(current)
		current = current or {}
		current[userId] = (current[userId] or 0) + currencySpent
		return current
	end)

	newDonation:Fire(player, sortRanking(newRanking))
end

local function processReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local player = Players:GetPlayerByUserId(userId)

	if player then
		local success, result = pcall(processDonation, player, receiptInfo)
		if success then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end

	return Enum.ProductPurchaseDecision.NotProcessedYet
end

MarketplaceService.ProcessReceipt = processReceipt
return exports
