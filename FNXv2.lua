--==================================================
-- FNX HUB
-- WindUI + Circular Startup + FPS/Ping + Fully Stabilized Backend
-- Improved: Hitbox Expander + Wide Attack Aura
--==================================================

local COVER_IMAGE = "rbxassetid://76267707023968"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--==================================================
-- STARTUP
--==================================================

local SplashGui = Instance.new("ScreenGui")
SplashGui.Name = "FNX_Startup"
SplashGui.IgnoreGuiInset = true
SplashGui.ResetOnSpawn = false
SplashGui.DisplayOrder = 999
SplashGui.Parent = PlayerGui

local Background = Instance.new("Frame")
Background.Size = UDim2.fromScale(1, 1)
Background.BackgroundColor3 = Color3.fromRGB(5, 10, 22)
Background.BorderSizePixel = 0
Background.Parent = SplashGui

local Container = Instance.new("Frame")
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.Position = UDim2.fromScale(0.5, 0.5)
Container.Size = UDim2.fromOffset(300, 320)
Container.BackgroundTransparency = 1
Container.Parent = Background

--==================================================
-- CIRCULAR LOGO
--==================================================

local Logo = Instance.new("ImageLabel")
Logo.AnchorPoint = Vector2.new(0.5, 0)
Logo.Position = UDim2.new(0.5, 0, 0, 0)
Logo.Size = UDim2.fromOffset(155, 155)
Logo.BackgroundTransparency = 1
Logo.Image = COVER_IMAGE
Logo.ScaleType = Enum.ScaleType.Crop
Logo.Parent = Container

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = Logo

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Thickness = 3
LogoStroke.Color = Color3.fromRGB(255, 255, 255)
LogoStroke.Transparency = 0.05
LogoStroke.Parent = Logo

--==================================================
-- TEXT
--==================================================

local StudioName = Instance.new("TextLabel")
StudioName.AnchorPoint = Vector2.new(0.5, 0)
StudioName.Position = UDim2.new(0.5, 0, 0, 175)
StudioName.Size = UDim2.fromOffset(280, 45)
StudioName.BackgroundTransparency = 1
StudioName.Font = Enum.Font.GothamBold
StudioName.Text = "FENRIX"
StudioName.TextSize = 30
StudioName.TextColor3 = Color3.fromRGB(255, 255, 255)
StudioName.Parent = Container

local HubName = Instance.new("TextLabel")
HubName.AnchorPoint = Vector2.new(0.5, 0)
HubName.Position = UDim2.new(0.5, 0, 0, 220)
HubName.Size = UDim2.fromOffset(280, 40)
HubName.BackgroundTransparency = 1
HubName.Font = Enum.Font.GothamMedium
HubName.Text = "FNX HUB"
HubName.TextSize = 22
HubName.TextColor3 = Color3.fromRGB(190, 210, 255)
HubName.Parent = Container

--==================================================
-- WAIT & FADE OUT
--==================================================

task.wait(2.5)

local FadeInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(Background, FadeInfo, {BackgroundTransparency = 1}):Play()
TweenService:Create(Logo, FadeInfo, {ImageTransparency = 1}):Play()
TweenService:Create(LogoStroke, FadeInfo, {Transparency = 1}):Play()
TweenService:Create(StudioName, FadeInfo, {TextTransparency = 1}):Play()

local HubFade = TweenService:Create(HubName, FadeInfo, {TextTransparency = 1})
HubFade:Play()
HubFade.Completed:Wait()

SplashGui:Destroy()
task.wait(0.15)

--==================================================
-- WINDUI
--==================================================

local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

--==================================================
-- CONTAINER GUIS
--==================================================

local EspGui = Instance.new("ScreenGui")
EspGui.Name = "FNX_EspContainer"
EspGui.ResetOnSpawn = false
EspGui.IgnoreGuiInset = true
EspGui.Parent = PlayerGui

local PerformanceGui = Instance.new("ScreenGui")
PerformanceGui.Name = "FNX_PerformanceOverlay"
PerformanceGui.IgnoreGuiInset = true
PerformanceGui.ResetOnSpawn = false
PerformanceGui.DisplayOrder = 100
PerformanceGui.Parent = PlayerGui

