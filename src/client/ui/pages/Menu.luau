local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script.Parent.Parent.Parent
local producers = require(client.producers)
local UpsideEngine = require(ReplicatedStorage.Dependencies.UpsideEngine)
local React = require(ReplicatedStorage.Packages.React)
local MenuButton = require(client.ui.components.MenuButton)
local Background = require(client.ui.components.Background)

local SceneManager = UpsideEngine.GetService("SceneManager")
local e = React.createElement

function Menu()
	return e(Background, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.45),
	}, {
		UIListLayout = e("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 20),
		}),
		BPlay = e(MenuButton, {
			Text = "Play",
			OnActivated = React.useCallback(function()
				local gameScene = SceneManager:FindByName("game")
				if gameScene then
					producers.setHearts(4)
					producers.setScore(0)
					producers.setCurrentRoute("game")
					gameScene:Enable()
				end
			end, {}),
		}),
		CCredits = e(MenuButton, {
			Text = "Credits",
			OnActivated = React.useCallback(function()
				producers.setCurrentRoute("credits")
			end, {}),
		}),
		DDonate = e(MenuButton, {
			Text = "Donate",
			OnActivated = React.useCallback(function()
				producers.setCurrentRoute("donations")
			end, {}),
		}),
	})
end

return Menu
