local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ByteNet = require(ReplicatedStorage.Packages.ByteNet)

return ByteNet.defineNamespace("main", function()
	return {
		donationRankingUpdate = ByteNet.definePacket({
			value = ByteNet.array(ByteNet.struct({
				name = ByteNet.string,
				amount = ByteNet.uint32,
			})),
		}),
		donationCompleted = ByteNet.definePacket({
			value = ByteNet.array(ByteNet.struct({
				name = ByteNet.string,
				amount = ByteNet.uint32,
			})),
		}),
		requestRankingUpdate = ByteNet.definePacket({
			value = ByteNet.nothing,
		}),
	}
end)