local PerformanceFrame = Instance.new("Frame")
PerformanceFrame.AnchorPoint = Vector2.new(1, 0)
PerformanceFrame.Position = UDim2.new(1, -12, 0, 12)
PerformanceFrame.Size = UDim2.fromOffset(125, 48)
PerformanceFrame.BackgroundColor3 = Color3.fromRGB(7, 15, 30)
PerformanceFrame.BackgroundTransparency = 0.1
PerformanceFrame.BorderSizePixel = 0
PerformanceFrame.Parent = PerformanceGui

local PerformanceCorner = Instance.new("UICorner")
PerformanceCorner.CornerRadius = UDim.new(0, 8)
PerformanceCorner.Parent = PerformanceFrame

local PerformanceStroke = Instance.new("UIStroke")
PerformanceStroke.Thickness = 1.5
PerformanceStroke.Color = Color3.fromRGB(255, 255, 255)
PerformanceStroke.Transparency = 0.15
PerformanceStroke.Parent = PerformanceFrame

local PerformanceText = Instance.new("TextLabel")
PerformanceText.Size = UDim2.fromScale(1, 1)
PerformanceText.BackgroundTransparency = 1
PerformanceText.Font = Enum.Font.GothamBold
PerformanceText.TextSize = 12
PerformanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
PerformanceText.Text = "FPS: 0\nPing: 0 ms"
PerformanceText.TextXAlignment = Enum.TextXAlignment.Center
PerformanceText.TextYAlignment = Enum.TextYAlignment.Center
PerformanceText.Parent = PerformanceFrame

--==================================================
-- STATE MANAGEMENT & PRESETS
--==================================================

local ShowFPSOverlay = true
local ShowPingOverlay = true
local ShowOverlay = true

local PositionPresets = {
    ["Top Right"] = { Pos = UDim2.new(1, -12, 0, 12), Anchor = Vector2.new(1, 0) },
    ["Top Left"] = { Pos = UDim2.new(0, 12, 0, 12), Anchor = Vector2.new(0, 0) },
    ["Bottom Right"] = { Pos = UDim2.new(1, -12, 1, -12), Anchor = Vector2.new(1, 1) },
    ["Bottom Left"] = { Pos = UDim2.new(0, 12, 1, -12), Anchor = Vector2.new(0, 1) },
}

local SizePresets = {
    ["Small"] = { Size = UDim2.fromOffset(125, 48), TextSize = 12 },
    ["Medium"] = { Size = UDim2.fromOffset(145, 55), TextSize = 14 },
    ["Large"] = { Size = UDim2.fromOffset(165, 65), TextSize = 16 },
}

local CurrentFPS = 0
local FrameCount = 0
local LastFPSUpdate = tick()

RunService.RenderStepped:Connect(function()
    FrameCount += 1
    local Now = tick()
    if Now - LastFPSUpdate >= 1 then
        CurrentFPS = FrameCount
        FrameCount = 0
        LastFPSUpdate = Now
    end
end)

local function GetPing()
    local Ping = 0
    pcall(function()
        Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    return Ping
end

task.spawn(function()
    while PerformanceGui and PerformanceGui.Parent do
        local Ping = GetPing()
        local textLines = {}

        if ShowFPSOverlay then table.insert(textLines, "FPS: " .. tostring(CurrentFPS)) end
        if ShowPingOverlay then table.insert(textLines, "Ping: " .. tostring(Ping) .. " ms") end

        PerformanceText.Text = #textLines > 0 and table.concat(textLines, "\n") or "Overlay Off"
        task.wait(0.5)
    end
end)

--==================================================
-- MAIN WINDOW & KEYBIND MANAGER
--==================================================

local Window = WindUI:CreateWindow({
    Title = "FNX HUB",
    Subtitle = "FENRIX",
    OpenButton = {
        Title = "FNX HUB",
        Icon = COVER_IMAGE,
        Color = ColorSequence.new(
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 255, 255)
        ),
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
    },
})

local CurrentKeybind = Enum.KeyCode.RightShift

local function ToggleWindow()
    if Window then
        if Window.Toggle then
            Window:Toggle()
        elseif Window.Main then
            Window.Main.Visible = not Window.Main.Visible
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == CurrentKeybind then
        ToggleWindow()
    end
