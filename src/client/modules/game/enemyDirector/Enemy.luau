local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script.Parent.Parent.Parent.Parent
local spaceship = require(client.modules.game.spaceship)
local UpsideEngine = require(ReplicatedStorage.Dependencies.UpsideEngine)
local Character = require(ReplicatedStorage.Dependencies.UpsideEngine.Classes.Public.Character)
local spaceshots = require(client.modules.game.spaceshots)

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(): typeof(Character) & typeof(Enemy) & Enemy
	local self = UpsideEngine.new("Character")
	self.Mass = 0
	self.Health = 3
	self.HitboxScale = 0.35
	self.ShootCooldown = 1
	self.MovementCooldown = 0.2
	self.AttackCooldown = 2
	self.ShotsPerAttack = 4
	self.WalkSpeed = 200
	self.Bullets = 1
	self.MovementPower = 100
	self.CollisionGroup = 1
	self.CanCollide = false
	self.__cooldowns = {
		movement = 0,
		shoot = 0,
		attack = 0,
	}

	self.__temp = {
		shots = 0,
	}

	local instance = self.Instance
	instance.Image = "rbxassetid://88783850080059"
	instance.ImageRectOffset = Vector2.new(184, 89 * math.random(0, 2))
	instance.ImageRectSize = Vector2.new(50, 64)
	instance.Position = UDim2.fromScale(0.5, -0.1)
	instance.Size = UDim2.fromScale(0.1, 0.1)
	instance.SizeConstraint = Enum.SizeConstraint.RelativeXX
	instance.ZIndex = 10
	self:SetSpriteSheet("died", "rbxassetid://76901883099057", Vector2.new(7, 0))

	return setmetatable(self, Enemy)
end

function Enemy:shoot()
	local cooldowns = self.__cooldowns
	local minCooldown = math.max(self.Bullets * 0.1, 0.2)
	local now = os.clock()

	if now - cooldowns.shoot > math.max(minCooldown, self.ShootCooldown) then
		spaceshots.enemyShoot(self, self.Bullets)
		cooldowns.shoot = now
		self.__temp.shots += 1
	end
end

function Enemy:move()
	local borderThreshold = Vector2.new(150, 50)
	local playerThreshold = 800

	local absPosition = self.Instance.AbsolutePosition
	local spaceshipAbsPos = spaceship.spaceship.Instance.AbsolutePosition

	local screenSize = workspace.CurrentCamera.ViewportSize
	local direction = Vector2.new(math.random(-1, 1), math.random(-1, 1))

	local isNearOfXBorder = absPosition.X < borderThreshold.X and direction.X < 0 --
		or absPosition.X > screenSize.X * 0.9 and direction.X > 0

	local isNearOfYBorder = absPosition.Y < borderThreshold.Y and direction.Y < 0 --
		or absPosition.Y > screenSize.Y * 0.2 and direction.Y > 0

	local distanceFromPlayer = spaceshipAbsPos.X - absPosition.X
	local isGettingFarFromPlayer = math.abs(distanceFromPlayer) > playerThreshold
		and (direction.X > 0 and distanceFromPlayer < 0 or direction.X < 0 and distanceFromPlayer > 0)

	direction = Vector2.new( --
		if isNearOfXBorder or isGettingFarFromPlayer then -direction.X else direction.X,
		if isNearOfYBorder then -direction.Y else direction.Y
	)

	self:ApplyForce(direction * self.WalkSpeed * self.MovementPower)
end

function Enemy:update()
	if self.Health <= 0 then
		return
	end

	local now = os.clock()
	local cooldowns = self.__cooldowns
	local shots = self.__temp.shots

	local canMove = now - cooldowns.movement > self.MovementCooldown
	local canShoot = now - cooldowns.attack > self.AttackCooldown

	if canMove then
		self:move()
		cooldowns.movement = now
	end

	if canShoot then
		self:shoot()
	end

	if shots >= self.ShotsPerAttack then
		self.__temp.shots = 0
		cooldowns.attack = now
	end
end

export type Enemy = {
	Bullets: number,
	ShootCooldown: number,
	ShotsPerAttack: number,
	AttackCooldown: number,
	MovementCooldown: number,
	MovementPower: number,
}

return setmetatable(Enemy, Character)
