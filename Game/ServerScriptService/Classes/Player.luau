local Player = {}
Player.__index = Player


-- Functions
function Player.new(player: Player)
	
	local self = setmetatable({}, Player)
	
	self._Player = player
	self._Data = {}
	
	return self	
	
end


return Player
