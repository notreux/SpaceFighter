local RunService = game:GetService("RunService")
local client = script.Parent.Parent.Parent
local producers = require(client.producers)

-- imports

local MAX_VALUES = {
	Bullets = 5,
	ShotsPerAttack = 4,
	MovementPower = 170,
	AttackCooldown = 2,
	ShootCooldown = 1,
	MovementCooldown = 0.5,
}

local WEIGHTS = {
	Bullets = 7,
	ShootCooldown = 3,
	ShotsPerAttack = 4,
	AttackCooldown = 3,
	MovementCooldown = 2,
	MovementPower = 4,
}

local MAX_TOTAL_DIFFICULTY = 10
local SPAWN_FREQUENCY = 4

local function getEnemyDifficulty(enemy)
	local difficulty = 0
	local ratios = {
		Bullets = math.min(enemy.Bullets / MAX_VALUES.Bullets, 1),
		ShotsPerAttack = math.min(enemy.ShotsPerAttack / MAX_VALUES.ShotsPerAttack, 1),
		MovementPower = math.min(enemy.MovementPower / MAX_VALUES.MovementPower, 1),
		ShootCooldown = 1 - math.min(enemy.ShootCooldown / MAX_VALUES.ShootCooldown, 1),
		AttackCooldown = 1 - math.min(enemy.AttackCooldown / MAX_VALUES.AttackCooldown, 1),
		MovementCooldown = 1 - math.min(enemy.MovementCooldown / MAX_VALUES.MovementCooldown, 1),
	}

	for ratioName, ratio in ratios do
		difficulty += ratio * WEIGHTS[ratioName]
	end

	return difficulty
end

local availableEnemies = {
	require(script.enemies.VeryEasy),
	require(script.enemies.Easy),
	require(script.enemies.Medium),
	require(script.enemies.Hard),
}

local exports = {}
exports.enemies = {}

function exports.load(scene: Scene)
	-- initialization code
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
	local startTime = os.clock()
	local lastSpawn = os.clock()
	local enemies = exports.enemies

	exports.connection = RunService.Heartbeat:Connect(function()
		local now = os.clock()
		local difficulty = 0
		local spawnChance = 0
		local maxSeconds = 120

		local elapsedTime = math.min(now - startTime, maxSeconds)
		local harderEnemyIdx = math.floor(math.clamp(elapsedTime / maxSeconds * 4, 1, 4))
		local currentMaxEnemies = math.floor((elapsedTime / maxSeconds) * 2) + 1
		local scaledMaxDifficulty = MAX_TOTAL_DIFFICULTY + (elapsedTime / maxSeconds) * 2

		for _, enemy in enemies do
			difficulty += getEnemyDifficulty(enemy)
			enemy:update()
		end

		difficulty = difficulty / math.max(#enemies, 1)
		spawnChance = 1 - (difficulty / scaledMaxDifficulty)

		if --
			now - lastSpawn > SPAWN_FREQUENCY
			and spawnChance > math.random()
			and (#enemies < currentMaxEnemies or #enemies == 0)
		then
			local enemyIndex = #enemies + 1
			local enemyLevel = math.random(1, harderEnemyIdx)
			local enemyType = availableEnemies[enemyLevel]
			local enemy = enemyType.new()

			enemy:SetScene(scene)
			enemy:Once("Died", function()
				enemies[enemyIndex] = nil
				enemy:Play("died", 0.1)
				task.wait(0.7)
				producers.incrementScore(enemyLevel)
				enemy:Destroy()
			end)

			enemies[enemyIndex] = enemy
			lastSpawn = now
		end
	end)
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
	for _, enemy in exports.enemies do
		enemy:Destroy()
	end

	exports.connection:Disconnect()
	exports.enemies = {}
end

return exports
