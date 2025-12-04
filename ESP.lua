-- MOD MENU LUAU - ESP & AIMBOT MELHORADO
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
        Distance = false,
        MaxDistance = 300,
        Color = Color3.fromRGB(0, 255, 0)
    },
    Aimbot = {
        Enabled = false,
        FOV = 100,
        ShowFOV = true,
        HeadshotOnly = true,
        Smoothness = 0.2
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
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.02, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame

-- Sombra
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 0
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 MOD MENU"
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Botão Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 45, 0, 45)
MinimizeBtn.Position = UDim2.new(1, -50, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 24
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 10)
MinCorner.Parent = MinimizeBtn

-- Container de conteúdo
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -75)
Content.Position = UDim2.new(0, 10, 0, 65)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
Content.Parent = MainFrame

-- Função para criar seções
local function CreateSection(name, icon, yPos)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, -10, 0, 35)
    Section.Position = UDim2.new(0, 0, 0, yPos)
    Section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Section.BorderSizePixel = 0
    Section.Parent = Content
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 10)
    SectionCorner.Parent = Section
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -15, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = icon .. " " .. name
    Label.TextColor3 = Color3.fromRGB(100, 200, 255)
    Label.TextSize = 18
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Section
    
    return yPos + 45
end

-- Função para criar botão toggle melhorado
local function CreateToggle(name, yPos, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, -10, 0, 40)
    Toggle.Position = UDim2.new(0, 0, 0, yPos)
    Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Content
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 15
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 60, 0, 28)
    Button.Position = UDim2.new(1, -70, 0.5, -14)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = ""
    Button.Parent = Toggle
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = Button
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 22, 0, 22)
    Circle.Position = UDim2.new(0, 3, 0.5, -11)
    Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    Circle.BorderSizePixel = 0
    Circle.Parent = Button
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "OFF"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Circle:TweenPosition(UDim2.new(1, -25, 0.5, -11), "Out", "Quad", 0.2, true)
            Button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            StatusLabel.Text = "ON"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Circle:TweenPosition(UDim2.new(0, 3, 0.5, -11), "Out", "Quad", 0.2, true)
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            StatusLabel.Text = "OFF"
            StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        callback(enabled)
    end)
    
    return yPos + 50
end

-- Função para criar slider melhorado
local function CreateSlider(name, min, max, default, yPos, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -10, 0, 55)
    Slider.Position = UDim2.new(0, 0, 0, yPos)
    Slider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Slider.BorderSizePixel = 0
    Slider.Parent = Content
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = Slider
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.Position = UDim2.new(0, 15, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 15
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    ValueLabel.TextSize = 15
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Slider
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0.9, 0, 0, 8)
    SliderBar.Position = UDim2.new(0.05, 0, 1, -18)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Slider
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("Frame")
    SliderButton.Size = UDim2.new(0, 18, 0, 18)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Parent = SliderBar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
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
            SliderButton.Position = UDim2.new(pos, -9, 0.5, -9)
            local value = math.floor(min + (max - min) * pos)
            ValueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return yPos + 65
end

-- Criar UI
local yOffset = 0

yOffset = CreateSection("ESP", "👁️", yOffset)
yOffset = CreateToggle("ESP Caixa", yOffset, function(val) Settings.ESP.Box = val end)
yOffset = CreateToggle("ESP Linha", yOffset, function(val) Settings.ESP.Line = val end)
yOffset = CreateToggle("ESP Vida", yOffset, function(val) Settings.ESP.Health = val end)
yOffset = CreateToggle("Marcar Inimigo Perto", yOffset, function(val) Settings.ESP.Distance = val end)

yOffset = yOffset + 10
yOffset = CreateSection("AIMBOT", "🎯", yOffset)
yOffset = CreateToggle("Aimbot Ativado", yOffset, function(val) Settings.Aimbot.Enabled = val end)
yOffset = CreateToggle("Mostrar FOV", yOffset, function(val) Settings.Aimbot.ShowFOV = val end)
yOffset = CreateSlider("Tamanho FOV", 50, 300, 100, yOffset, function(val) Settings.Aimbot.FOV = val end)
yOffset = CreateSlider("Distância ESP", 100, 500, 300, yOffset, function(val) Settings.ESP.MaxDistance = val end)

Content.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)

-- Minimizar
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 55), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "□"
    else
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 450), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "—"
    end
end)

-- FOV Circle (no centro da tela)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Transparency = 0.7
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.NumSides = 64

