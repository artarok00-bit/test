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
local currentTarget = nil
local pathPoints = {}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Окно
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 280)
frame.Position = UDim2.new(0.5, -140, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.05, 0, 0, 0)
titleText.Text = "🧭 ОБХОД ПРЕПЯТСТВИЙ"
titleText.TextColor3 = Color3.fromRGB(180, 180, 200)
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(0.82, 0, 0.05, 0)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
minBtn.TextSize = 20
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0.90, 0, 0.05, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- Контент
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.Parent = frame

-- Координаты
local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(0.9, 0, 0, 25)
posLabel.Position = UDim2.new(0.05, 0, 0.03, 0)
posLabel.Text = "Позиция: 0, 0, 0"
posLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
posLabel.TextSize = 12
posLabel.TextXAlignment = Enum.TextXAlignment.Center
posLabel.BackgroundTransparency = 1
posLabel.Parent = content

-- Кнопка "Запомнить точку"
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.85, 0, 0, 40)
saveBtn.Position = UDim2.new(0.075, 0, 0.15, 0)
saveBtn.Text = "📌 ЗАПОМНИТЬ ТОЧКУ"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.TextSize = 15
saveBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
saveBtn.BorderSizePixel = 0
saveBtn.Parent = content

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

-- Статус точки
local pointStatus = Instance.new("TextLabel")
pointStatus.Size = UDim2.new(0.9, 0, 0, 25)
pointStatus.Position = UDim2.new(0.05, 0, 0.3, 0)
pointStatus.Text = "Точка не задана"
pointStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
pointStatus.TextSize = 13
pointStatus.TextXAlignment = Enum.TextXAlignment.Center
pointStatus.BackgroundTransparency = 1
pointStatus.Parent = content

-- Скорость
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0, 20)
speedLabel.Position = UDim2.new(0.075, 0, 0.4, 0)
speedLabel.Text = "СКОРОСТЬ"
speedLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = content

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.4, 0, 0, 30)
speedInput.Position = UDim2.new(0.075, 0, 0.44, 0)
speedInput.Text = "50"
speedInput.TextColor3 = Color3.fromRGB(200, 200, 220)
speedInput.TextSize = 14
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
speedInput.BorderSizePixel = 0
speedInput.Parent = content

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 4)
speedCorner.Parent = speedInput

-- Кнопка "Лететь"
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.4, 0, 0, 40)
flyBtn.Position = UDim2.new(0.525, 0, 0.4, 0)
flyBtn.Text = "🚀 ЛЕТЕТЬ"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.TextSize = 15
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
flyBtn.BorderSizePixel = 0
flyBtn.Parent = content

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyBtn

-- Кнопка "Стоп"
local stopFlyBtn = Instance.new("TextButton")
stopFlyBtn.Size = UDim2.new(0.4, 0, 0, 35)
stopFlyBtn.Position = UDim2.new(0.525, 0, 0.58, 0)
stopFlyBtn.Text = "⏹ СТОП"
stopFlyBtn.TextColor3 = Color3.new(1, 1, 1)
stopFlyBtn.TextSize = 14
stopFlyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopFlyBtn.BorderSizePixel = 0
stopFlyBtn.Parent = content

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopFlyBtn

-- Статус
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 25)
status.Position = UDim2.new(0.05, 0, 0.78, 0)
status.Text = "ГОТОВ"
status.TextColor3 = Color3.fromRGB(100, 200, 100)
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Center
status.BackgroundTransparency = 1
status.Parent = content

-- ===== ФУНКЦИЯ ОБХОДА ПРЕПЯТСТВИЙ =====

local function findPath(startPos, endPos, maxAttempts)
    maxAttempts = maxAttempts or 30
    local attempts = 0
    local currentPos = startPos
    local path = {startPos}
    
    while attempts < maxAttempts do
        attempts = attempts + 1
        
        local direction = (endPos - currentPos)
        local distance = direction.Magnitude
        
        if distance < 5 then
            table.insert(path, endPos)
            return path
        end
        
        local dirUnit = direction.Unit
        
        -- Проверяем, есть ли препятствие впереди
        local rayOrigin = currentPos + Vector3.new(0, 2, 0)
        local rayDirection = dirUnit * 8
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {player.Character}
        raycastParams.IgnoreWater = true
        
        local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if rayResult and rayResult.Distance < 6 then
            -- Есть препятствие! Облетаем его
            
            -- Пытаемся обойти слева
            local leftDir = Vector3.new(-dirUnit.Z, 0, dirUnit.X).Unit
            local leftPos = currentPos + (dirUnit + leftDir * 2).Unit * 4
            leftPos = Vector3.new(leftPos.X, currentPos.Y, leftPos.Z)
            
            -- Проверяем, свободно ли слева
            local leftRay = workspace:Raycast(leftPos + Vector3.new(0, 2, 0), Vector3.new(0, -4, 0), raycastParams)
            
            if not leftRay then
                table.insert(path, leftPos)
                currentPos = leftPos
                status.Text = "Обход слева..."
                continue
            end
            
            -- Пытаемся обойти справа
            local rightDir = Vector3.new(dirUnit.Z, 0, -dirUnit.X).Unit
            local rightPos = currentPos + (dirUnit + rightDir * 2).Unit * 4
            rightPos = Vector3.new(rightPos.X, currentPos.Y, rightPos.Z)
            
            local rightRay = workspace:Raycast(rightPos + Vector3.new(0, 2, 0), Vector3.new(0, -4, 0), raycastParams)
            
            if not rightRay then
                table.insert(path, rightPos)
                currentPos = rightPos
                status.Text = "Обход справа..."
                continue
            end
            
            -- Если ни слева ни справа не свободно — летим вверх
            local upPos = currentPos + Vector3.new(0, 8, 0)
            table.insert(path, upPos)
            currentPos = upPos
            status.Text = "Обход сверху..."
        else
            -- Двигаемся вперёд
            local nextPos = currentPos + dirUnit * 5
            nextPos = Vector3.new(nextPos.X, currentPos.Y, nextPos.Z)
            table.insert(path, nextPos)
            currentPos = nextPos
        end
    end
    
    -- Если не нашли путь — просто летим напрямую
    table.insert(path, endPos)
    return path
