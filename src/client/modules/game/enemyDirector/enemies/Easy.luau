local Enemy = require(script.Parent.Parent.Enemy)
local EasyEnemy = {}
EasyEnemy.__index = EasyEnemy

function EasyEnemy.new()
	local self = Enemy.new()
	self.Bullets = 2
	self.Health = 5
	self.HitboxScale = 0.45
	self.ShootCooldown = 1
	self.ShotsPerAttack = 2
	self.AttackCooldown = 2
	self.MovementCooldown = 0.5
	self.MovementPower = 120
	self.Instance.ImageRectOffset = Vector2.new( --
		141,
		self.Instance.ImageRectOffset.Y
	)

	return setmetatable(self, EasyEnemy)
end

return setmetatable(EasyEnemy, Enemy)
