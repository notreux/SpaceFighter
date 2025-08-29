local SoundService = game:GetService("SoundService")
local client = script.Parent.Parent.Parent
local backgroundStars = require(client.modules.globals.backgroundStars)
-- imports
local exports = {}
function exports.load(scene: Scene)
	-- initialization code
	SoundService.LobbyMusic:Play()
	backgroundStars.starsSpeed = 50
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
	SoundService.LobbyMusic:Stop()
end

return exports
