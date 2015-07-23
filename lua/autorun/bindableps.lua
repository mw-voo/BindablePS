if SERVER then

	util.AddNetworkString("BindablePS_Cooldown")
	util.AddNetworkString("BindablePS_Request")

	AddCSLuaFile()
	AddCSLuaFile("cl_bindableps.lua")
	include("sv_bindableps.lua")

	CreateConVar("ps_bind_cooldown", 30, 1408, "Changes the cooldown time to use a pointshop bind")


	CreateConVar("ps_bind_allowedranks", "", 1408, "The specific ranks that are allowed if reservedranks are enabled.")


	CreateConVar("ps_bind_reservedranks", 0, 1408, "Enable/disable the ps_bind command to specific ranks")


	CreateConVar("ps_bind_autoswitch", 1,1408, "Allows to autoswitch to the binded weapon OnEquip")


	CreateConVar("ps_bind_holsterunholster",0, 1408, "If set to 1, users with the item out will only holster and will not re-equip when called.")
	
end
if CLIENT then
	include("cl_bindableps.lua")
end
print("Registered BindablePS - By Voodoo(STEAM_0:1:28607710)")
