-- imports
local exports = {}
function exports.load(scene: Scene)
	-- initialization code
	local sceneInstance = scene.Instance :: Folder
	local camera = scene.Camera
	camera.FollowSubject = false
	camera:SetPosition(UDim2.fromScale(0.5, 0.5))
	sceneInstance.GameFrame.Position = UDim2.fromScale(0.5, 0.5)
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
end

return exports
