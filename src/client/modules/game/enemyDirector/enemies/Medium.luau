local Enemy = require(script.Parent.Parent.Enemy)
local MediumEnemy = {}
MediumEnemy.__index = MediumEnemy

function MediumEnemy.new()
	local self = Enemy.new()
	self.Bullets = 3
	self.Health = 15
	self.HitboxScale = 0.65
	self.ShootCooldown = 1
	self.ShotsPerAttack = 2
	self.AttackCooldown = 3
	self.MovementCooldown = 0.5
	self.MovementPower = 140
	self.Instance.ImageRectOffset = Vector2.new( --
		90,
		self.Instance.ImageRectOffset.Y
	)

	return setmetatable(self, MediumEnemy)
end

return setmetatable(MediumEnemy, Enemy)
