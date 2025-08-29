local SoundService = game:GetService("SoundService")
local client = script.Parent.Parent.Parent
local backgroundStars = require(client.modules.globals.backgroundStars)
-- imports
local exports = {}
function exports.load(scene: Scene)
	-- initialization code
	backgroundStars.starsSpeed = 500
	SoundService.GameMusic:Play()
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
	SoundService.GameMusic:Stop()
end

return exports