end)

--==================================================
-- HOME
--==================================================

local HomeTab = Window:Tab({
    Title = "Home",
    Icon = "home",
})

HomeTab:Section({
    Title = "Performance",
})

local FPSParagraph = HomeTab:Paragraph({
    Title = "FPS",
    Desc = "FPS: 0",
})

local PingParagraph = HomeTab:Paragraph({
    Title = "Ping",
    Desc = "Ping: 0 ms",
})

local MemoryParagraph = HomeTab:Paragraph({
    Title = "Memory",
    Desc = "Memory: 0 MB",
})

HomeTab:Section({
    Title = "Status",
})

HomeTab:Paragraph({
    Title = "FNX HUB",
    Desc = "Clean • Simple • Modern • Enhanced",
})

task.spawn(function()
    while PerformanceGui and PerformanceGui.Parent do
        local Ping = GetPing()
        local Memory = 0

        pcall(function()
            Memory = math.floor(Stats:GetTotalMemoryUsageMb())
        end)

        pcall(function()
            FPSParagraph:SetDesc("FPS: " .. tostring(CurrentFPS))
            PingParagraph:SetDesc("Ping: " .. tostring(Ping) .. " ms")
            MemoryParagraph:SetDesc("Memory: " .. tostring(Memory) .. " MB")
        end)

        task.wait(1)
    end
end)

--==================================================
-- ASSIST
--==================================================

local AssistTab = Window:Tab({
    Title = "Assist",
    Icon = "gauge",
})

AssistTab:Section({
    Title = "Performance",
})

AssistTab:Toggle({
    Title = "FPS Boost",
    Default = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.Material = Enum.Material.SmoothPlastic
                    elseif obj:IsA("PostEffect") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = false
                    end
                end
            end)
        end
    end,
})

AssistTab:Toggle({
    Title = "FPS Counter",
    Default = true,
    Callback = function(Value)
        ShowFPSOverlay = Value
    end,
})

AssistTab:Toggle({
    Title = "Ping Counter",
    Default = true,
    Callback = function(Value)
        ShowPingOverlay = Value
    end,
})

AssistTab:Toggle({
    Title = "Show Overlay",
    Default = true,
    Callback = function(Value)
        ShowOverlay = Value
        PerformanceFrame.Visible = Value
    end,
})

AssistTab:Dropdown({
    Title = "FPS Target",
    Values = {
        "30 FPS",
        "60 FPS",
        "90 FPS",
        "120 FPS",
        "144 FPS",
        "165 FPS",
        "240 FPS",
    },
    Value = "60 FPS",
    Callback = function(Value)
        local cap = tonumber(string.match(Value, "%d+"))
        if cap and setfpscap then
            pcall(setfpscap, cap)
        end
    end,
})

AssistTab:Dropdown({
    Title = "Overlay Position",
    Values = {
        "Top Right",
        "Top Left",
        "Bottom Right",
        "Bottom Left",
    },
    Value = "Top Right",
    Callback = function(Value)
        local preset = PositionPresets[Value]
        if preset then
            PerformanceFrame.Position = preset.Pos
            PerformanceFrame.AnchorPoint = preset.Anchor
        end
    end,
})

AssistTab:Dropdown({
    Title = "Overlay Size",
    Values = {
        "Small",
        "Medium",
        "Large",
    },
    Value = "Small",
    Callback = function(Value)
        local preset = SizePresets[Value]
        if preset then
            PerformanceFrame.Size = preset.Size
            PerformanceText.TextSize = preset.TextSize
        end
    end,
})

AssistTab:Section({
    Title = "Assist",
})

for _, Name in ipairs({
    "Sprint Assist",
    "Jump Assist",
    "Movement Assist",
    "Camera Assist",
    "Interaction Assist",
}) do
    AssistTab:Toggle({
        Title = Name,
        Default = false,
        Callback = function(Value)
            print(Name .. ":", Value)
        end,
    })
end

--==================================================
-- COMBAT (Improved + Hitbox + Aura)
--==================================================

local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "swords",
})

-- ===== HITBOX EXPANDER =====
local HitboxSettings = {
    Enabled = false,
    Scale = 2.5,
    Transparency = 0.7,
    Color = Color3.fromRGB(255, 50, 50),
}

