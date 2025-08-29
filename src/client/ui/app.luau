local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script.Parent.Parent
local ui = client.ui
local pages = ui.pages

local producers = require(client.producers)
local selectors = require(client.producers.selectors)
local React = require(ReplicatedStorage.Packages.React)
local ReactReflex = require(ReplicatedStorage.Packages.ReactReflex)

local ScreenGui = require(ui.components.ScreenGui)
local e = React.createElement

local routesContent = {
	game = require(pages.Game),
	menu = require(pages.Menu),
	credits = require(pages.Credits),
	donations = require(pages.Donations),
}

producers.setRoutes({
	"menu",
	"game",
	"credits",
	"donations",
})

function App()
	local routeName = ReactReflex.useSelector(selectors.selectCurrentRoute)
	print(routeName)
	return e(ScreenGui, {}, {
		Content = e(routesContent[routeName]),
	})
end

return App
