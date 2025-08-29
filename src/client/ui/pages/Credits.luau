local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script.Parent.Parent.Parent
local producers = require(client.producers)
local React = require(ReplicatedStorage.Packages.React)
local MenuButton = require(client.ui.components.MenuButton)
local Background = require(client.ui.components.Background)
local e = React.createElement

function Credits()
	return e(Background, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.45),
	}, {
		UIListLayout = e("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 20),
		}),
		Text = e("TextLabel", {
			TextColor3 = Color3.fromRGB(255, 123, 57),
			Text = "Game Credits",
			TextScaled = true,
			BackgroundTransparency = 1,
			Font = Enum.Font.Arcade,
			Size = UDim2.fromScale(1, 0.1),
			TextXAlignment = Enum.TextXAlignment.Center,
		}),
		TextContent = e("TextLabel", {
			TextColor3 = Color3.fromRGB(255, 255, 255),
			RichText = true,
			Text = ([[
				Developed by <b>NotReux</b>

				<br/><br/>
				Thanks to <b>timberlate007</b> for Shoot'em up free asset pack used in this demo 

				<br/><br/>
				<font color= "rgb(0, 234, 255)"><b>Powered by Upside Engine</b></font>
				<br/>
			]]):gsub("\t", ""):gsub("\n", ""),
			TextScaled = true,
			BackgroundTransparency = 1,
			Font = Enum.Font.Arcade,
			Size = UDim2.fromScale(0.5, 0.3),
			TextXAlignment = Enum.TextXAlignment.Center,
		}),
		ZBack = e(MenuButton, {
			Text = "Go Back",
			OnActivated = React.useCallback(function()
				producers.setCurrentRoute("menu")
			end, {}),
		}),
	})
end

return Credits
