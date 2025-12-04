-- Mod Menu Mobile - ESP e Aimbot
-- Otimizado para dispositivos móveis

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Aguardar personagem carregar
repeat wait() until LocalPlayer.Character
repeat wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- Configurações
local Config = {
    ESP = {
        Enabled = false,
        HealthBar = true,
        Line = true,
        Box = true,
        MaxDistance = 500,
        TeamCheck = true
    },
    Aimbot = {
        Enabled = false,
        FOV = 150,
        ShowFOV = true,
        Active = false
    }
}

-- Cores
local Colors = {
    Enemy = Color3.fromRGB(255, 50, 50),
    Health = Color3.fromRGB(0, 255, 0),
    HealthBg = Color3.fromRGB(50, 50, 50),
    FOV = Color3.fromRGB(255, 255, 255)
}

-- Sistema de ESP
local ESPObjects = {}

local function isEnemy(player)
    if not Config.ESP.TeamCheck then return true end
    if player.Team == nil or LocalPlayer.Team == nil then return true end
    return player.Team ~= LocalPlayer.Team
end

local function createESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        HealthBarBg = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Line = Drawing.new("Line"),
        Player = player
    }
    
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    esp.Box.Color = Colors.Enemy
    esp.Box.Visible = false
    esp.Box.ZIndex = 2
    
    esp.HealthBarBg.Thickness = 1
    esp.HealthBarBg.Filled = true
    esp.HealthBarBg.Color = Colors.HealthBg
    esp.HealthBarBg.Visible = false
    esp.HealthBarBg.ZIndex = 1
    
    esp.HealthBar.Thickness = 1
    esp.HealthBar.Filled = true
    esp.HealthBar.Color = Colors.Health
    esp.HealthBar.Visible = false
    esp.HealthBar.ZIndex = 2
    
    esp.Line.Thickness = 2
    esp.Line.Color = Colors.Enemy
    esp.Line.Visible = false
    esp.Line.ZIndex = 2
    
    ESPObjects[player] = esp
end

local function removeESP(player)
    if ESPObjects[player] then
        for key, obj in pairs(ESPObjects[player]) do
            if key ~= "Player" then
                pcall(function() obj:Remove() end)
            end
        end
        ESPObjects[player] = nil
    end
end

local function updateESP()
    if not Config.ESP.Enabled then 
        for _, esp in pairs(ESPObjects) do
            esp.Box.Visible = false
            esp.HealthBarBg.Visible = false
            esp.HealthBar.Visible = false
            esp.Line.Visible = false
        end
        return 
    end
    
    for player, esp in pairs(ESPObjects) do
        local success = pcall(function()
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") then
                local hrp = player.Character.HumanoidRootPart
                local hum = player.Character.Humanoid
                local head = player.Character.Head
                
                if hum.Health <= 0 or not isEnemy(player) then
                    esp.Box.Visible = false
                    esp.HealthBarBg.Visible = false
                    esp.HealthBar.Visible = false
                    esp.Line.Visible = false
                    return
                end
                
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if distance > Config.ESP.MaxDistance then
                    esp.Box.Visible = false
                    esp.HealthBarBg.Visible = false
                    esp.HealthBar.Visible = false
                    esp.Line.Visible = false
                    return
                end
                
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen and pos.Z > 0 then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    
                    if Config.ESP.Box then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end
                    
                    if Config.ESP.HealthBar then
                        local healthPercent = hum.Health / hum.MaxHealth
                        local barWidth = 4
                        local barHeight = height
                        
                        esp.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
                        esp.HealthBarBg.Position = Vector2.new(pos.X - width/2 - barWidth - 3, pos.Y - height/2)
                        esp.HealthBarBg.Visible = true
                        
                        esp.HealthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                        esp.HealthBar.Position = Vector2.new(pos.X - width/2 - barWidth - 3, pos.Y - height/2 + barHeight * (1 - healthPercent))
                        esp.HealthBar.Visible = true
                    else
                        esp.HealthBarBg.Visible = false
                        esp.HealthBar.Visible = false
                    end
                    
                    if Config.ESP.Line then
                        esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.Line.To = Vector2.new(pos.X, pos.Y)
                        esp.Line.Visible = true
                    else
                        esp.Line.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.HealthBarBg.Visible = false
                    esp.HealthBar.Visible = false
                    esp.Line.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.HealthBarBg.Visible = false
                esp.HealthBar.Visible = false
                esp.Line.Visible = false
            end
        end)
        
        if not success then
            esp.Box.Visible = false
            esp.HealthBarBg.Visible = false
            esp.HealthBar.Visible = false
            esp.Line.Visible = false
        end
    end
