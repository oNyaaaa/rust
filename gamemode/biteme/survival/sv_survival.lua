util.AddNetworkString("gRust_Survival")
timer.Create("GRust_Survival", 30, 0, function()
    for k, v in pairs(player.GetAll()) do
        v.Food = v.Food - 1
        v.Water = v.Water - 1
        net.Start("gRust_Survival")
        net.WriteFloat(v.Food)
        net.WriteFloat(v.Water)
        net.Send(v)
        if v.Food <= 0 and v.Water <= 0 then
            v:SetHealth(v:Health() - math.random(10, 15))
            if v:Alive() and v:Health() <= 0 then v:Kill() end
        end
    end
end)