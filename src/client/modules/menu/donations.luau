local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local client = script.Parent.Parent.Parent
local producers = require(client.producers)
local selectors = require(client.producers.selectors)
local spaceship = require(client.modules.game.spaceship)
local UpsideEngine = require(ReplicatedStorage.Dependencies.UpsideEngine)
-- imports
local exports = {}
function exports.load(scene: Scene)
	-- initialization code
	local confettiObject = scene.Objects:FindByName("confetti")
	local spaceshipSkin = scene.Objects:FindByName("spaceshipSkin2")

	local reactiveLabel = UpsideEngine.new("ReactiveLabel")
	reactiveLabel.Instance.AnchorPoint = Vector2.new(0.5, 0.5)
	reactiveLabel.Instance.Position = UDim2.fromScale(0.5, 0.5)
	reactiveLabel.Instance.Size = UDim2.fromScale(0.5, 0.5)
	reactiveLabel.HorizontalAlignment = Enum.HorizontalAlignment.Center
	reactiveLabel.Font = Enum.Font.Arcade
	reactiveLabel:SetScene(scene)
	reactiveLabel.Instance.ZIndex = 100
	reactiveLabel.Text = [[
		<wave intensity=6 duration=1>
			<gradient startColor="#ff4500" endColor="#ff9933" duration=10> 
				Thank you for your donation! You have unlocked a special skin!
			</gradient>
	    </wave>
	]]

	exports.spaceshipSkin = spaceshipSkin
	exports.reactiveLabel = reactiveLabel
	exports.confettiObject = confettiObject
end

function exports.start(scene: Scene)
	-- code to run once everything is ready
	local function applySettings()
		local resolution = workspace.CurrentCamera.ViewportSize.X
		exports.confettiObject.Range = if resolution >= 1900 then 1000 else 500
		exports.reactiveLabel.FontSize = if resolution >= 1900 then 50 else 32
	end

	local camera = workspace.CurrentCamera
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(applySettings)
	applySettings()
end

function exports.unload(scene: Scene)
	-- code to run before the scene is unloaded
end

function exports.cutscene()
	-- code to run before the scene is unloaded

	local sceneScreenGui = exports.reactiveLabel.Instance.Parent.Parent.Parent
	local instance = exports.spaceshipSkin.Instance
	local ranking = producers:getState(selectors.selectDonors)
	sceneScreenGui.DisplayOrder = 100

	exports.reactiveLabel:Render()
	instance.ImageRectOffset = spaceship.getSpaceshipSkin(ranking)
	instance.ZIndex = 101

	SoundService.Confetti:Play()
	exports.confettiObject.Rate = 220
	exports.confettiObject:Emit(100)
	task.wait(2)

	exports.reactiveLabel.Instance:ClearAllChildren()
	instance.ZIndex = 0
	sceneScreenGui.DisplayOrder = 0
end

return exports
