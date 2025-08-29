local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UpsideEngine = require(ReplicatedStorage.Dependencies.UpsideEngine)
-- imports
local function createParallaxStars(scene, url)
	local stars = UpsideEngine.new("Parallax")
	stars:SetScene(scene)
	stars:SetTexture(url)
	stars.CanvasSize = Vector2.new(0.5, 1)
	stars.Instance.Size = UDim2.fromScale(1, 1)
	stars.Instance.Position = UDim2.fromScale(0.5, 0.5)
	stars.Instance.Content.ZIndex = 3

	return stars
end

local exports = {}
exports.starsSpeed = 50

function exports.load(scene: Scene)
	-- initialization code
	exports.smallStars = createParallaxStars(scene, "rbxassetid://82801950843525")
	exports.bigStars = createParallaxStars(scene, "rbxassetid://114121545318011")
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
	local smallStars = exports.smallStars
	local bigStars = exports.bigStars

	exports.connection = RunService.Heartbeat:Connect(function(dt: number)
		local offset = Vector2.new(0, exports.starsSpeed * dt)
		smallStars.Offset -= offset
		bigStars.Offset -= offset * 0.5

		smallStars:UpdateTiles()
		bigStars:UpdateTiles()
	end)
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
	exports.connection:Disconnect()
	exports.bigStars:Destroy()
	exports.smallStars:Destroy()
end

return exports