end

-- ===== ОСНОВНЫЕ ФУНКЦИИ =====

local function updatePos()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        posLabel.Text = string.format("Позиция: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
    end
end

spawn(function()
    while true do
        task.wait(0.5)
        updatePos()
    end
end)

-- Запомнить точку
saveBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.Position
        pointStatus.Text = string.format("✅ Точка: %.1f, %.1f, %.1f", savedPosition.X, savedPosition.Y, savedPosition.Z)
        pointStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
        status.Text = "Точка сохранена!"
        status.TextColor3 = Color3.fromRGB(100, 200, 100)
    else
        status.Text = "ОШИБКА: Персонаж не найден"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
    end
end)

-- Лететь с обходом препятствий
flyBtn.MouseButton1Click:Connect(function()
    if not savedPosition then
        status.Text = "ОШИБКА: Нет сохранённой точки!"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        status.Text = "ОШИБКА: Персонаж не найден"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    
    -- Строим маршрут с обходом препятствий
    local startPos = char.HumanoidRootPart.Position
    pathPoints = findPath(startPos, savedPosition, 40)
    
    if #pathPoints < 2 then
        status.Text = "ОШИБКА: Не могу построить маршрут"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end
    
    status.Text = "Маршрут построен! " .. #pathPoints .. " точек"
    status.TextColor3 = Color3.fromRGB(100, 200, 255)
    
    -- Отключаем гравитацию
    humanoid.PlatformStand = true
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    
    -- Удаляем старые Velocity
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    -- Создаём BodyVelocity
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Parent = char.HumanoidRootPart
    
    -- Создаём BodyGyro
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.CFrame = char.HumanoidRootPart.CFrame
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.Parent = char.HumanoidRootPart
    
    flying = true
    local pointIndex = 2 -- начинаем со второй точки (первая - текущая позиция)
    
    spawn(function()
        while flying and char and char:FindFirstChild("HumanoidRootPart") and pointIndex <= #pathPoints do
            local targetPos = pathPoints[pointIndex]
            local currentPos = char.HumanoidRootPart.Position
            local distance = (targetPos - currentPos).Magnitude
            
            if distance < 4 then
                pointIndex = pointIndex + 1
                if pointIndex <= #pathPoints then
                    status.Text = "Точка " .. pointIndex .. "/" .. #pathPoints
                end
                continue
            end
            
            -- Скорость
            local direction = (targetPos - currentPos).Unit
            local currentSpeed = speed
            
            local speedVal = tonumber(speedInput.Text)
            if speedVal and speedVal > 0 then
                currentSpeed = speedVal
                speed = speedVal
            end
            
            if bodyVelocity then
                bodyVelocity.Velocity = direction * currentSpeed
            end
            
            task.wait()
        end
        
        -- Прилетели
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        -- Включаем гравитацию
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        
        if pointIndex > #pathPoints then
            status.Text = "✅ ПРИЛЕТЕЛ!"
            status.TextColor3 = Color3.fromRGB(100, 200, 100)
        else
            status.Text = "⏹ ОСТАНОВЛЕН"
            status.TextColor3 = Color3.fromRGB(200, 200, 100)
        end
    end)
end)

-- Стоп
stopFlyBtn.MouseButton1Click:Connect(function()
    flying = false
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    humanoid.PlatformStand = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    
    status.Text = "⏹ ОСТАНОВЛЕН"
    status.TextColor3 = Color3.fromRGB(200, 200, 100)
end)

-- Скорость
speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and val > 0 then
        speed = val
        status.Text = "Скорость: " .. speed
        status.TextColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

-- Управление окном
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    minBtn.Text = minimized and "+" or "–"
    if minimized then
        frame.Size = UDim2.new(0, 280, 0, 40)
    else
        frame.Size = UDim2.new(0, 280, 0, 280)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    flying = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    humanoid.PlatformStand = false
    screenGui:Destroy()
end)

print("✅ Обход препятствий загружен! Персонаж облетает стены.")
