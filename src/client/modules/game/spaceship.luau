local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local client = script.Parent.Parent.Parent

local selectors = require(client.producers.selectors)
local producers = require(client.producers)
local spaceshots = require(script.Parent.spaceshots)
local UpsideEngine = require(ReplicatedStorage.Packages.UpsideEngine)

local CrossPlatformService = UpsideEngine.GetService("CrossPlatformService")
local SceneManager = UpsideEngine.GetService("SceneManager")
-- imports

local exports = {}

function exports.getSpaceshipSkin(ranking)
	local playerName = game.Players.LocalPlayer.Name
	local skin = Vector2.zero

	for _, donor in ranking do
		local amount = donor.amount
		if donor.name == playerName then
			if amount >= 5000 then
				skin = Vector2.new(184, 178)
			elseif amount >= 2500 then
				skin = Vector2.new(96, 114)
			elseif amount >= 1000 then
				skin = Vector2.new(8, 114)
			elseif amount >= 500 then
				skin = Vector2.new(192, 0)
			elseif amount >= 250 then
				skin = Vector2.new(128, 0)
			elseif amount >= 100 then
				skin = Vector2.new(64, 0)
			end

			break
		end
	end

	return skin
end

function exports.load(scene: Scene)
	-- initialization code
	local ranking = producers:getState(selectors.selectDonors)
	local spaceship = scene.Objects:FindByName("spaceship")
	spaceship:Stop()

	local instance = spaceship.Instance
	instance.Image = "rbxassetid://112661499088523"
	instance.ImageRectOffset = exports.getSpaceshipSkin(ranking)

	CrossPlatformService:SetPlayerCharacter(spaceship)
	CrossPlatformService.SideView = false

	spaceship:Once("Died", function()
		spaceship:Play("died")
		task.wait(0.7)
		SceneManager:FindByName("menu"):Enable()
		producers.setCurrentRoute("menu")
	end)

	exports.spaceship = spaceship
	exports.healthCn = spaceship:On("HealthChanged", function()
		producers.setHearts(spaceship.Health)
	end)
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
	local lastShot = 0
	exports.connection = RunService.Heartbeat:Connect(function()
		local now = os.clock()
		local bullets = 1

		local canShoot = now - lastShot > math.max(bullets * 0.1, 0.2)
		local isMouseClickDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

		if canShoot and isMouseClickDown then
			spaceshots.shoot(exports.spaceship, bullets)
			lastShot = now
		end
	end)
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
	local spaceship = exports.spaceship
	spaceship.Health = 4

	exports.spaceship = nil
	exports.connection:Disconnect()
	exports.healthCn:Disconnect()
end

return exports
