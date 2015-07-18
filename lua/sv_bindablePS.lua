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

	print("Preform 1")
	local item_net = net.ReadString()
	print("Item -> " .. item_net)

	local ps_item = nil
	if PS.Items[item_net] then
		ps_item = PS.Items[item_net]
		print("Direct Class Name")
	else
	--messy way of figuring out if the string is a item_id or a item  name
		for k,v in pairs(PS.Items) do
			if string.lower(PS.Items[k].Name) == string.lower(item_net) then
				print("Matched Named String ".. PS.Items[k].Name)
				ps_item = PS.Items[k]
				break
			end
		end
	end
	if !ply:PS_HasItem(ps_item.ID) then
		ply:PrintMessage(HUD_PRINTTALK,"You do not have that pointshop item!")
		return
	end
	if ps_item == nil then return end
	print("Named Success")

	if ply:getBindCooldown() > 0 then
		print("Cooldown Tolerated")
		net.Start("BindablePS_Cooldown")
		net.WriteInt(ply:getBindCooldown(),10)
		net.Send(ply)
		return 
	end


	print("Has Item")

	--ply:PS_TakeItem(ps_item.ID)
	--ply:PS_HolsterItem(ps_item.ID)
	--ply:PS_EquipItem(ps_item.ID)

	--todo
	--if equiped, holster and remove
	--If User has the weapon equipped. Holster
	if ply:PS_HasItemEquipped(ps_item.ID) then
		print("And Equipped, Holstering")
		ply:PS_HolsterItem(ps_item.ID)
		--If Holster Unholster is enabled, we'll quit there
		if GetConVar("ps_bind_holsterunholster"):GetBool() then
			print("Holster Unholster Set")
			ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())
			return
		end

	end
	local strip = function() print("Removing") ply:StripWeapon(ply:GetActiveWeapon().ClassName) end

	if ps_item.WeaponClass ~= nil and !ply:PS_HasItemEquipped(ps_item.ID) then	
		local fWeapInUse = false
		print("Non Pointshop Weapon")
		if IsValid(ply:GetActiveWeapon()) then
			--Helpful tid bit so it doesn't weapon "Non Weapons" in the gamemode TTT
			if GetConVarString("gamemode") == "terrortown" then
				local ignore = { ["weapon_zm_improvised"]=true,["weapon_ttt_unarmed"]=true,["weapon_zm_carry"]=true}
				
				for k,v in pairs(ignore) do
					if ply:GetActiveWeapon().ClassName == k then
						print("Found ignored weapon ->" .. k)
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
		print("Hat or Model or Misc")
		if ps_item.Attachment ~= nil or !ply:PS_HasItemEquipped(ps_item.ID) then
			print("Definttly one of those")
			--If Category limit is 2
			--remove first Equipped item
			local catid = PS:FindCategoryByName(ps_item.Category)
			if ply:PS_NumItemsEquippedFromCategory(PS:FindCategoryByName(ps_item.Category).Name) >= 2 then
				print("more then 2 items are equipped!")
				for k,v in pairs(PS.Items) do
					local itm = PS.Items[k]
					if itm.Attachment ~= nil and ply:PS_HasItemEquipped(itm.ID) then 
						print("Holstering .. ".. v.Name)
						ply:PS_HolsterItem(itm.ID)
					end
				end
			end
		end
	end




	ply:PS_EquipItem(ps_item.ID)
	print("Equipped Item")
	if GetConVar("ps_bind_autoswitch"):GetBool() and ps_item.WeaponClass ~= nil then 
		ply:SelectWeapon(ps_item.WeaponClass)
		print("Selected Weapon")
	end
	ply:setBindCooldown(GetConVar("ps_bind_cooldown"):GetInt())
	print("Finished!")


	return
end

net.Receive( "BindablePS_Request", function( len, ply )
	print("net Recieved")
	if !IsValid(ply) then return end
	if GetConVar("ps_bind_reservedranks"):GetBool() then
		print(GetConVar("ps_bind_allowedranks"):GetString())
		local autolistranks = string.Split(GetConVar("ps_bind_allowedranks"):GetString(),",") or {} 
		for _,v in pairs(autolistranks) do
			if ply:PS_GetUsergroup() == string.Trim(v,",") then
				print("Correct User Group")
				EquipBind(ply)
				return 
				
			end
		end
		ply:PrintMessage(HUD_PRINTTALK,"Unable to use BindablePS, not in the right usergroup!")
		return
	else
		EquipBind(ply)
		return
	end
	


end)