local HitboxPart = nil
local HitboxWeld = nil

local function ClearHitbox()
    if HitboxPart then
        pcall(function() HitboxPart:Destroy() end)
        HitboxPart = nil
    end
    if HitboxWeld then
        pcall(function() HitboxWeld:Destroy() end)
        HitboxWeld = nil
    end
end

local function ApplyHitbox()
    ClearHitbox()
    if not HitboxSettings.Enabled then return end

    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    HitboxPart = Instance.new("Part")
    HitboxPart.Name = "FNX_Hitbox"
    HitboxPart.Size = Vector3.new(4, 6, 2) * HitboxSettings.Scale
    HitboxPart.Transparency = HitboxSettings.Transparency
    HitboxPart.Color = HitboxSettings.Color
    HitboxPart.Material = Enum.Material.Neon
    HitboxPart.CanCollide = false
    HitboxPart.CanQuery = true
    HitboxPart.Massless = true
    HitboxPart.Anchored = false
    HitboxPart.Parent = char

    HitboxWeld = Instance.new("WeldConstraint")
    HitboxWeld.Part0 = hrp
    HitboxWeld.Part1 = HitboxPart
    HitboxWeld.Parent = HitboxPart

    HitboxPart.CFrame = hrp.CFrame
end

CombatTab:Section({
    Title = "Hitbox Expander (ขยายตัวละคร)",
})

CombatTab:Toggle({
    Title = "Enable Hitbox Expander",
    Default = false,
    Callback = function(Value)
        HitboxSettings.Enabled = Value
        if Value then
            ApplyHitbox()
        else
            ClearHitbox()
        end
    end,
})

CombatTab:Slider({
    Title = "Hitbox Scale",
    Step = 0.1,
    Value = {
        Min = 1,
        Max = 5,
        Default = 2.5,
    },
    Callback = function(Value)
        HitboxSettings.Scale = Value
        if HitboxSettings.Enabled then
            ApplyHitbox()
        end
    end,
})

-- ===== ATTACK AURA =====
local AuraSettings = {
    Enabled = false,
    Range = 25,
    Damage = 15,
    Interval = 0.35,
    Critical = true,
    CritChance = 25, -- %
    CritMultiplier = 2.0,
}

local LastAuraHit = 0

local function DoAuraAttack()
    if not AuraSettings.Enabled then return end
    if tick() - LastAuraHit < AuraSettings.Interval then return end

    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local myPos = hrp.Position
    local hitCount = 0

    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer \~= Player and targetPlayer.Character then
            local targetChar = targetPlayer.Character
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar:FindFirstChildOfClass("Humanoid")

            if targetHRP and targetHum and targetHum.Health > 0 then
                local dist = (targetHRP.Position - myPos).Magnitude
                if dist <= AuraSettings.Range then
                    local damage = AuraSettings.Damage
                    local isCrit = false

                    if AuraSettings.Critical and math.random(1, 100) <= AuraSettings.CritChance then
                        damage = math.floor(damage * AuraSettings.CritMultiplier)
                        isCrit = true
                    end

                    -- Deal damage
                    pcall(function()
                        targetHum:TakeDamage(damage)
                    end)

                    -- Spawn damage indicator if available
                    if SpawnDamageIndicator then
                        SpawnDamageIndicator(targetHRP, damage)
                    end

                    hitCount += 1
                end
            end
        end
    end

    if hitCount > 0 then
        LastAuraHit = tick()
    end
end

CombatTab:Section({
    Title = "Attack Aura (ออร่าตีวงกว้าง)",
})

CombatTab:Toggle({
    Title = "Enable Attack Aura",
    Default = false,
    Callback = function(Value)
        AuraSettings.Enabled = Value
    end,
})

CombatTab:Slider({
    Title = "Aura Range (studs)",
    Step = 1,
    Value = {
        Min = 10,
        Max = 100,
        Default = 25,
    },
    Callback = function(Value)
        AuraSettings.Range = Value
    end,
})

CombatTab:Slider({
    Title = "Aura Damage",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = 15,
    },
    Callback = function(Value)
        AuraSettings.Damage = Value
    end,
})

