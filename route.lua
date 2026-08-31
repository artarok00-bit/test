local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Данные
local savedPosition = nil
local speed = 50
local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local minimized = false
local noclipMode = false
local flyDelay = 0

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Окно
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 480)
frame.Position = UDim2.new(0.5, -190, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.05, 0, 0, 0)
titleText.Text = "🧭 НАВИГАТОР"
titleText.TextColor3 = Color3.fromRGB(180, 180, 200)
titleText.TextSize = 20
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(0.82, 0, 0.06, 0)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
minBtn.TextSize = 22
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(0.90, 0, 0.06, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Контент
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.Parent = frame

-- Текущая позиция
local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(0.9, 0, 0, 25)
posLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
posLabel.Text = "📍 Текущая позиция: 0, 0, 0"
posLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
posLabel.TextSize = 13
posLabel.TextXAlignment = Enum.TextXAlignment.Center
posLabel.BackgroundTransparency = 1
posLabel.Parent = content

-- Ввод координат
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0.9, 0, 0, 22)
coordLabel.Position = UDim2.new(0.05, 0, 0.08, 0)
coordLabel.Text = "ВВЕДИТЕ КООРДИНАТЫ (X, Y, Z)"
coordLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
coordLabel.TextSize = 12
coordLabel.TextXAlignment = Enum.TextXAlignment.Left
coordLabel.BackgroundTransparency = 1
coordLabel.Parent = content

local xInput = Instance.new("TextBox")
xInput.Size = UDim2.new(0.28, 0, 0, 34)
xInput.Position = UDim2.new(0.05, 0, 0.14, 0)
xInput.Text = "0"
xInput.TextColor3 = Color3.fromRGB(200, 200, 220)
xInput.TextSize = 15
xInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
xInput.BorderSizePixel = 0
xInput.Parent = content

local xCorner = Instance.new("UICorner")
xCorner.CornerRadius = UDim.new(0, 5)
xCorner.Parent = xInput

local yInput = Instance.new("TextBox")
yInput.Size = UDim2.new(0.28, 0, 0, 34)
yInput.Position = UDim2.new(0.36, 0, 0.14, 0)
yInput.Text = "0"
yInput.TextColor3 = Color3.fromRGB(200, 200, 220)
yInput.TextSize = 15
yInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
yInput.BorderSizePixel = 0
yInput.Parent = content

local yCorner = Instance.new("UICorner")
yCorner.CornerRadius = UDim.new(0, 5)
yCorner.Parent = yInput

local zInput = Instance.new("TextBox")
zInput.Size = UDim2.new(0.28, 0, 0, 34)
zInput.Position = UDim2.new(0.67, 0, 0.14, 0)
zInput.Text = "0"
zInput.TextColor3 = Color3.fromRGB(200, 200, 220)
zInput.TextSize = 15
zInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
zInput.BorderSizePixel = 0
zInput.Parent = content

local zCorner = Instance.new("UICorner")
zCorner.CornerRadius = UDim.new(0, 5)
zCorner.Parent = zInput

-- Кнопки сохранения
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.42, 0, 0, 36)
saveBtn.Position = UDim2.new(0.05, 0, 0.24, 0)
saveBtn.Text = "📌 ЗАПОМНИТЬ"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.TextSize = 14
saveBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
saveBtn.BorderSizePixel = 0
saveBtn.Parent = content

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

local myPosBtn = Instance.new("TextButton")
myPosBtn.Size = UDim2.new(0.42, 0, 0, 36)
myPosBtn.Position = UDim2.new(0.53, 0, 0.24, 0)
myPosBtn.Text = "📍 МОИ КООРДИНАТЫ"
myPosBtn.TextColor3 = Color3.new(1, 1, 1)
myPosBtn.TextSize = 14
myPosBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
myPosBtn.BorderSizePixel = 0
myPosBtn.Parent = content

local myPosCorner = Instance.new("UICorner")
myPosCorner.CornerRadius = UDim.new(0, 6)
myPosCorner.Parent = myPosBtn

local pointStatus = Instance.new("TextLabel")
pointStatus.Size = UDim2.new(0.9, 0, 0, 22)
pointStatus.Position = UDim2.new(0.05, 0, 0.32, 0)
pointStatus.Text = "❌ Точка не задана"
pointStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
pointStatus.TextSize = 13
pointStatus.TextXAlignment = Enum.TextXAlignment.Center
pointStatus.BackgroundTransparency = 1
pointStatus.Parent = content

-- Обход
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.85, 0, 0, 34)
noclipBtn.Position = UDim2.new(0.075, 0, 0.38, 0)
noclipBtn.Text = "🚧 ОБХОД: ВЫКЛ"
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.TextSize = 13
noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
noclipBtn.BorderSizePixel = 0
noclipBtn.Parent = content

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 6)
noclipCorner.Parent = noclipBtn

