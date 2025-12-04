-- MOD MENU LUAU - ESP & AIMBOT
-- Para Roblox Mobile

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configurações
local Settings = {
    ESP = {
        Enabled = false,
        Box = false,
        Line = false,
        Health = false,
        Color = Color3.fromRGB(0, 255, 0)
    },
    Aimbot = {
        Enabled = false,
        FOV = 100,
        ShowFOV = false,
        HeadshotOnly = true
    }
}

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner arredondado
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 MOD MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Botão Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -45, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- Container de conteúdo
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -70)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 6
Content.Parent = MainFrame

-- Função para criar seções
local function CreateSection(name, yPos)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, -10, 0, 30)
    Section.Position = UDim2.new(0, 0, 0, yPos)
    Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Section.BorderSizePixel = 0
    Section.Parent = Content
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 0)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Section
    
    return yPos + 40
end

-- Função para criar botão toggle
local function CreateToggle(name, yPos, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, -10, 0, 35)
    Toggle.Position = UDim2.new(0, 0, 0, yPos)
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Content
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 50, 0, 25)
    Button.Position = UDim2.new(1, -60, 0.5, -12.5)
    Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Button.Text = "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Toggle
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            Button.Text = "ON"
        else
            Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            Button.Text = "OFF"
        end
        callback(enabled)
    end)
    
    return yPos + 45
end

-- Função para criar slider
local function CreateSlider(name, min, max, default, yPos, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -10, 0, 50)
    Slider.Position = UDim2.new(0, 0, 0, yPos)
    Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Slider.BorderSizePixel = 0
    Slider.Parent = Content
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = Slider
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0.9, 0, 0, 6)
    SliderBar.Position = UDim2.new(0.05, 0, 1, -15)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Slider
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 3)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill
    
    local dragging = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor(min + (max - min) * pos)
            Label.Text = name .. ": " .. value
            callback(value)
        end
    end)
    
    return yPos + 60
end

-- Criar UI
local yOffset = 0

yOffset = CreateSection("👁️ ESP", yOffset)
yOffset = CreateToggle("ESP Ativado", yOffset, function(val) Settings.ESP.Enabled = val end)
yOffset = CreateToggle("ESP Caixa", yOffset, function(val) Settings.ESP.Box = val end)
yOffset = CreateToggle("ESP Linha", yOffset, function(val) Settings.ESP.Line = val end)
yOffset = CreateToggle("ESP Vida", yOffset, function(val) Settings.ESP.Health = val end)

yOffset = CreateSection("🎯 AIMBOT", yOffset)
yOffset = CreateToggle("Aimbot Ativado", yOffset, function(val) Settings.Aimbot.Enabled = val end)
yOffset = CreateToggle("Mostrar FOV", yOffset, function(val) Settings.Aimbot.ShowFOV = val end)
yOffset = CreateSlider("Tamanho FOV", 50, 300, 100, yOffset, function(val) Settings.Aimbot.FOV = val end)

Content.CanvasSize = UDim2.new(0, 0, 0, yOffset)

-- Minimizar
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 50), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "□"
    else
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 400), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "_"
    end
end)

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Transparency = 0.5
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false

-- Função para desenhar ESP
local function CreateESP(player)
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "ESP_" .. player.Name
    ESPFolder.Parent = game.CoreGui
    
    -- Linha
    local Line = Drawing.new("Line")
    Line.Thickness = 2
    Line.Transparency = 1
    
    -- Caixa
    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Transparency = 1
    Box.Filled = false
    
    -- Barra de vida
    local HealthBarOutline = Drawing.new("Square")
    HealthBarOutline.Thickness = 1
    HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    HealthBarOutline.Transparency = 1
    HealthBarOutline.Filled = false
    
    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = 1
    HealthBar.Transparency = 1
    HealthBar.Filled = true
    
    local function Update()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
            Line.Visible = false
            Box.Visible = false
            HealthBar.Visible = false
            HealthBarOutline.Visible = false
            return
        end
        
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        
        if onScreen and Settings.ESP.Enabled then
            -- Linha
            if Settings.ESP.Line then
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Line.To = Vector2.new(pos.X, pos.Y)
                Line.Color = hum.Health > 50 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                Line.Visible = true
            else
                Line.Visible = false
            end
            
            -- Caixa
            if Settings.ESP.Box then
                local headPos = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                Box.Size = Vector2.new(width, height)
                Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                Box.Color = hum.Health > 50 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                Box.Visible = true
                
                -- Barra de vida
                if Settings.ESP.Health then
                    local healthPercent = hum.Health / hum.MaxHealth
                    
                    HealthBarOutline.Size = Vector2.new(4, height)
                    HealthBarOutline.Position = Vector2.new(Box.Position.X - 7, Box.Position.Y)
                    HealthBarOutline.Visible = true
                    
                    HealthBar.Size = Vector2.new(2, height * healthPercent)
                    HealthBar.Position = Vector2.new(Box.Position.X - 6, Box.Position.Y + height - (height * healthPercent))
                    HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    HealthBar.Visible = true
                else
                    HealthBar.Visible = false
                    HealthBarOutline.Visible = false
                end
            else
                Box.Visible = false
                HealthBar.Visible = false
                HealthBarOutline.Visible = false
            end
        else
            Line.Visible = false
            Box.Visible = false
            HealthBar.Visible = false
            HealthBarOutline.Visible = false
        end
    end
    
    RunService.RenderStepped:Connect(Update)
end

-- Criar ESP para todos os jogadores
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

-- Aimbot
local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local char = player.Character
            local head = char.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                
                if distance < Settings.Aimbot.FOV and distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    -- Atualizar FOV Circle
    if Settings.Aimbot.ShowFOV then
        FOVCircle.Radius = Settings.Aimbot.FOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
    
    -- Aimbot
    if Settings.Aimbot.Enabled then
        local target = GetClosestPlayerInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end)

print("Mod Menu carregado com sucesso!")