CombatTab:Slider({
    Title = "Attack Speed (Interval)",
    Step = 0.05,
    Value = {
        Min = 0.15,
        Max = 1.0,
        Default = 0.35,
    },
    Callback = function(Value)
        AuraSettings.Interval = Value
    end,
})

CombatTab:Toggle({
    Title = "Critical Hits",
    Default = true,
    Callback = function(Value)
        AuraSettings.Critical = Value
    end,
})

CombatTab:Section({
    Title = "Other Combat Settings",
})

CombatTab:Dropdown({
    Title = "Weapon",
    Values = {
        "Sword",
        "Fighting Style",
        "Gun",
    },
    Value = "Sword",
})

CombatTab:Dropdown({
    Title = "Range",
    Values = {
        "Short",
        "Medium",
        "Long",
    },
    Value = "Medium",
})

CombatTab:Toggle({
    Title = "Combat Camera",
    Default = false,
})

-- Aura Loop
RunService.Heartbeat:Connect(function()
    if AuraSettings.Enabled then
        DoAuraAttack()
    end
end)

-- Re-apply Hitbox on CharacterAdded
Player.CharacterAdded:Connect(function()
    task.wait(0.6)
    if HitboxSettings.Enabled then
        ApplyHitbox()
    end
end)

--==================================================
-- TELEPORT
--==================================================
local TeleportTab = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

TeleportTab:Section({
    Title = "Locations",
})

local SelectedIsland = "Starter Island"
local SavedCFrame = nil

local IslandLocations = {
    ["Starter Island"] = Vector3.new(0, 50, 0),
    ["Jungle"] = Vector3.new(-1612, 37, 148),
    ["Desert"] = Vector3.new(1094, 16, 4192),
    ["Frozen Village"] = Vector3.new(1185, 27, -1324),
    ["Marine Fortress"] = Vector3.new(-2568, 73, -2055),
    ["Sky Island"] = Vector3.new(-4832, 717, -2632),
    ["Prison"] = Vector3.new(4854, 5, 742),
    ["Colosseum"] = Vector3.new(-1428, 7, -2792)
}

local function SafeTeleport(targetCFrame)
    local char = Player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            char:PivotTo(targetCFrame)
        end
    end
end

TeleportTab:Dropdown({
    Title = "Island",
    Values = {
        "Starter Island",
        "Jungle",
        "Desert",
        "Frozen Village",
        "Marine Fortress",
        "Sky Island",
        "Prison",
        "Colosseum",
    },
    Value = "Starter Island",
    Callback = function(Value)
        SelectedIsland = Value
    end,
})

TeleportTab:Dropdown({
    Title = "Location",
    Values = {
        "Spawn",
        "Town",
        "Shop",
        "Quest",
    },
    Value = "Spawn",
})

TeleportTab:Section({
    Title = "Saved Locations",
})

TeleportTab:Button({
    Title = "Teleport",
    Callback = function()
        local pos = IslandLocations[SelectedIsland]
        if pos then
            SafeTeleport(CFrame.new(pos))
        end
    end,
})

--==================================================
-- PLAYER
--==================================================

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
})

local currentWalkSpeed = 16
local currentJumpPower = 50

local function applyPlayerStats()
    local char = Player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = currentWalkSpeed
            hum.UseJumpPower = true
            hum.JumpPower = currentJumpPower
        end
    end
end

PlayerTab:Section({
    Title = "Movement",
})

PlayerTab:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 100,
        Default = 16,
    },
    Callback = function(Value)
        currentWalkSpeed = Value
        applyPlayerStats()
    end,
})

PlayerTab:Slider({
    Title = "Jump Power",
    Step = 1,
    Value = {
        Min = 50,
        Max = 150,
        Default = 50,
    },
    Callback = function(Value)
        currentJumpPower = Value
        applyPlayerStats()
    end,
})

RunService.Heartbeat:Connect(function()
    applyPlayerStats()
end)

Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyPlayerStats()
end)

PlayerTab:Section({
    Title = "Camera Settings",
})

PlayerTab:Toggle({
    Title = "Camera Assist",
    Default = false,
})

PlayerTab:Section({
    Title = "Player Information",
})

PlayerTab:Paragraph({
    Title = "Username",
    Desc = Player.Name,
})

