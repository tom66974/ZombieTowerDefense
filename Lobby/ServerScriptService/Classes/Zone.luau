local Zone = {}
Zone.__index = Zone


-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")


-- Modules
local ZonePlus = require(ReplicatedStorage.Packages.Zone)


-- Variables
local COOLDOWN_DURATION = 10


-- Functions
function Zone.new(instance: Instance)
	
	local self = setmetatable({}, Zone)
	
	self._Instance = instance
	self._Spawn = instance.Spawn
	self._Walls = instance.Walls
	self._DetectPart = instance.Detect
	
	-- UI
	self._UI = instance.UI
	self._Gui = self._UI.Gui
	self._Header = self._Gui.Header
	self._DifficultyText = self._Gui.Difficulty
	self._MaxPlayersText = self._Gui.MaxPlayers
	self._CooldownText = self._Gui.Cooldown
	self._CooldownText.Visible = false
	
	self._OldPositions = {}
	self._MaxPlayers = 5
	self._Difficulty = "Easy"
	self._Players = {}
	self._CooldownActive = false
	
	self:UpdateUI() -- Update UI
	
	return self
	
end


function Zone:TeleportPlayers()
	local playersToTeleport = {}
	for _, userId: number in pairs(self._Players) do
		local player = Players:GetPlayerByUserId(userId)
		if player then
			table.insert(playersToTeleport, player)
		end
	end
	
	if #playersToTeleport < 1 then
		return false, "No players to teleport"
	end
	
	local reservedServerId = TeleportService:ReserveServerAsync(91007843896636)
	local options = Instance.new("TeleportOptions")
	
	options.ReservedServerId = reservedServerId
	options:SetTeleportData({
		Mode = "Basic",
		Difficulty = self._Difficulty,
	})
	
	local success, err = pcall(function()
		TeleportService:TeleportAsync(
			91007843896636,
			playersToTeleport,
			options
		)
	end)
	
	return success, err
end


function Zone:AddPlayer(player: Player)
	
	if table.find(self._Players, player.UserId) then
		return
	end
	
	local character = player.Character
	local spawnLocation = self._Spawn
	
	table.insert(self._Players, player.UserId)
	self._OldPositions[player] = character:GetPivot()
	character:PivotTo(spawnLocation.WorldCFrame)
	self:UpdateUI()
	
	if #self._Players >= 1 then
		task.spawn(function()
			self:StartCooldown()
		end)
	end
	
end


function Zone:RemovePlayer(player: Player)
	
	local currentPlayer = table.find(self._Players, player.UserId)
	if not currentPlayer then
		return
	end
	
	local character = player.Character
	
	table.remove(self._Players, currentPlayer)
	character:PivotTo(self._OldPositions[player] - Vector3.new(0, 0, 3))
	self._OldPositions[player] = nil
	self:UpdateUI()
	
	if #self._Players < 1 then
		self._CooldownActive = false
		self._CooldownText.Visible = false
	end
	
end


function Zone:StartCooldown()
	
	if self._CooldownActive then
		return
	end
	
	self._CooldownActive = true
	self._CooldownText.Visible = true
	
	for i = COOLDOWN_DURATION, 1, -1 do
		if not self._CooldownActive or #self._Players < 1 then
			self._CooldownText.Visible = false
			return
		end
		
		self._CooldownText.Text = "Start in: " .. i
		task.wait(1)
	end
	
	self._CooldownActive = false
	self._CooldownText.Visible = false
	
	local success, err = self:TeleportPlayers()
	if success then
		for _, userId: number in pairs(self._Players) do
			local avatar = self._Header:FindFirstChild(tostring(userId))
			if avatar then
				avatar:Destroy()
			end
		
			local player = Players:GetPlayerByUserId(userId)
			if player then
				self._OldPositions[player] = nil
			end
		end
		
		table.clear(self._Players)
		self:UpdateUI()
	else
		warn("Teleport failed:", tostring(err))
	end
	
end


function Zone:UpdateUI()
	
	self._DifficultyText.Text = "Difficulty: " .. self._Difficulty
	self._MaxPlayersText.Text = "Max Players: " .. self._MaxPlayers
	
	for _, avatarImage: ImageLabel in pairs(self._Header:GetChildren()) do
		if avatarImage.Name == "Template" then
			continue
		end
		
		local userId = tonumber(avatarImage.Name)
		if not userId then
			continue
		end
		
		if not table.find(self._Players, userId) then
			avatarImage:Destroy()
		end
	end
	
	for _, userId: number in pairs(self._Players) do
		local currentAvatar = self._Header:FindFirstChild(tostring(userId))
		if not currentAvatar then
			local thumbType = Enum.ThumbnailType.AvatarBust
			local thumbSize = Enum.ThumbnailSize.Size420x420
			local avatarImage, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
			
			local newAvatar = self._Header.Template:Clone()
			newAvatar.Name = tostring(userId)
			newAvatar.Image = avatarImage
			newAvatar.Visible = true
			newAvatar.Parent = self._Header
		end
	end
	
end


function Zone:Init()
	
	local detectZone = ZonePlus.new(self._DetectPart)
	
	detectZone.playerEntered:Connect(function(player: Player)
		if #self._Players >= self._MaxPlayers then
			return
		end
		
		if table.find(self._Players, player.UserId) then
			return
		end
		
		self:AddPlayer(player)
	end)
	
end


return Zone
