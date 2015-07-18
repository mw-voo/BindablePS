function BindablePS(ply,stz,args,argz)
	if !args[1] then return end
	print("Bind pressed")
	print(argz)
	net.Start("BindablePS_Request")
	net.WriteString(argz)
	net.SendToServer()
end

concommand.Add("ps_bind", BindablePS, nil,nil,1024)

net.Receive("BindablePS_Cooldown", function(len,ply)
	local coolleft = net.ReadInt(10) 
	chat.AddText("[BindablePS] Please wait " .. (math.Round(coolleft) or "{{<Error> (Net failed to send a proper number)}}") .. " more seconds before requesting this binded item.")

end)



