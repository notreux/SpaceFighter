local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script.Parent.Parent
local producers = require(client.producers)
local React = require(ReplicatedStorage.Packages.React)
local ReactReflex = require(ReplicatedStorage.Packages.ReactReflex)
local e = React.createElement

local function RootProvider(props: {
	children: React.Node,
})
	return e(ReactReflex.ReflexProvider, {
		producer = producers,
	}, props.children)
end

return RootProvider
