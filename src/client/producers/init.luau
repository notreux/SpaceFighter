local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)
local gameStore = require(script.game)
local globals = require(script.globals)
local menu = require(script.menu)

export type Producer = Reflex.Producer<State, Actions>
export type Actions = globals.Actions & gameStore.Actions & menu.Actions

export type State = {
	globals: globals.State,
	menu: menu.State,
	game: gameStore.State,
}

return Reflex.combineProducers({
	globals = globals,
	menu = menu,
	game = gameStore,
}) :: Producer
