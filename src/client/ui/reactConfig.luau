local runService = game:GetService("RunService")
if runService:IsStudio() then
	_G.__DEV__ = true
end

return nil
