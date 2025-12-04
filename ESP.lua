-- Mod Menu Completo com ESP e Aimbot
-- Criado para Roblox em Luau

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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
        FOV = 100,
        ShowFOV = true,
        Smoothness = 1
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
    local esp = {
        Box = Drawing.new("Square"),
        HealthBarBg = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        Line = Drawing.new("Line"),
        Player = player
    }
    
    -- Configurar Box
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    esp.Box.Color = Colors.Enemy
    esp.Box.Visible = false
    
    -- Configurar Barra de Vida (Fundo)
    esp.HealthBarBg.Thickness = 1
    esp.HealthBarBg.Filled = true
    esp.HealthBarBg.Color = Colors.HealthBg
    esp.HealthBarBg.Visible = false
    
    -- Configurar Barra de Vida
    esp.HealthBar.Thickness = 1
    esp.HealthBar.Filled = true
    esp.HealthBar.Color = Colors.Health
    esp.HealthBar.Visible = false
    
    -- Configurar Linha
    esp.Line.Thickness = 1
    esp.Line.Color = Colors.Enemy
    esp.Line.Visible = false
    
    ESPObjects[player] = esp
end

local function removeESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if typeof(obj) == "table" or typeof(obj) == "Instance" then
                if obj.Remove then obj:Remove() end
            end
        end
        ESPObjects[player] = nil
    end
end

local function updateESP()
    if not Config.ESP.Enabled then return end
    
    for player, esp in pairs(ESPObjects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local hrp = player.Character.HumanoidRootPart
            local hum = player.Character.Humanoid
            local head = player.Character:FindFirstChild("Head")
            
            if not isEnemy(player) then
                esp.Box.Visible = false
                esp.HealthBarBg.Visible = false
                esp.HealthBar.Visible = false
                esp.Line.Visible = false
                continue
            end
            
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if distance > Config.ESP.MaxDistance then
                esp.Box.Visible = false
                esp.HealthBarBg.Visible = false
                esp.HealthBar.Visible = false
                esp.Line.Visible = false
                continue
            end
            
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                -- Calcular tamanho do box
                local headPos = Camera:WorldToViewportPoint(head.Position)
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                -- Atualizar Box
                if Config.ESP.Box then
                    esp.Box.Size = Vector2.new(width, height)
                    esp.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end
                
                -- Atualizar Barra de Vida
                if Config.ESP.HealthBar then
                    local healthPercent = hum.Health / hum.MaxHealth
                    local barWidth = 3
                    local barHeight = height
                    
                    esp.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
                    esp.HealthBarBg.Position = Vector2.new(pos.X - width/2 - barWidth - 2, pos.Y - height/2)
                    esp.HealthBarBg.Visible = true
                    
                    esp.HealthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                    esp.HealthBar.Position = Vector2.new(pos.X - width/2 - barWidth - 2, pos.Y - height/2 + barHeight * (1 - healthPercent))
                    esp.HealthBar.Visible = true
                else
                    esp.HealthBarBg.Visible = false
                    esp.HealthBar.Visible = false
                end
                
                -- Atualizar Linha
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
    end
end

-- Sistema de Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 50
FOVCircle.Radius = Config.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Color = Colors.FOV
FOVCircle.Visible = false
FOVCircle.Transparency = 0.5

local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                if Config.ESP.TeamCheck and not isEnemy(player) then continue end
                
                local head = player.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
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

-- Interface GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.BorderSizePixel = 0
Title.Text = "MOD MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Botão Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 5)
MinimizeCorner.Parent = MinimizeBtn

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 5
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ContentFrame

-- Função para criar botões
local function createToggle(name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 50, 50)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.Parent = ContentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.Text = name .. ": " .. (enabled and "ON" or "OFF")
        Button.TextColor3 = enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        callback(enabled)
    end)
end

local function createSlider(name, min, max, default, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 60)
    Container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Container.Parent = ContentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 5, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -20, 0, 20)
    Slider.Position = UDim2.new(0, 10, 0, 30)
    Slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Slider.Parent = Container
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = Slider
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    Fill.Parent = Slider
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 10)
    FillCorner.Parent = Fill
    
    local dragging = false
    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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

createToggle("Aimbot", function(enabled)
    Config.Aimbot.Enabled = enabled
end)

createToggle("Mostrar FOV", function(enabled)
    Config.Aimbot.ShowFOV = enabled
    FOVCircle.Visible = enabled
end)

createSlider("FOV Tamanho", 50, 300, 100, function(value)
    Config.Aimbot.FOV = value
    FOVCircle.Radius = value
end)

createSlider("Distância ESP", 100, 1000, 500, function(value)
    Config.ESP.MaxDistance = value
end)

-- Minimizar/Maximizar
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ContentFrame.Visible = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 400)
    MinimizeBtn.Text = minimized and "+" or "-"
end)

-- Tornar arrastável
local dragging = false
local dragInput, mousePos, framePos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Inicialização
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Loop principal
RunService.RenderStepped:Connect(function()
    updateESP()
    
    -- Atualizar FOV Circle
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Visible = Config.Aimbot.ShowFOV and Config.Aimbot.Enabled
    
    -- Aimbot
    if Config.Aimbot.Enabled then
        local target = getClosestPlayerInFOV()
        if target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            aimAt(target)
        end
    end
end)

print("Mod Menu carregado com sucesso!")
