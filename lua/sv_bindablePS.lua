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
				ps_item = PS.Items[v]
				break
			end
		end
	else
		ps_item = PS.Items[item_net]
		print("by passing direct name")
	end
	if ps_item == nil then return end
	print(ps_item.Name .. " not nil, continuing")

	if ply:getBindCooldown() > 0 then
		print("Cooldown tolerated")
		net.Start("BindablePS_Cooldown")
		net.WriteInt(ply:getBindCooldown(),10)
		net.Send(ply)
		return 
	end

	if ply:PS_HasItemEquipped(ps_item.ID) then
		ply:PS_HolsterItem(ps_item.ID)
	end
	if ply:PS_HasItem(ps_item.ID)  then	
		print("Preparing for clusterfuck")

				for k,v in pairs(PS.Items) do
					if (v.WeaponClass ~= nil or v.Attachment ~= nil)  and v.Equiped == true then
						print("Same class, holstering")
						ply:PS_HolsterItem(v.ID)
					end
				end
				
			print("Equiping")
			ply:PS_EquipItem(ps_item.ID)
			if c_class then 
				ply:SelectWeapon(ps_item.WeaponClass)
				print("Is weapon, selecting")
			end
			print("Done")
			ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())
			return true	
	else
		print("Player does not have " .. ps_item.Name)
	end


end)


