local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)

local merge = Sift.Dictionary.merge
local e = React.createElement

function MenuButton(props: ButtonProps)
	local instanceProps = table.clone(props)
	instanceProps.Text = nil
	instanceProps.OnActivated = nil

	return e(
		"ImageButton",
		merge({
			BackgroundTransparency = 1,
			[React.Event.Activated] = props.OnActivated,
		}, instanceProps),
		{
			TextLabel = e("TextLabel", {
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Text = props.Text,
				TextScaled = true,
				BackgroundTransparency = 1,
				Font = Enum.Font.Arcade,
				Size = UDim2.fromScale(1, 0.7),
				TextXAlignment = Enum.TextXAlignment.Center,
			}),
		}
	)
end

export type ButtonProps = any & {
	Text: string,
	OnActivated: () -> nil,
}

return MenuButton
