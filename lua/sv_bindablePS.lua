

net.Receive( "BindablePS_Request", function( len, ply )
	if !IsValid(ply) then return end
	if not ply:PS_CanPerformAction() then return false end
	local ps_item = net.ReadString()

	if ply:getBindCooldown() > 0 then
		net.Start("BindablePS_Cooldown")
		net.WriteInt(ply:getBindCooldown(),10)
		net.Send(ply)
		return 
	end

	--math.Round(ply:getTransferCooldown())
	if ply:PS_HasItem(ps_item)  then	
	--and !ply:PS_HasItemEquipped(ps_item)	
				local c_class = nil

				if PS.Items[ps_item].WeaponClass ~= nil then
					c_class = true
				elseif PS.Items[ps_item].Attachment ~= nil then
					c_class = false
				else
					c_class = nil
				end


				for k,v in pairs(PS.Items) do
					local itm = v
					if itm.WeaponClass ~= nil and itm.Equiped == true and c_class then
						ply:PS_HolsterItem(itm)

					elseif itm.Attachment ~= nil and itm.Equiped == true and !c_class then
						ply:PS_HolsterItem(itm)
					end
				end
				

			ply:PS_EquipItem(ps_item)
			ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())
			return true	
	else
	end


end)