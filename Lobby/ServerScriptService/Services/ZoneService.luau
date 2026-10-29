local ZoneService = {}
local Zones = {}


--Services
local ServerScriptService = game:GetService("ServerScriptService")


-- Modules
local Zone = require(ServerScriptService.Classes.Zone)


-- Objects
local ZonesFolder = workspace.Zones


-- Functions
function ZoneService:Init()
	
	for _, zone: Folder in pairs(ZonesFolder:GetChildren()) do
		if zone:IsA("Folder") and not Zones[zone] then
			local newZone = Zone.new(zone)
			newZone:Init()
			Zones[zone] = newZone
		end
	end
	
end


return ZoneService
