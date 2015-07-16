local meta = FindMetaTable( "Player" )

function meta:setBindCooldown(t)
	self.Cooldown = CurTime() + t
end

function meta:getBindCooldown()
	local left = self.Cooldown or CurTime()
	return left - CurTime()
end