-- Скорость
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0.47, 0)
speedLabel.Text = "🚀 СКОРОСТЬ"
speedLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = content

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.35, 0, 0, 32)
speedInput.Position = UDim2.new(0.05, 0, 0.51, 0)
speedInput.Text = "50"
speedInput.TextColor3 = Color3.fromRGB(200, 200, 220)
speedInput.TextSize = 15
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
speedInput.BorderSizePixel = 0
speedInput.Parent = content

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 5)
speedCorner.Parent = speedInput

-- Задержка
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0.4, 0, 0, 20)
delayLabel.Position = UDim2.new(0.50, 0, 0.47, 0)
delayLabel.Text = "⏱ ЗАДЕРЖКА (мс)"
delayLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
delayLabel.TextSize = 12
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.BackgroundTransparency = 1
delayLabel.Parent = content

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0.35, 0, 0, 32)
delayInput.Position = UDim2.new(0.50, 0, 0.51, 0)
delayInput.Text = "0"
delayInput.TextColor3 = Color3.fromRGB(200, 200, 220)
delayInput.TextSize = 15
delayInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
delayInput.BorderSizePixel = 0
delayInput.Parent = content

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 5)
delayCorner.Parent = delayInput

-- Кнопки Лететь/Стоп
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.42, 0, 0, 40)
flyBtn.Position = UDim2.new(0.05, 0, 0.61, 0)
flyBtn.Text = "🚀 ЛЕТЕТЬ"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.TextSize = 16
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
flyBtn.BorderSizePixel = 0
flyBtn.Parent = content

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 7)
flyCorner.Parent = flyBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.42, 0, 0, 40)
stopBtn.Position = UDim2.new(0.53, 0, 0.61, 0)
stopBtn.Text = "⏹ СТОП"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.TextSize = 16
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.BorderSizePixel = 0
stopBtn.Parent = content

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 7)
stopCorner.Parent = stopBtn

-- Статус
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 30)
status.Position = UDim2.new(0.05, 0, 0.73, 0)
status.Text = "🟢 ГОТОВ"
status.TextColor3 = Color3.fromRGB(100, 200, 100)
status.TextSize = 15
status.TextXAlignment = Enum.TextXAlignment.Center
status.BackgroundTransparency = 1
status.Parent = content

-- Подсказка
local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(0.9, 0, 0, 40)
hint.Position = UDim2.new(0.05, 0, 0.83, 0)
hint.Text = "💡 Введи координаты → Запомнить\nили нажми 'Мои координаты' → Лететь"
hint.TextColor3 = Color3.fromRGB(100, 100, 120)
hint.TextSize = 11
hint.TextXAlignment = Enum.TextXAlignment.Center
hint.BackgroundTransparency = 1
hint.Parent = content

-- ===== ФУНКЦИИ =====

