local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UpsideEngine = require(ReplicatedStorage.Dependencies.UpsideEngine)
local SceneManager = UpsideEngine.GetService("SceneManager")

-- imports

local exports = {}
exports.shotsSpeed = 1000
exports.shots = {}

function exports.load(scene: Scene)
	-- initialization code
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
	exports.connection = RunService.Heartbeat:Connect(function(dt)
		local screenSize = workspace.CurrentCamera.ViewportSize
		for index, shotData in exports.shots do
			local shot = shotData.shot :: PhysicalObject
			local instance = shot.Instance
			local yPosition = instance.AbsolutePosition.Y
			local xPosition = instance.AbsolutePosition.X

			if
				yPosition <= -100 --
				or yPosition >= screenSize.Y
				or xPosition <= -100
				or xPosition >= screenSize.X
			then
				shotData.shot:Destroy()
				table.remove(exports.shots, index)
				continue
			end

			shot.Velocity = shotData.direction * exports.shotsSpeed
		end
	end)
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
	for _, shotData in exports.shots do
		shotData.shot:Destroy()
	end

	exports.connection:Disconnect()
	exports.shots = {}
end

function exports.shoot(spaceship: Character, amount: number)
	local scene = SceneManager:Get(spaceship.Scene)
	local shotsData = {}

	local spread = if amount == 1 then 0 else amount * 30
	local totalAngle = math.rad(spread)
	local startAngle = -totalAngle / 2
	local step = totalAngle / math.max(amount - 1, 1)

	for i = 0, amount - 1 do
		local angle = startAngle + step * i
		local dir = Vector2.new(math.sin(angle), -math.cos(angle))

		local shot = UpsideEngine.new("PhysicalObject")
		shot.Anchored = false
		shot.CanCollide = false
		shot.Mass = 0
		shot.CollisionGroup = 1
		shot.CollisionBlacklist[spaceship.Id] = true

		local instance = shot.Instance
		instance.Image = "rbxassetid://79823117526541"
		instance.Size = UDim2.fromScale(0.012, 0.048)
		instance.Position = (spaceship.Instance :: ImageLabel).Position
		instance.ZIndex = 9
		instance.ImageRectSize = Vector2.new(8, 19)
		instance.ImageRectOffset = Vector2.new(147, 112)
		instance.Rotation = math.deg(angle)

		shot:On("Collision", function(character: Character)
			if character:IsA("Character") and character.Health > 0 and not shot.destroying then
				shot.destroying = true
				character:UpdateHealth(character.Health - 1)
				shot.Instance.Position = UDim2.fromScale(0, -1)
				-- we already manage the deletion of the shot on the main loop
			end
		end)

		local shotData = {
			shot = shot,
			createdAt = os.clock(),
			direction = dir,
		}

		table.insert(exports.shots, shotData)
		table.insert(shotsData, shotData)
	end

	for _, shotData in exports.shots do
		local shot = shotData.shot
		for _, shotData2 in shotsData do
			shot.CollisionBlacklist[shotData2.shot.Id] = true
		end

		shot:SetScene(scene)
	end

	return shotsData
end

function exports.enemyShoot(...)
	local shotsData = exports.shoot(...)

	for _, shotData in shotsData do
		shotData.isEnemy = true
		shotData.direction = -shotData.direction

		local shot = shotData.shot
		shot.HitboxScale = 0.8
		shot.Instance.Rotation += 180
		shot.CollisionGroup = 0

		local instance = shot.Instance
		instance.ImageRectOffset = Vector2.new(147, 80)
	end

	return shotsData
end

return exports
