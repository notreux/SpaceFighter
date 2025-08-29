local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local e = React.createElement
local merge = Sift.Dictionary.merge

function Background(props)
	return e(
		"Frame",
		merge({
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		}, props)
	)
end

return Background
