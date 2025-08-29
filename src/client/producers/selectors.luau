local producers = require(script.Parent)
local selectors = {}

function selectors.selectRoutes(state: producers.State)
	return state.globals.routes
end

function selectors.selectCurrentRoute(state: producers.State)
	return state.globals.currentRoute
end

function selectors.selectHearts(state: producers.State)
	return state.game.hearts
end

function selectors.selectScore(state: producers.State)
	return state.game.score
end

function selectors.selectDonors(state: producers.State)
	return state.menu.donors
end

return selectors
