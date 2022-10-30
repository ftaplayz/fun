getgenv().range = 500;
getgenv().timeKillDef = 5;

local rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))();
local window = rayfield:CreateWindow({
	Name = "Bad anime game simulator",
	LoadingTitle = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)["Name"],
	LoadingSubtitle = "by fta",
	ConfigurationSaving = {
		Enabled = true,
		FileName = "bad anime game"
	},
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Sirius Hub",
		Subtitle = "Key System",
		Note = "Join the discord (discord.gg/sirius)",
		Key = "ABCDEF"
	}
});

local farm = window:CreateTab("Farm");
local options = window:CreateTab("Player");
--local stats = window:CreateTab("Info");
local misc = window:CreateTab("Misc");

--farm
farm:CreateSection("Single mob");

farm:CreateSection("All");

local names = {};
for _,v in ipairs(workspace.__WORKSPACE.Areas:GetChildren()) do
    if not string.match(v.Name, "Tree") then
        table.insert(names, v.Name);
    end
end
getgenv().zoneAll = names[1];
farm:CreateDropdown({
    Name = "Zone",
    Options = names,
    CurrentOption = names[1],
    Flag = "mobszone",
    Callback = function(zone)
        if workspace.__WORKSPACE.Mobs:FindFirstChild(zone) then
            getgenv().zoneAll = zone;
        else
            rayfield:Notify("Zone not loaded.","The selected zone doesn't seem to be loaded please get closer to it.");
        end
    end
});
farm:CreateToggle({
    Name = "Farm",
    CurrentValue = false,
    Flag = "farmAll",
    Callback = function(state)
        getgenv().allFarmState = state;
        if getgenv().allFarmState then
            if workspace.__WORKSPACE.Mobs:FindFirstChild(getgenv().zoneAll) then
                for _,v in ipairs(workspace.__WORKSPACE.Mobs:FindFirstChild(getgenv().zoneAll):GetChildren()) do
                    local func;
                    func = v.HumanoidRootPart:GetPropertyChangedSignal("Position"):Connect(function()
                        while tonumber(string.match(v.Head.UID.Frame.Frame.UID.Text, "%d+")) > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= getgenv().range and getgenv().allFarmState == true do
                            game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"AttackMob",v, v.Torso});
                            task.wait();
                        end
                    end)
                    coroutine.wrap(function()
                        while tonumber(string.match(v.Head.UID.Frame.Frame.UID.Text, "%d+")) > 0 and getgenv().allFarmState do
                            game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"AttackMob",v, v.Torso});
                            task.wait();
                        end
                    end)();
                end
            else
                rayfield:Notify("Zone wasn't found.","The zone isn't loaded, please get closer to it.");
            end
        end
    end
});

farm:CreateSection("Auto Defense");
getgenv().autoDef = false;
farm:CreateToggle({
    Name = "Kill mobs",
    CurrentValue = false,
    Flag = "autoWave",
    Callback = function(state)
        getgenv().autoDef = state;
        if getgenv().autoDef then
            for _, v in ipairs(workspace.__WORKSPACE.Mobs:GetChildren()) do
                if string.match(v.Name, "Defense") then
                    rayfield:Notify("Auto Defense", "Currently farming zone: "..v.Name);
                    local func;
                    func = v.ChildAdded:Connect(function(mob)
                        mob:WaitForChild("Head");
                        task.wait(getgenv().timeKillDef);
                        while tonumber(string.match(mob.Head.UID.Frame.Frame.UID.Text, "%d+")) > 0 and getgenv().autoDef == true do
                            game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"AttackMob",mob, mob.Torso});
                            task.wait();
                        end
                        if getgenv().autoDef == false then
                            func:Disconnect();
                        end
                    end)
                    for i, mob in ipairs(v:GetChildren()) do
                        coroutine.wrap(function()
                            while tonumber(string.match(mob.Head.UID.Frame.Frame.UID.Text, "%d+")) > 0 and getgenv().autoDef == true do
                                game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"AttackMob",mob, mob.Torso});
                                task.wait();
                            end
                        end)();
                    end
                    break;
                end
            end
        end
    end
});


farm:CreateSection("Options");
local power = coroutine.create(function()
    while task.wait(0.04) do
        game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"PowerTrain"});
        if getgenv().aP == false then
            coroutine.yield()
        end
    end
