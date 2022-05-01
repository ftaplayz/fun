local plrs = game:GetService("Players")
local human = plrs.LocalPlayer.Character.Humanoid
for i,v in ipairs(workspace:GetDescendants()) do
    if(v:IsA("Tool") and v:FindFirstChild("Handle") and v:FindFirstChild("Decay")) then
        v.Handle.CFrame = plrs.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
    if(v.Parent.Parent.Name == "Barrels" and v:FindFirstChild("ClickDetector"))then
        if(v.ClickDetector.MaxActivationDistance>0)then
            fireclickdetector(v.ClickDetector)
        end
    end
    if(v.Name == "Mixer1" or v.Name == "Mixer2")then
        fireclickdetector(v.ClickDetector)
        wait(3)
        for i,v in ipairs(plrs.LocalPlayer.Backpack:GetChildren()) do
            if(string.match(v.Name, "[%a+]%sJuice$") or string.match(v.Name, "[%a+]%sMilk$") or v.Name == "Lemonade" or v.Name == "Juice" or v.Name == "Smoothie" or v.Name == "Cider")then
                human:EquipTool(v)
                v:Activate()
            end
        end
    end
end