local function updatePos()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        posLabel.Text = string.format("📍 Текущая позиция: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
    end
end

spawn(function()
    while true do
        task.wait(0.5)
        updatePos()
    end
end)

-- ===== ОБХОД =====

noclipBtn.MouseButton1Click:Connect(function()
    noclipMode = not noclipMode
    if noclipMode then
        noclipBtn.Text = "🚧 ОБХОД: ВКЛ"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        status.Text = "🟢 Обход ВКЛЮЧЁН"
        status.TextColor3 = Color3.fromRGB(100, 200, 100)
    else
        noclipBtn.Text = "🚧 ОБХОД: ВЫКЛ"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "🟡 Обход ВЫКЛЮЧЁН"
        status.TextColor3 = Color3.fromRGB(200, 200, 100)
    end
end)

-- ===== ПОЛНОЦЕННЫЙ ОБХОД С RAYCAST =====

local function getNextDirection(currentPos, targetPos, currentDir, previousDirs)
    local dir = (targetPos - currentPos).Unit
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.IgnoreWater = true
    
    -- Проверяем препятствие впереди
    local forwardRay = workspace:Raycast(currentPos + Vector3.new(0, 1, 0), dir * 6, raycastParams)
    
    if forwardRay and forwardRay.Distance < 5 then
        -- Есть препятствие! Пытаемся обойти
        
        -- Получаем нормаль поверхности
        local normal = forwardRay.Normal
        local obstaclePos = forwardRay.Position
        
        -- Варианты обхода: влево, вправо, вверх
        local directions = {}
        
        -- Влево (относительно направления)
        local leftDir = Vector3.new(-dir.Z, 0, dir.X).Unit
        table.insert(directions, leftDir)
        
        -- Вправо
        local rightDir = Vector3.new(dir.Z, 0, -dir.X).Unit
        table.insert(directions, rightDir)
        
        -- Вверх
        table.insert(directions, Vector3.new(0, 1, 0))
        
        -- Вверх + влево
        table.insert(directions, (Vector3.new(0, 1, 0) + leftDir).Unit)
        
        -- Вверх + вправо
        table.insert(directions, (Vector3.new(0, 1, 0) + rightDir).Unit)
        
        -- Проверяем каждый вариант
        for _, testDir in ipairs(directions) do
            local testPos = currentPos + testDir * 4
            local testRay = workspace:Raycast(testPos + Vector3.new(0, 1, 0), Vector3.new(0, -3, 0), raycastParams)
            
            if not testRay then
                return testDir
            end
        end
        
        -- Если ничего не подошло — летим вверх
        return Vector3.new(0, 1, 0)
    end
    
    return dir
end

-- ===== ЗАПОМНИТЬ ТОЧКУ =====

saveBtn.MouseButton1Click:Connect(function()
    local x = tonumber(xInput.Text) or 0
    local y = tonumber(yInput.Text) or 0
    local z = tonumber(zInput.Text) or 0
    
    savedPosition = Vector3.new(x, y, z)
    pointStatus.Text = string.format("✅ Точка сохранена: %.1f, %.1f, %.1f", x, y, z)
    pointStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
    status.Text = "✅ Точка сохранена!"
    status.TextColor3 = Color3.fromRGB(100, 200, 100)
end)

-- ===== МОИ КООРДИНАТЫ =====

myPosBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        savedPosition = pos
        xInput.Text = string.format("%.1f", pos.X)
        yInput.Text = string.format("%.1f", pos.Y)
        zInput.Text = string.format("%.1f", pos.Z)
        pointStatus.Text = string.format("✅ Мои координаты: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        pointStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
        status.Text = "✅ Координаты запомнены!"
        status.TextColor3 = Color3.fromRGB(100, 200, 100)
    else
        status.Text = "❌ Персонаж не найден"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
    end
end)

-- ===== ЛЕТЕТЬ =====

flyBtn.MouseButton1Click:Connect(function()
    if not savedPosition then
        status.Text = "❌ ОШИБКА: Нет сохранённой точки!"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        status.Text = "❌ ОШИБКА: Персонаж не найден"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    
    -- Задержка
    local delayMs = tonumber(delayInput.Text) or 0
    if delayMs > 0 then
        status.Text = "⏳ Задержка " .. delayMs .. " мс..."
        status.TextColor3 = Color3.fromRGB(200, 200, 100)
        task.wait(delayMs / 1000)
    end
    
    -- ОТКЛЮЧАЕМ ГРАВИТАЦИЮ
    humanoid.PlatformStand = true
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Parent = char.HumanoidRootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.CFrame = char.HumanoidRootPart.CFrame
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.Parent = char.HumanoidRootPart
    
    flying = true
    
    if noclipMode then
        status.Text = "🧭 Обход препятствий..."
        status.TextColor3 = Color3.fromRGB(100, 200, 255)
    else
        status.Text = "✈️ Прямой полёт..."
        status.TextColor3 = Color3.fromRGB(100, 200, 255)
    end
    
    local currentSpeed = tonumber(speedInput.Text) or 50
    local lastDirection = nil
    
    spawn(function()
        while flying and char and char:FindFirstChild("HumanoidRootPart") do
            local currentPos = char.HumanoidRootPart.Position
            local distance = (savedPosition - currentPos).Magnitude
            
            if distance < 3 then
                flying = false
                if bodyVelocity then bodyVelocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
                
                humanoid.PlatformStand = false
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
                
                status.Text = "✅ ПРИЛЕТЕЛ!"
                status.TextColor3 = Color3.fromRGB(100, 200, 100)
                break
            end
            
            local direction
            
            if noclipMode then
                -- ОБХОД ПРЕПЯТСТВИЙ
                direction = getNextDirection(currentPos, savedPosition, (savedPosition - currentPos).Unit)
            else
                -- ПРЯМОЙ ПОЛЁТ
                direction = (savedPosition - currentPos).Unit
            end
            
            if bodyVelocity then
                bodyVelocity.Velocity = direction * currentSpeed
            end
            
            task.wait()
        end
        
        -- Если полёт прерван
        if flying then
            flying = false
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            
            humanoid.PlatformStand = false
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            
            status.Text = "⏹ ОСТАНОВЛЕН"
            status.TextColor3 = Color3.fromRGB(200, 200, 100)
        end
    end)
end)

-- ===== СТОП =====

stopBtn.MouseButton1Click:Connect(function()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    humanoid.PlatformStand = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    
    status.Text = "⏹ ОСТАНОВЛЕН"
    status.TextColor3 = Color3.fromRGB(200, 200, 100)
end)

-- ===== УПРАВЛЕНИЕ ОКНОМ =====

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    minBtn.Text = minimized and "+" or "–"
    frame.Size = minimized and UDim2.new(0, 380, 0, 45) or UDim2.new(0, 380, 0, 480)
end)

closeBtn.MouseButton1Click:Connect(function()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    humanoid.PlatformStand = false
    screenGui:Destroy()
end)

print("✅ Навигатор загружен! Обход работает через Raycast.")