PlayerTab:Paragraph({
    Title = "Display Name",
    Desc = Player.DisplayName,
})

PlayerTab:Paragraph({
    Title = "User ID",
    Desc = tostring(Player.UserId),
})

--==================================================
-- VISUAL (ESP & MINECRAFT DAMAGE INDICATOR ENGINE)
--==================================================

local VisualTab = Window:Tab({
    Title = "Visual",
    Icon = "eye",
})

local ESP_Settings = {
    Box = false,
    Skeleton = false,
    HealthBar = false,
    Distance = false,
    Name = false,
    MaxDistance = 100,
}

local DamageSettings = {
    Indicator = false,
    PixelText = false,
    Size = "Medium",
    Color = "White",
    Critical = false,
}

local ColorMap = {
    ["White"] = Color3.fromRGB(255, 255, 255),
    ["Red"] = Color3.fromRGB(255, 60, 60),
    ["Yellow"] = Color3.fromRGB(255, 220, 0),
    ["Green"] = Color3.fromRGB(50, 255, 100),
    ["Blue"] = Color3.fromRGB(80, 160, 255),
}

local SizeMap = {
    ["Small"] = { TextSize = 14, CritSize = 18 },
    ["Medium"] = { TextSize = 18, CritSize = 24 },
    ["Large"] = { TextSize = 24, CritSize = 32 },
}

VisualTab:Section({
    Title = "Visual Settings",
})

VisualTab:Toggle({ Title = "Box", Default = false, Callback = function(v) ESP_Settings.Box = v end })
VisualTab:Toggle({ Title = "Skeleton", Default = false, Callback = function(v) ESP_Settings.Skeleton = v end })
VisualTab:Toggle({ Title = "Health Bar", Default = false, Callback = function(v) ESP_Settings.HealthBar = v end })
VisualTab:Toggle({ Title = "Distance", Default = false, Callback = function(v) ESP_Settings.Distance = v end })
VisualTab:Toggle({ Title = "Name", Default = false, Callback = function(v) ESP_Settings.Name = v end })

VisualTab:Dropdown({
    Title = "Box Size",
    Values = { "Small", "Medium", "Large" },
    Value = "Small",
})

VisualTab:Dropdown({
    Title = "Distance Range",
    Values = { "50", "100", "250", "500", "1000" },
    Value = "100",
    Callback = function(v) ESP_Settings.MaxDistance = tonumber(v) or 100 end,
})

VisualTab:Section({
    Title = "Damage Display",
})

VisualTab:Toggle({
    Title = "Damage Indicator",
    Default = false,
    Callback = function(v) DamageSettings.Indicator = v end
})

VisualTab:Toggle({
    Title = "Pixel Damage Text",
    Default = false,
    Callback = function(v) DamageSettings.PixelText = v end
})

VisualTab:Dropdown({
    Title = "Damage Size",
    Values = { "Small", "Medium", "Large" },
    Value = "Medium",
    Callback = function(v) DamageSettings.Size = v end
})

VisualTab:Dropdown({
    Title = "Damage Color",
    Values = { "White", "Red", "Yellow", "Green", "Blue" },
    Value = "White",
    Callback = function(v) DamageSettings.Color = v end
})

VisualTab:Toggle({
    Title = "Critical Damage",
    Default = false,
    Callback = function(v) DamageSettings.Critical = v end
})

--==================================================
-- MINECRAFT FLOATING DAMAGE INDICATOR ENGINE
--==================================================

