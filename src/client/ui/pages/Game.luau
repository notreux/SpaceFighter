local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script.Parent.Parent.Parent

local selectors = require(client.producers.selectors)
local React = require(ReplicatedStorage.Packages.React)
local ReactReflex = require(ReplicatedStorage.Packages.ReactReflex)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Background = require(client.ui.components.Background)

local merge = Sift.Dictionary.merge
local e = React.createElement

function GameStats()
	local heartCount = ReactReflex.useSelector(selectors.selectHearts)
	local score = ReactReflex.useSelector(selectors.selectScore)

	local hearts = React.useMemo(function()
		if heartCount < 0 then
			return {}
		end

		local result = table.create(heartCount)
		for i = 1, heartCount do
			result[`heart{i}`] = e("ImageLabel", {
				Image = "rbxassetid://82505978020745",
				ResampleMode = Enum.ResamplerMode.Pixelated,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				ImageRectSize = Vector2.new(16, 16),
				ImageRectOffset = Vector2.new(1.5, 79),
			})
		end

		return result
	end, { heartCount })

	return e(Background, nil, {
		StatsFrame = e("ImageLabel", {
			BackgroundTransparency = 1,
			ResampleMode = Enum.ResamplerMode.Pixelated,
			Image = "rbxassetid://82505978020745",
			Size = UDim2.fromScale(0.2, 0.08),
			Position = UDim2.fromScale(0.005, 0.01),
			ImageRectSize = Vector2.new(72, 21),
			ImageRectOffset = Vector2.new(4, 11),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
		}),
		Score = e("TextLabel", {
			Text = score,
			TextColor3 = Color3.fromRGB(146, 143, 184),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextScaled = true,
			BackgroundTransparency = 1,
			Font = Enum.Font.Arcade,
			Position = UDim2.fromScale(0.1, 0.105),
			Size = UDim2.fromScale(0.1, 0.05),
		}),
		HeartsFrame = e(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.05, 0.035),
				Size = UDim2.fromScale(0.16, 0.04),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
			},
			merge({
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 0),
					FillDirection = Enum.FillDirection.Horizontal,
				}),
			}, hearts)
		),
	})
end

return GameStats
