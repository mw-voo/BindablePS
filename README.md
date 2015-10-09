Bindable Pointshop Items 
==============
By Voodoo(STEAM_0:1:28607710) 


To Install
==============

Drag and drop into garrysmod's addon folder
\GarrysMod\garrysmod\addons\

Note:
==============
This addon lets users bind equipable items to a key of their choice by typing in console: 

bind key "ps_bind weaponanmehere" 

For example, a user would type 

bind k "ps_bind ak47" 

Server Administrators/Owners have several cvars that can be changed 
cvar, default value, description 

ps_bind_cooldown , 30 , changes the cooldown to reuse the bind (in seconds) 
ps_bind_allowedranks, user, The allowed ranks to use the bind if ps_bind_reservedranks is set to 1. User means all. 
ps_bind_reservedranks, 0, If set to 1, limits access to the bind for a specific ranks 
ps_bind_autoswitch, 1, If set to 1, automatically switches to the binded weapon (Instead of just giving it) 
ps_bind_holsterunholster, 0, If set to 1, users with the item out will only holster and will not re-equip when called. 


An example configution would be: 

ps_bind_cooldown 45 
ps_bind_allowedranks donator,moderator,admin,superadmin,owner 
ps_reservedranks 1 
ps_bind_autoswitch 1 
ps_bind holsterunholster 0 

==============