end);
local autoPower = farm:CreateToggle({
    Name = "Auto power",
    CurrentValue = false,
    Flag = "autoPower",
    Callback = function(val)
        getgenv().aP = val;
        if val then
            coroutine.resume(power);
        end
    end
});
local collectCoin = farm:CreateToggle({
    Name = "Collect coins",
    CurrentValue = false,
    Flag = "collectCoins",
    Callback = function(val)
        if val then
            getgenv().coinFarm = workspace.__DROPS.ChildAdded:Connect(function(coin)
                game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"DropCollect",coin.Name})
                coin:Destroy()
            end)
            for i,v in ipairs(workspace.__DROPS:GetChildren()) do
                game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"DropCollect",v.Name});
                v:Destroy();
            end
        else
            getgenv().coinFarm:Disconnect();
        end
    end
});
local rangeFarm = farm:CreateSlider({
	Name = "Farm range",
	Range = {0, 5000},
	Increment = 100,
	Suffix = "Range",
	CurrentValue = 500,
	Flag = "rangeSlider",
	Callback = function(val)
        getgenv().range = val;
	end,
});
farm:CreateToggle({
    Name = "Disable effects",
    CurrentValue = false,
    Flag = "noeffect",
    Callback = function(state)
        getgenv().hitEffect = state;
        if getgenv().hitEffect then
            getgenv().effectCon = workspace.__DEBRIS.ChildAdded:Connect(function(effect)
                if effect.Name == "PunchEffectDamage" or effect.Name == "PunchEffect" then
                    effect:Destroy();
                end
            end);
        else
            getgenv().effectCon:Disconnect();
        end
    end
});
farm:CreateSlider({
    Name = "Auto defense delay to kill",
    Range = {0, 30},
    Increment = 1,
    Suffix = "timerDef",
    CurrentValue = 5,
    Flag = "defTimerSlider",
    Callback = function(val)
        getgenv().timeKillDef = val;
    end
})

farm:CreateSection("Stats");
local rankupReq = farm:CreateParagraph({Title = "Stats required for rank up", Content = game:GetService("Players").LocalPlayer.PlayerGui.UI.CenterFrame["Rank Up"].Frame.CostPower.UID.Text.."\n"..game:GetService("Players").LocalPlayer.PlayerGui.UI.CenterFrame["Rank Up"].Frame.CostCoins.UID.Text});
local changeName = game:GetService("Players").LocalPlayer.PlayerGui.UI.CenterFrame["Rank Up"].Frame.CostPower.UID:GetPropertyChangedSignal("Text"):Connect(function()
    rankupReq:Set({Title = "Stats required for rank up", Content = game:GetService("Players").LocalPlayer.PlayerGui.UI.CenterFrame["Rank Up"].Frame.CostPower.UID.Text.."\n"..game:GetService("Players").LocalPlayer.PlayerGui.UI.CenterFrame["Rank Up"].Frame.CostCoins.UID.Text});
end)
farm:CreateButton({
    Name = "Rank up",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"RankUp"});
    end
});

--options
local guis = options:CreateSection("GUIs");
local function newButton(name, path) -- button create function for gui
    options:CreateButton({
        Name = name,
        Callback = function()
            game:GetService("Players").LocalPlayer.PlayerGui.UI.CenterFrame[path].Visible = game:GetService("Players").LocalPlayer.PlayerGui.UI.CenterFrame[path].Visible == false and true or false
            game:GetService("Players").LocalPlayer.PlayerGui.UI.CenterFrame[path].Position = UDim2.new(-4,0,-2,0)
        end
    });
end
newButton("Avatar", "Avatars");
newButton("Fuse", "Fuse");
newButton("Aura", "Auras");
newButton("Weapon", "Weapons");
newButton("Grimoires", "Grimoires");
newButton("Exchange", "Exchange");
newButton("Status", "Status");
newButton("Passive", "Passive");

options:CreateSection("Zones");
options:CreateDropdown({
    Name = "Teleport",
    Options = names,
    CurrentOption = names[1],
    Flag = "tp",
    Callback = function(opt)
        if workspace.__WORKSPACE.Areas:FindFirstChild(opt) then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.__WORKSPACE.Areas[opt].Point.CFrame;
        end
    end
});


--infoinfo:create

--misc
misc:CreateButton({
    Name = "Anti-afk",
    Callback = function()
        for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
            v:Disable();
        end        
    end
});
misc:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        getgenv().autoDef = false;
        getgenv().aP = false;
        if getgenv().coinFarm then
            getgenv().coinFarm:Disconnect();
        end
        changeName:Disconnect();
        if getgenv().effectCon then 
            getgenv().effectCon:Disconnect(); 
        end
        rayfield:Destroy();
    end
});

--rayfield:LoadConfiguration()