-- Função para desenhar ESP melhorado
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        Line = Drawing.new("Line"),
        Box = Drawing.new("Square"),
        HealthBarBG = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        DistanceText = Drawing.new("Text"),
        Name = Drawing.new("Text")
    }
    
    -- Configurar linha (mais fina)
    esp.Line.Thickness = 1
    esp.Line.Transparency = 0.8
    
    -- Configurar caixa
    esp.Box.Thickness = 1
    esp.Box.Transparency = 0.8
    esp.Box.Filled = false
    
    -- Configurar barra de vida
    esp.HealthBarBG.Thickness = 1
    esp.HealthBarBG.Color = Color3.fromRGB(30, 30, 30)
    esp.HealthBarBG.Transparency = 0.8
    esp.HealthBarBG.Filled = true
    
    esp.HealthBar.Thickness = 1
    esp.HealthBar.Transparency = 0.8
    esp.HealthBar.Filled = true
    
    -- Configurar texto
    esp.DistanceText.Size = 13
    esp.DistanceText.Center = true
    esp.DistanceText.Outline = true
    esp.DistanceText.Font = 2
    esp.DistanceText.Color = Color3.fromRGB(255, 255, 255)
    
    esp.Name.Size = 14
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Font = 2
    esp.Name.Color = Color3.fromRGB(100, 200, 255)
    
    ESPObjects[player] = esp
    
    local function Update()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
            for _, obj in pairs(esp) do
                obj.Visible = false
            end
            return
        end
        
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        local head = char:FindFirstChild("Head")
        
        if not head then
            for _, obj in pairs(esp) do
                obj.Visible = false
            end
            return
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
            and (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude or math.huge
        
        if onScreen and distance <= Settings.ESP.MaxDistance then
            -- Calcular cor baseada na vida
            local healthPercent = hum.Health / hum.MaxHealth
            local color = Color3.fromRGB(
                math.floor(255 * (1 - healthPercent)),
                math.floor(255 * healthPercent),
                0
            )
            
            -- ESP Linha (mais fina e elegante)
            if Settings.ESP.Line then
                esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.Line.To = Vector2.new(pos.X, pos.Y)
                esp.Line.Color = color
                esp.Line.Visible = true
            else
                esp.Line.Visible = false
            end
            
            -- ESP Caixa
            if Settings.ESP.Box then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                esp.Box.Color = color
                esp.Box.Visible = true
                
                -- Barra de vida (dentro da caixa)
                if Settings.ESP.Health then
                    local barWidth = 3
                    local barHeight = height
                    
                    esp.HealthBarBG.Size = Vector2.new(barWidth, barHeight)
                    esp.HealthBarBG.Position = Vector2.new(esp.Box.Position.X - barWidth - 2, esp.Box.Position.Y)
                    esp.HealthBarBG.Visible = true
                    
                    esp.HealthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                    esp.HealthBar.Position = Vector2.new(esp.Box.Position.X - barWidth - 2, esp.Box.Position.Y + barHeight - (barHeight * healthPercent))
                    esp.HealthBar.Color = color
                    esp.HealthBar.Visible = true
                else
                    esp.HealthBarBG.Visible = false
                    esp.HealthBar.Visible = false
                end
                
                -- Nome do jogador
                esp.Name.Position = Vector2.new(pos.X, esp.Box.Position.Y - 18)
                esp.Name.Text = player.Name
                esp.Name.Visible = true
            else
                esp.Box.Visible = false
                esp.HealthBarBG.Visible = false
                esp.HealthBar.Visible = false
                esp.Name.Visible = false
            end
            
            -- Marcar inimigo perto
            if Settings.ESP.Distance and distance <= 100 then
                esp.DistanceText.Position = Vector2.new(pos.X, pos.Y + 25)
                esp.DistanceText.Text = string.format("⚠️ %.0fm", distance)
                esp.DistanceText.Color = distance <= 50 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 200, 0)
                esp.DistanceText.Visible = true
            else
                esp.DistanceText.Visible = false
            end
        else
            for _, obj in pairs(esp) do
                obj.Visible = false
            end
        end
    end
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not player or not player.Parent then
            connection:Disconnect()
            for _, obj in pairs(esp) do
                obj:Remove()
            end
            ESPObjects[player] = nil
            return
        end
        Update()
    end)
end

-- Criar ESP para todos os jogadores
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    wait(1)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            obj:Remove()
        end
        ESPObjects[player] = nil
    end
end)

-- Aimbot melhorado (só ativa dentro do FOV)
local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local char = player.Character
            local head = char.Head
            local hum = char:FindFirstChild("Humanoid")
            
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local distance = (centerScreen - screenPos).Magnitude
                    
                    -- SÓ considera se estiver dentro do FOV
                    if distance < Settings.Aimbot.FOV and distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Loop principal
RunService.RenderStepped:Connect(function()
    -- Atualizar FOV Circle (centro da tela)
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = centerScreen
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Visible = Settings.Aimbot.ShowFOV
    
    -- Aimbot (só puxa quando inimigo está dentro do FOV)
    if Settings.Aimbot.Enabled then
        local target = GetClosestPlayerInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local targetPos = head.Position
            
            -- Smooth aimbot
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, Settings.Aimbot.Smoothness)
        end
    end
end)

print("✅ Mod Menu carregado com sucesso!")
print("📌 ESP melhorado com linhas finas")
print("🎯 Aimbot só ativa dentro do FOV")
print("⚠️ Marcação de inimigos próximos ativada")
