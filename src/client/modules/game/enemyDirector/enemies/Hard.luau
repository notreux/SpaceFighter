local Enemy = require(script.Parent.Parent.Enemy)
local HardEnemy = {}
HardEnemy.__index = HardEnemy

function HardEnemy.new()
	local self = Enemy.new()
	self.Bullets = 5
	self.Health = 20
	self.ShootCooldown = 0.6
	self.HitboxScale = 0.75
	self.ShotsPerAttack = 3
	self.AttackCooldown = 3
	self.MovementCooldown = 0.4
	self.MovementPower = 180

	self.Instance.ImageRectOffset = Vector2.new( --
		32,
		self.Instance.ImageRectOffset.Y
	)

	return setmetatable(self, HardEnemy)
end

return setmetatable(HardEnemy, Enemy)
