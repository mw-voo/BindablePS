local cd = false
--bind x ps_weaponname
function BindablePS(ply,stz,args,argz)
	if !args[1] then return end
	local tmp = args[1] or "nil"
	net.Start("BindablePS_Request")
	net.WriteString(tmp)
	net.SendToServer()
end

concommand.Add("ps_bind", BindablePS, _,_,_)

net.Receive("BindablePS_Cooldown", function(len,ply)
	local coolleft = net.ReadInt(10) 
	chat.AddText("[BindablePS] Please wait " .. (math.Round(coolleft) or "{{<Error> (Net failed to send a proper number)}}") .. " more seconds before requesting this binded item.")

end)

