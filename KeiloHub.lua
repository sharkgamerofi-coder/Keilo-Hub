-- Keilo Hub for Rivals

print("Keilo Hub cargando...")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()

local Window = Library:CreateWindow({
    Title = "Keilo Hub | Rivals",
    Center = true,
    AutoShow = true,
    Size = UDim2.fromOffset(600, 500)
})

-- Tabs
local AimbotTab = Window:AddTab("Aimbot")
local VisualsTab = Window:AddTab("Visuals")
local MovementTab = Window:AddTab("Movement")

-- Aimbot
local aimbotEnabled = false
local silentAimEnabled = false

AimbotTab:AddToggle("Aimbot", {Text = "Aimbot Cabeza", Default = false, Callback = function(v) aimbotEnabled = v end})
AimbotTab:AddToggle("SilentAim", {Text = "Silent Aim", Default = false, Callback = function(v) silentAimEnabled = v end})
AimbotTab:AddSlider("Smoothness", {Text = "Smoothness", Min = 0, Max = 1, Default = 0.4, Rounding = 2})

-- Visuals (ESP + Wallhack)
VisualsTab:AddToggle("ESP", {Text = "ESP + Wallhack", Default = true, Callback = print})
VisualsTab:AddToggle("Boxes", {Text = "Boxes", Default = true})
VisualsTab:AddToggle("Names", {Text = "Names", Default = true})
VisualsTab:AddToggle("Health", {Text = "Health Bars", Default = true})

-- Movement
MovementTab:AddToggle("Fly", {Text = "Fly", Default = false})
MovementTab:AddSlider("FlySpeed", {Text = "Fly Speed", Min = 20, Max = 150, Default = 60})
MovementTab:AddToggle("SpeedHack", {Text = "Speed Hack", Default = false})

Library:Notify("Keilo Hub cargado correctamente!", 5)
print("✅ Keilo Hub listo para Rivals")