end

-- Sistema de Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 3
FOVCircle.NumSides = 64
FOVCircle.Radius = Config.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Color = Colors.FOV
FOVCircle.Visible = false
FOVCircle.Transparency = 0.7
FOVCircle.ZIndex = 1000

local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            if hum.Health > 0 then
                if Config.ESP.TeamCheck and not isEnemy(player) then continue end
                
                local head = player.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen and pos.Z > 0 then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local distance = (screenPos - centerScreen).Magnitude
                    
                    if distance < Config.Aimbot.FOV and distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAt(player)
    if player and player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
    end
end

-- Interface GUI Mobile
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenuMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Proteger GUI
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if ScreenGui.Parent ~= game:GetService("CoreGui") then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Text = "MOD MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -45, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 28
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeBtn

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 8
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.Parent = ContentFrame

local function createToggle(name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 50, 50)
    Button.TextSize = 20
    Button.Font = Enum.Font.GothamBold
    Button.Parent = ContentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.Text = name .. ": " .. (enabled and "ON" or "OFF")
        Button.TextColor3 = enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        Button.BackgroundColor3 = enabled and Color3.fromRGB(50, 70, 50) or Color3.fromRGB(45, 45, 45)
        callback(enabled)
    end)
    
    return Button
end

local function createSlider(name, min, max, default, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 70)
    Container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Container.Parent = ContentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 25)
    Label.Position = UDim2.new(0, 5, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 18
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -20, 0, 25)
    Slider.Position = UDim2.new(0, 10, 0, 35)
    Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Slider.Parent = Container
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 12)
    SliderCorner.Parent = Slider
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    Fill.Parent = Slider
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 12)
    FillCorner.Parent = Fill
    
    local dragging = false
    
    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pos = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + (max - min) * pos)
            Label.Text = name .. ": " .. value
            callback(value)
        end
    end)
    
    Slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    Slider.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + (max - min) * pos)
            Label.Text = name .. ": " .. value
            callback(value)
        end
    end)
end

-- Criar controles
createToggle("ESP Box", function(enabled)
    Config.ESP.Box = enabled
end)

createToggle("ESP Linha", function(enabled)
    Config.ESP.Line = enabled
end)

createToggle("ESP Vida", function(enabled)
    Config.ESP.HealthBar = enabled
end)

createToggle("ESP Ativado", function(enabled)
    Config.ESP.Enabled = enabled
end)

local aimbotBtn = createToggle("Aimbot", function(enabled)
    Config.Aimbot.Enabled = enabled
    Config.Aimbot.Active = enabled
end)

createToggle("Mostrar FOV", function(enabled)
    Config.Aimbot.ShowFOV = enabled
end)

createSlider("FOV Tamanho", 50, 300, 150, function(value)
    Config.Aimbot.FOV = value
    FOVCircle.Radius = value
end)

createSlider("Distância ESP", 100, 2000, 500, function(value)
    Config.ESP.MaxDistance = value
end)

-- Minimizar
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ContentFrame.Visible = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 350, 0, 50) or UDim2.new(0, 350, 0, 500)
    MinimizeBtn.Text = minimized and "+" or "-"
end)

-- Tornar arrastável
local dragging = false
local dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Inicialização
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(function(player)
    wait(1)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Loop principal
RunService.RenderStepped:Connect(function()
    pcall(function()
        updateESP()
        
        -- Atualizar FOV no centro da tela
        local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Position = centerScreen
        FOVCircle.Visible = Config.Aimbot.ShowFOV
        
        -- Aimbot automático quando ativado
        if Config.Aimbot.Enabled and Config.Aimbot.Active then
            local target = getClosestPlayerInFOV()
            if target then
                aimAt(target)
            end
        end
    end)
end)

print("✅ Mod Menu Mobile carregado com sucesso!")
print("📱 Interface otimizada para mobile")
print("🎯 Aimbot ativa automaticamente quando ligado")
print("⭕ FOV fixo no centro da tela")
