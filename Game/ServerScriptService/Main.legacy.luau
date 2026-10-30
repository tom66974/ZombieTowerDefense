-- Services
local ServerScriptService = game:GetService("ServerScriptService")


-- Init
for _, serviceModule in ipairs(ServerScriptService.Services:GetChildren()) do
	local service = require(serviceModule)
	if type(service.Init) == "function" then
		service:Init()
	end
end