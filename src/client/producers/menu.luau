local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local menu = {
	donors = {},
}

export type State = typeof(menu)
export type Actions = {
	setDonors: (donors: { { name: string, amount: number } }) -> nil,
}

return Reflex.createProducer(menu, {
	setDonors = function(state, donors)
		local nextState = table.clone(state)
		nextState.donors = table.clone(donors)

		return nextState
	end,
})