function SpawnDamageIndicator(targetPart, damageAmount)
    if not DamageSettings.Indicator or not targetPart then return end

    local bill = Instance.new("BillboardGui")
    bill.Name = "FNX_DamageIndicator"
    bill.Size = UDim2.fromOffset(120, 50)
    bill.AlwaysOnTop = true
    bill.Adornee = targetPart

    local randomOffset = Vector3.new(
        math.random(-15, 15) / 10,
        math.random(10, 25) / 10,
        math.random(-15, 15) / 10
    )
    bill.StudsOffsetWorldSpace = targetPart.Position + randomOffset

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = bill

    if DamageSettings.PixelText then
        label.Font = Enum.Font.Arcade
    else
        label.Font = Enum.Font.GothamBold
    end

    local isCrit = DamageSettings.Critical and (damageAmount >= 25 or math.random(1, 3) == 1)
    local sizeData = SizeMap[DamageSettings.Size] or SizeMap["Medium"]
    
    if isCrit then
        label.Text = "★ " .. tostring(damageAmount) .. "!"
        label.TextSize = sizeData.CritSize
        label.TextColor3 = Color3.fromRGB(255, 215, 0)
    else
        label.Text = tostring(damageAmount)
        label.TextSize = sizeData.TextSize
        label.TextColor3 = ColorMap[DamageSettings.Color] or Color3.fromRGB(255, 255, 255)
    end

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Parent = label

    bill.Parent = EspGui

    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local targetPos = bill.StudsOffsetWorldSpace + Vector3.new(0, 2.5, 0)

    local tweenMove = TweenService:Create(bill, tweenInfo, { StudsOffsetWorldSpace = targetPos })
    local tweenFadeText = TweenService:Create(label, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
    local tweenFadeStroke = TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Transparency = 1 })

    tweenMove:Play()
    task.delay(0.4, function()
        tweenFadeText:Play()
        tweenFadeStroke:Play()
    end)

    tweenMove.Completed:Connect(function()
        bill:Destroy()
    end)
end

local function HookHumanoidDamage(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not hum or not hrp or char == Player.Character then return end

    local lastHealth = hum.Health

    hum.HealthChanged:Connect(function(newHealth)
        if DamageSettings.Indicator then
            local damage = lastHealth - newHealth
            if damage > 0 then
                SpawnDamageIndicator(hrp, math.floor(damage))
            end
        end
        lastHealth = newHealth
    end)
end

for _, model in pairs(workspace:GetChildren()) do
    if model:IsA("Model") and model \~= Player.Character then
        HookHumanoidDamage(model)
    end
end

workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        task.wait(0.2)
        HookHumanoidDamage(child)
    end
end)

--==================================================
-- SETTINGS
--==================================================

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

SettingsTab:Section({
    Title = "Interface",
})

SettingsTab:Dropdown({
    Title = "Theme",
    Values = {
        "Dark Blue",
        "Dark",
        "Light",
    },
    Value = "Dark Blue",
})

SettingsTab:Toggle({
    Title = "Notifications",
    Default = true,
})

SettingsTab:Dropdown({
    Title = "UI Scale",
    Values = {
        "80%",
        "90%",
        "100%",
        "110%",
        "120%",
    },
    Value = "100%",
})

SettingsTab:Section({
    Title = "Controls",
})

SettingsTab:Dropdown({
    Title = "Keybind",
    Values = {
        "RightShift",
        "LeftControl",
        "Insert",
    },
    Value = "RightShift",
    Callback = function(Value)
        if Value == "RightShift" then
            CurrentKeybind = Enum.KeyCode.RightShift
        elseif Value == "LeftControl" then
            CurrentKeybind = Enum.KeyCode.LeftControl
        elseif Value == "Insert" then
            CurrentKeybind = Enum.KeyCode.Insert
        end
    end,
})

SettingsTab:Button({
    Title = "Reset Settings",
    Callback = function()
        print("FNX HUB: Settings reset")
    end,
})

SettingsTab:Button({
    Title = "Destroy UI",
    Callback = function()
        ClearHitbox()
        if EspGui then EspGui:Destroy() end
        if PerformanceGui then PerformanceGui:Destroy() end
        if Window then Window:Destroy() end
    end,
})

--==================================================
-- STABLE ESP RENDER ENGINE
--==================================================
local ESP_Cache = {}

