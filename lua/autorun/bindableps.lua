if SERVER then

	util.AddNetworkString("BindablePS_Cooldown")
	util.AddNetworkString("BindablePS_Request")
	
	AddCSLuaFile()
	AddCSLuaFile("cl_bindableps.lua")
	CreateConVar("ps_bind_cooldown", 15, _, "Changes the cooldown time to use a pointshop bind")
	include("sv_bindablePSext.lua")
	include("sv_bindablePS.lua")
	MsgAll("Registered bindable_pointshop - By Voodoo(STEAM_0:1:28607710)")
end
if CLIENT then
	include("cl_bindablePS.lua")
end
