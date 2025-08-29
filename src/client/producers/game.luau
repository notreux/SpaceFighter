local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local gameStore = {
	score = 0,
	hearts = 0,
}

export type State = typeof(gameStore)
export type Actions = {
	setScore: (score: number) -> nil,
	setHearts: (hearts: number) -> nil,
	incrementScore: (enemyLevel: number) -> nil,
	incrementHearts: () -> nil,
}

return Reflex.createProducer(gameStore, {
	setScore = function(state, score)
		local nextState = table.clone(state)
		nextState.score = score

		return nextState
	end,
	setHearts = function(state, hearts)
		local nextState = table.clone(state)
		nextState.hearts = hearts

		return nextState
	end,
	setRoutes = function(state, hearts)
		local nextState = table.clone(state)
		nextState.hearts = table.clone(hearts)

		return nextState
	end,
	incrementScore = function(state, enemyLevel)
		local nextState = table.clone(state)
		nextState.score += math.random(10, 50) * enemyLevel

		return nextState
	end,
	incrementHearts = function(state)
		local nextState = table.clone(state)
		nextState.hearts += 1

		return nextState
	end,
})
