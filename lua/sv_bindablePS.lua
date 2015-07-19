local meta = FindMetaTable( "Player" )

function meta:setBindCooldown(t)
	self.Cooldown = CurTime() + t
end

function meta:getBindCooldown()
	local left = self.Cooldown or CurTime()
	return left - CurTime()
end
function EquipBind(ply)
	if not ply:PS_CanPerformAction() then return end

	local item_net = net.ReadString()
	
	
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
	if !ply:PS_HasItem(ps_item.ID) then
		return
	end
	if ps_item == nil then return end

	if ply:getBindCooldown() > 0 then
		net.Start("BindablePS_Cooldown")
		net.WriteInt(ply:getBindCooldown(),10)
		net.Send(ply)
		return 
	end



	--ply:PS_TakeItem(ps_item.ID)
	--ply:PS_HolsterItem(ps_item.ID)
	--ply:PS_EquipItem(ps_item.ID)

	--todo
	--if equiped, holster and remove
	--If User has the weapon equipped. Holster
	if ply:PS_HasItemEquipped(ps_item.ID) then
		ply:PS_HolsterItem(ps_item.ID)
		--If Holster Unholster is enabled, we'll quit there
		if GetConVar("ps_bind_holsterunholster"):GetBool() then
			ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())
			return
		end

	end

	if ps_item.WeaponClass ~= nil and !ply:PS_HasItemEquipped(ps_item.ID) then

		// local torm = {}
		// for k,v in pairs(PS.Items) do
		// 	local p_weap = PS.Items[k]
		// 	if p_weap.WeaponClass ~= nil and ply:PS_HasItemEquipped(p_weap.iD) then
		// 		table.insert(torm, p_weap.WeaponClass)
		// 	end
		// end
		// --remove ammo
		// for r,o in pairs(ply:GetWeapons()) do
		// 	if Isvalid(o) then
		// 		if torm[o.ClassName] then
		// 			ply:RemoveAmmo(o.Ammo1(), o:GetPrimaryAmmoType() )
		// 		end
		// 	end
		
			--Player:RemoveAmmo( number ammoCount, string ammoName )
			--Player:GetWeapons()
		//end
		local fWeapInUse = false
		if IsValid(ply:GetActiveWeapon()) then
			--Helpful tid bit so it doesn't remove "Non Weapons" in the gamemode TTT
			if GetConVarString("gamemode") == "terrortown" then
				local ignore = { ["weapon_zm_improvised"]=true,["weapon_ttt_unarmed"]=true,["weapon_zm_carry"]=true,["weapon_ttt_wtester.lua"=true]}
				
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
			--If Category limit is 2
			--remove first Equipped item
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




	ply:PS_EquipItem(ps_item.ID)
	if GetConVar("ps_bind_autoswitch"):GetBool() and ps_item.WeaponClass ~= nil then 
		ply:SelectWeapon(ps_item.WeaponClass)
	end
	ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())


	return
end

net.Receive( "BindablePS_Request", function( len, ply )
	if !IsValid(ply) then return end
	if GetConVar("ps_bind_reservedranks"):GetBool() then
		local autolistranks = string.Split(GetConVar("ps_bind_allowedranks"):GetString(),",") or {} 
		if #autolistranks > 0
			for _,v in pairs(autolistranks) do
				if ply:PS_GetUsergroup() == string.Trim(v,",") then
					EquipBind(ply)
					return 
					
				end
			end
		end
	
		return
	else
		EquipBind(ply)
		return
	end
	


end)



