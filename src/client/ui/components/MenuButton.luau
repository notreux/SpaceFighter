local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Button = require(script.Parent.Button)

local merge = Sift.Dictionary.merge
local e = React.createElement

function MenuButton(props)
	return e(
		Button,
		merge(
			{
				ResampleMode = Enum.ResamplerMode.Pixelated,
				Image = "rbxassetid://82505978020745",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(250, 50),
				ImageRectOffset = Vector2.new(8, 48),
				ImageRectSize = Vector2.new(30, 9),
			} :: Button.ButtonProps,
			props
		)
	)
end


return MenuButton