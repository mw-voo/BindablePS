local meta = FindMetaTable( "Player" )

function meta:setBindCooldown(t)
	self.Cooldown = CurTime() + t
end

function meta:getBindCooldown()
	local left = self.Cooldown or CurTime()
	return left - CurTime()
end


function EquipBind(ply,item_net)
	if not ply:PS_CanPerformAction() then return end

	local ps_item = nil
	if PS.Items[item_net] then
		ps_item = PS.Items[item_net]
	else
	--messy way of figuring out if the string is a item_id or a item  name
		for k,v in pairs(PS.Items) do
			if string.lower(PS.Items[k].Name) == string.lower(item_net) then
				ps_item = PS.Items[k]
				break
			end
		end
	end
	if ps_item == nil then ply:PrintMessage("Invaild Weapon keyed!") return end
	if !ply:PS_HasItem(ps_item.ID) then
		ply:PrintMessage(HUD_PRINTTALK,"You do not have that pointshop item!")
		return
	end
	

	if ply:getBindCooldown() > 0 then
		net.Start("BindablePS_Cooldown")
		net.WriteInt(ply:getBindCooldown(),10)
		net.Send(ply)
		return 
	end
	if ply:PS_HasItemEquipped(ps_item.ID) then
		ply:PS_HolsterItem(ps_item.ID)
		if GetConVar("ps_bind_holsterunholster"):GetBool() then
			ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())
			return
		end

	end

	if ps_item.WeaponClass ~= nil and !ply:PS_HasItemEquipped(ps_item.ID) then
		local fWeapInUse = false
		if IsValid(ply:GetActiveWeapon()) then
			--Helpful tid bit so it doesn't remove "Non Weapons" in the gamemode TTT
			if GetConVarString("gamemode") == "terrortown" then
				local ignore = { ["weapon_zm_improvised"]=true,["weapon_ttt_unarmed"]=true,["weapon_zm_carry"]=true,["weapon_ttt_wtester.lua"]=true}
				
				for k,v in pairs(ignore) do
					if ply:GetActiveWeapon().ClassName == k then
						fWeapInUse = true
						break
					end
				end
				if !fWeapInUse then
					strip()
				end
			else
				strip()
			end

		end
	else
		if ps_item.Attachment ~= nil or !ply:PS_HasItemEquipped(ps_item.ID) then
			local catid = PS:FindCategoryByName(ps_item.Category)
			if ply:PS_NumItemsEquippedFromCategory(PS:FindCategoryByName(ps_item.Category).Name) >= 2 then
				for k,v in pairs(PS.Items) do
					local itm = PS.Items[k]
					if itm.Attachment ~= nil and ply:PS_HasItemEquipped(itm.ID) then 
						ply:PS_HolsterItem(itm.ID)
					end
				end
			end
		end
	end



	ply:PrintMessage(HUD_PRINTTALK, "Equipped")
	ply:PS_EquipItem(ps_item.ID)
	if GetConVar("ps_bind_autoswitch"):GetBool() and ps_item.WeaponClass ~= nil then 
		ply:SelectWeapon(ps_item.WeaponClass)
	end
	ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())


	return
end

net.Receive( "BindablePS_Request", function( len, ply )
	if !IsValid(ply) then return end
	local item_net = net.ReadString()
	if GetConVar("ps_bind_reservedranks"):GetBool() then
		local autolistranks = string.Split(GetConVar("ps_bind_allowedranks"):GetString(),",") or {} 

		if #autolistranks > 0 then
			if autolistranks[1] == "user" then
				EquipBind(ply,item_net)
				return
			end
			for _,v in pairs(autolistranks) do
				if ply:PS_GetUsergroup() == string.Trim(v,",") then
					EquipBind(ply, item_net)
					return 
					
				end
			end
		else
			EquipBind(ply, item_net)
			return
		end
	
		ply:PrintMessage(HUD_PRINTTALK,"Unable to use BindablePS, not in the right usergroup!")
		return
	else
		EquipBind(ply,item_net)
		return
	end

	


end)



