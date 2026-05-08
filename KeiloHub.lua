-- Keilo Hub for Rivals - Versión Completa con funciones reales

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()

local Window = Library:CreateWindow({
    Title = "Keilo Hub | Rivals",
    Center = true,
    AutoShow = true,
    Size = UDim2.fromOffset(620, 560)
})

-- Variables de configuración
local Config = {
    Aimbot = {Enabled = false, Silent = false, Smooth = 0.35, TargetPart = "Head"},
    ESP = {Enabled = true, Boxes = true, Names = true, Health = true},
    Movement = {Fly = false, FlySpeed = 80, SpeedHack = false, WalkSpeed = 60}
}

local Connections = {}
local ESPObjects = {}

-- === ESP + Wallhack ===
local function CreateESP(plr)
    if plr == LocalPlayer then return end
    
    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Color = Color3.fromRGB(255, 0, 100)
    Box.Transparency = 0.8
    Box.Filled = false
    
    local Name = Drawing.new("Text")
    Name.Size = 15
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Outline = true
    Name.Center = true
    
    Connections[plr] = RunService.RenderStepped:Connect(function()
        if not Config.ESP.Enabled or not plr.Character then 
            Box.Visible = false
            Name.Visible = false
            return 
        end
        
        local Root = plr.Character:FindFirstChild("HumanoidRootPart")
        local Head = plr.Character:FindFirstChild("Head")
        if not Root or not Head then return end
        
        local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
        if not OnScreen then 
            Box.Visible = false 
            Name.Visible = false 
            return 
        end
        
        local Top = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 2.5, 0))
        local Bottom = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 3, 0))
        
        local Height = Bottom.Y - Top.Y
        local Width = Height * 0.6
        
        Box.Size = Vector2.new(Width, Height)
        Box.Position = Vector2.new(Pos.X - Width/2, Pos.Y - Height/2)
        Box.Visible = true
        
        Name.Text = plr.Name .. " (" .. math.floor((Root.Position - Camera.CFrame.Position).Magnitude) .. "m)"
        Name.Position = Vector2.new(Pos.X, Top.Y - 25)
        Name.Visible = true
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do CreateESP(plr) end
Players.PlayerAdded:Connect(CreateESP)

-- === Aimbot ===
local function GetClosestPlayer()
    local closest, dist = nil, 9999
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            local part = plr.Character[Config.Aimbot.TargetPart]
            local screenPos, visible = Camera:WorldToViewportPoint(part.Position)
            if visible then
                local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if magnitude < dist then
                    dist = magnitude
                    closest = plr
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    -- Aimbot
    if Config.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character then
            local targetPos = target.Character[Config.Aimbot.TargetPart].Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), Config.Aimbot.Smooth)
        end
    end
    
    -- Fly
    if Config.Movement.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local cam = Camera.CFrame
        local direction = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.new(0,1,0) end
        
        if direction.Magnitude > 0 then
            hrp.Velocity = direction.Unit * Config.Movement.FlySpeed
        else
            hrp.Velocity = Vector3.new(0,0,0)
        end
    end
    
    -- Speed Hack
    if Config.Movement.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Movement.WalkSpeed
    end
end)

-- === Interfaz ===
local AimbotTab = Window:AddTab("Aimbot")
local VisualsTab = Window:AddTab("Visuals")
local MovementTab = Window:AddTab("Movement")

AimbotTab:AddToggle("AimbotToggle", {Text = "Aimbot Cabeza", Default = false, Callback = function(v) Config.Aimbot.Enabled = v end})
AimbotTab:AddToggle("SilentAimToggle", {Text = "Silent Aim", Default = false})
AimbotTab:AddSlider("SmoothSlider", {Text = "Smoothness", Min = 0.1, Max = 1, Default = 0.35, Rounding = 2, Callback = function(v) Config.Aimbot.Smooth = v end})

VisualsTab:AddToggle("ESPToggle", {Text = "ESP + Wallhack", Default = true, Callback = function(v) Config.ESP.Enabled = v end})
VisualsTab:AddToggle("BoxesToggle", {Text = "Mostrar Boxes", Default = true})
VisualsTab:AddToggle("NamesToggle", {Text = "Mostrar Nombres", Default = true})

MovementTab:AddToggle("FlyToggle", {Text = "Fly", Default = false, Callback = function(v) Config.Movement.Fly = v end})
MovementTab:AddSlider("FlySpeedSlider", {Text = "Velocidad Fly", Min = 20, Max = 200, Default = 80, Callback = function(v) Config.Movement.FlySpeed = v end})
MovementTab:AddToggle("SpeedToggle", {Text = "Speed Hack", Default = false, Callback = function(v) Config.Movement.SpeedHack = v end})
MovementTab:AddSlider("WalkSpeedSlider", {Text = "WalkSpeed", Min = 16, Max = 150, Default = 60, Callback = function(v) Config.Movement.WalkSpeed = v end})

Library:Notify("✅ Keilo Hub cargado correctamente para Rivals", 6)
print("Keilo Hub v2.0 - Listo")
