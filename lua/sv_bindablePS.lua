local meta = FindMetaTable( "Player" )

function meta:setBindCooldown(t)
	self.Cooldown = CurTime() + t
end

function meta:getBindCooldown()
	local left = self.Cooldown or CurTime()
	return left - CurTime()
end

net.Receive( "BindablePS_Request", function( len, ply )
	print("net Recieved")
	if !IsValid(ply) then return end
	if not ply:PS_CanPerformAction() then return false end

	print("Can Preform")
	local item_net = net.ReadString()
	print("net msg -> " .. item_net)
	local ps_item = nil
	--messy way of figuring out if the string is a item_id or a item  name
	if !PS.Items[item_net] then
		for _,v in pairs(PS.Items) do
			if string.lower(v.Name) == string.lower(item_net) then
				print("Found a match for set ".. v.Name)
				ps_item = v
				break
			end
		end
	else
		ps_item = item_net
	end
	if ps_item == nil then return end
	print("Item not nil, continuing")

	if ply:getBindCooldown() > 0 then
		net.Start("BindablePS_Cooldown")
		net.WriteInt(ply:getBindCooldown(),10)
		net.Send(ply)
		return 
	end

	if ply:PS_HasItem(ps_item)  then	
		print("Preparing for clusterfuck")
				local c_class = nil
				if ps_item.WeaponClass ~= nil then
					c_class = true
				elseif ps_item.Attachment ~= nil then
					c_class = false
				else
					c_class = nil
				end
				print("c_class == " .. c_class)
				for k,v in pairs(PS.Items) do
					if (v.WeaponClass ~= nil or v.Attachment ~= nil  and v.Equiped == true and c_class or !c_class) then
						print("Same class, holstering")
						ply:PS_HolsterItem(v)
					end
				end
				
			print("Equiping")
			ply:PS_EquipItem(ps_item)
			if c_class then 
				ply:SelectWeapon(ps_item.WWeaponClass)
				print("Is weapon, selecting")
			end
			print("Done")
			ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())
			return true	
	else
	end


end)