local function CreateESPElement(targetPlayer)
    local elements = {
        Box = Instance.new("Frame"),
        BoxStroke = Instance.new("UIStroke"),
        HealthBg = Instance.new("Frame"),
        HealthBar = Instance.new("Frame"),
        NameLabel = Instance.new("TextLabel"),
        DistLabel = Instance.new("TextLabel")
    }

    elements.Box.BackgroundTransparency = 1
    elements.Box.Parent = EspGui

    elements.BoxStroke.Color = Color3.fromRGB(255, 255, 255)
    elements.BoxStroke.Thickness = 1.5
    elements.BoxStroke.Parent = elements.Box

    elements.HealthBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    elements.HealthBg.BorderSizePixel = 0
    elements.HealthBg.Parent = EspGui

    elements.HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    elements.HealthBar.BorderSizePixel = 0
    elements.HealthBar.Parent = elements.HealthBg

    elements.NameLabel.BackgroundTransparency = 1
    elements.NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    elements.NameLabel.Font = Enum.Font.GothamBold
    elements.NameLabel.TextSize = 11
    elements.NameLabel.TextXAlignment = Enum.TextXAlignment.Center
    elements.NameLabel.Size = UDim2.fromOffset(200, 15)
    elements.NameLabel.Parent = EspGui

    elements.DistLabel.BackgroundTransparency = 1
    elements.DistLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    elements.DistLabel.Font = Enum.Font.Gotham
    elements.DistLabel.TextSize = 10
    elements.DistLabel.TextXAlignment = Enum.TextXAlignment.Center
    elements.DistLabel.Size = UDim2.fromOffset(200, 15)
    elements.DistLabel.Parent = EspGui

    ESP_Cache[targetPlayer] = elements
end

local function HideESP(elements)
    elements.Box.Visible = false
    elements.HealthBg.Visible = false
    elements.NameLabel.Visible = false
    elements.DistLabel.Visible = false
end

RunService.RenderStepped:Connect(function()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer \~= Player then
            if not ESP_Cache[targetPlayer] then
                CreateESPElement(targetPlayer)
            end

            local elements = ESP_Cache[targetPlayer]
            local char = targetPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - Camera.CFrame.Position).Magnitude

                if dist <= ESP_Settings.MaxDistance then
                    local headCFrame = hrp.CFrame * CFrame.new(0, 2.5, 0)
                    local feetCFrame = hrp.CFrame * CFrame.new(0, -3.2, 0)

                    local headPos, headOnScreen = Camera:WorldToViewportPoint(headCFrame.Position)
                    local feetPos, feetOnScreen = Camera:WorldToViewportPoint(feetCFrame.Position)

                    if headOnScreen and feetOnScreen then
                        local topY = headPos.Y
                        local bottomY = feetPos.Y
                        local boxHeight = math.abs(bottomY - topY)
                        local boxWidth = boxHeight * 0.65
                        local posX = headPos.X - (boxWidth / 2)

                        if ESP_Settings.Box then
                            elements.Box.Size = UDim2.fromOffset(boxWidth, boxHeight)
                            elements.Box.Position = UDim2.fromOffset(posX, topY)
                            elements.Box.Visible = true
                        else
                            elements.Box.Visible = false
                        end

                        if ESP_Settings.HealthBar then
                            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            elements.HealthBg.Size = UDim2.fromOffset(3, boxHeight)
                            elements.HealthBg.Position = UDim2.fromOffset(posX - 6, topY)
                            
                            elements.HealthBar.Size = UDim2.new(1, 0, healthPercent, 0)
                            elements.HealthBar.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
                            elements.HealthBar.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 50)
                            elements.HealthBg.Visible = true
                        else
                            elements.HealthBg.Visible = false
                        end

                        if ESP_Settings.Name then
                            elements.NameLabel.Text = targetPlayer.Name
                            elements.NameLabel.Position = UDim2.fromOffset(headPos.X - 100, topY - 16)
                            elements.NameLabel.Visible = true
                        else
                            elements.NameLabel.Visible = false
                        end

                        if ESP_Settings.Distance then
                            elements.DistLabel.Text = math.floor(dist) .. "m"
                            elements.DistLabel.Position = UDim2.fromOffset(headPos.X - 100, bottomY + 2)
                            elements.DistLabel.Visible = true
                        else
                            elements.DistLabel.Visible = false
                        end
                    else
                        HideESP(elements)
                    end
                else
                    HideESP(elements)
                end
            else
                HideESP(elements)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(targetPlayer)
    if ESP_Cache[targetPlayer] then
        for _, obj in pairs(ESP_Cache[targetPlayer]) do
            pcall(function() obj:Destroy() end)
        end
        ESP_Cache[targetPlayer] = nil
    end
end)

print("FNX HUB loaded successfully - Hitbox Expander + Attack Aura fully active.")
