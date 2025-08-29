local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local packages = ReplicatedStorage:WaitForChild("Packages")

local _ = require(script.reactConfig)
local app = require(script.app)
local rootProvider = require(script.rootProvider)

local React = require(packages.React)
local ReactRoblox = require(packages.ReactRoblox)

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local root = ReactRoblox.createRoot(Instance.new("Folder"))
local e = React.createElement

root:render(ReactRoblox.createPortal(
	e(React.StrictMode, nil, {
		root = e(rootProvider, nil, {
			app = e(app),
		}),
	}),
	playerGui
))

workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
return nil
