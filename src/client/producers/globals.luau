local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reflex = require(ReplicatedStorage.Packages.Reflex)

local globals = {
	routes = {},
	currentRoute = "menu",
}

export type State = typeof(globals)
export type Actions = {
	setCurrentRoute: (route: string) -> nil,
	setRoutes: (routes: { string }) -> nil,
}

return Reflex.createProducer(globals, {
	setCurrentRoute = function(state, currentRoute)
		local nextState = table.clone(state)
		nextState.currentRoute = currentRoute

		return nextState
	end,
	setRoutes = function(state, routes)
		local nextState = table.clone(state)
		nextState.routes = table.clone(routes)

		return nextState
	end,
})
