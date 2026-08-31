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
local pathPoints = {}
local noclipMode = false
local flyDelay = 0 -- задержка в миллисекундах

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Окно
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0.5, -160, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.05, 0, 0, 0)
titleText.Text = "🧭 НАВИГАТОР"
titleText.TextColor3 = Color3.fromRGB(180, 180, 200)
titleText.TextSize = 18
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

-- ===== ВВОД КООРДИНАТ (3 ПОЛЯ) =====

local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0.9, 0, 0, 20)
coordLabel.Position = UDim2.new(0.05, 0, 0.02, 0)
coordLabel.Text = "КООРДИНАТЫ ТОЧКИ (X, Y, Z)"
coordLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
coordLabel.TextSize = 12
coordLabel.TextXAlignment = Enum.TextXAlignment.Left
coordLabel.BackgroundTransparency = 1
coordLabel.Parent = content

local xInput = Instance.new("TextBox")
xInput.Size = UDim2.new(0.28, 0, 0, 32)
xInput.Position = UDim2.new(0.05, 0, 0.08, 0)
xInput.Text = "0"
xInput.TextColor3 = Color3.fromRGB(200, 200, 220)
xInput.TextSize = 14
xInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
xInput.BorderSizePixel = 0
xInput.Parent = content

local xCorner = Instance.new("UICorner")
xCorner.CornerRadius = UDim.new(0, 4)
xCorner.Parent = xInput

local yInput = Instance.new("TextBox")
yInput.Size = UDim2.new(0.28, 0, 0, 32)
yInput.Position = UDim2.new(0.36, 0, 0.08, 0)
yInput.Text = "0"
yInput.TextColor3 = Color3.fromRGB(200, 200, 220)
yInput.TextSize = 14
yInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
yInput.BorderSizePixel = 0
yInput.Parent = content

local yCorner = Instance.new("UICorner")
yCorner.CornerRadius = UDim.new(0, 4)
yCorner.Parent = yInput

local zInput = Instance.new("TextBox")
zInput.Size = UDim2.new(0.28, 0, 0, 32)
zInput.Position = UDim2.new(0.67, 0, 0.08, 0)
zInput.Text = "0"
zInput.TextColor3 = Color3.fromRGB(200, 200, 220)
zInput.TextSize = 14
zInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
zInput.BorderSizePixel = 0
zInput.Parent = content

local zCorner = Instance.new("UICorner")
zCorner.CornerRadius = UDim.new(0, 4)
zCorner.Parent = zInput

-- ===== КНОПКИ =====

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.85, 0, 0, 35)
saveBtn.Position = UDim2.new(0.075, 0, 0.17, 0)
saveBtn.Text = "📌 ЗАПОМНИТЬ ТОЧКУ"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.TextSize = 14
saveBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
saveBtn.BorderSizePixel = 0
saveBtn.Parent = content

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

local pointStatus = Instance.new("TextLabel")
pointStatus.Size = UDim2.new(0.9, 0, 0, 20)
pointStatus.Position = UDim2.new(0.05, 0, 0.25, 0)
pointStatus.Text = "Точка не задана"
pointStatus.TextColor3 = Color3.fromRGB(200, 80, 80)
pointStatus.TextSize = 12
pointStatus.TextXAlignment = Enum.TextXAlignment.Center
pointStatus.BackgroundTransparency = 1
pointStatus.Parent = content

-- ===== ОБХОД =====

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.85, 0, 0, 32)
noclipBtn.Position = UDim2.new(0.075, 0, 0.32, 0)
noclipBtn.Text = "🚧 ОБХОД: ВЫКЛ"
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.TextSize = 13
noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
noclipBtn.BorderSizePixel = 0
noclipBtn.Parent = content

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 6)
noclipCorner.Parent = noclipBtn

-- ===== СКОРОСТЬ =====

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0, 18)
speedLabel.Position = UDim2.new(0.075, 0, 0.41, 0)
speedLabel.Text = "СКОРОСТЬ"
speedLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = content

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.35, 0, 0, 30)
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

-- ===== ЗАДЕРЖКА =====

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0.4, 0, 0, 18)
delayLabel.Position = UDim2.new(0.5, 0, 0.41, 0)
delayLabel.Text = "ЗАДЕРЖКА (мс)"
delayLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
delayLabel.TextSize = 11
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.BackgroundTransparency = 1
delayLabel.Parent = content

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0.35, 0, 0, 30)
delayInput.Position = UDim2.new(0.5, 0, 0.44, 0)
delayInput.Text = "0"
delayInput.TextColor3 = Color3.fromRGB(200, 200, 220)
delayInput.TextSize = 14
delayInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
delayInput.BorderSizePixel = 0
delayInput.Parent = content

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 4)
delayCorner.Parent = delayInput

-- ===== КНОПКИ ЛЕТЕТЬ/СТОП =====

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.4, 0, 0, 38)
flyBtn.Position = UDim2.new(0.075, 0, 0.54, 0)
flyBtn.Text = "🚀 ЛЕТЕТЬ"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.TextSize = 15
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
flyBtn.BorderSizePixel = 0
flyBtn.Parent = content

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.4, 0, 0, 38)
stopBtn.Position = UDim2.new(0.525, 0, 0.54, 0)
stopBtn.Text = "⏹ СТОП"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.TextSize = 15
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.BorderSizePixel = 0
stopBtn.Parent = content

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn

-- ===== СТАТУС =====

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 25)
status.Position = UDim2.new(0.05, 0, 0.7, 0)
status.Text = "ГОТОВ"
status.TextColor3 = Color3.fromRGB(100, 200, 100)
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Center
status.BackgroundTransparency = 1
status.Parent = content

-- ===== КООРДИНАТЫ ТЕКУЩИЕ =====

local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(0.9, 0, 0, 20)
posLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
posLabel.Text = "Позиция: 0, 0, 0"
posLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
posLabel.TextSize = 12
posLabel.TextXAlignment = Enum.TextXAlignment.Center
posLabel.BackgroundTransparency = 1
posLabel.Parent = content

-- ===== ФУНКЦИИ =====

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

-- ===== ОБХОД =====

noclipBtn.MouseButton1Click:Connect(function()
    noclipMode = not noclipMode
    if noclipMode then
        noclipBtn.Text = "🚧 ОБХОД: ВКЛ"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        status.Text = "Обход ВКЛЮЧЁН"
        status.TextColor3 = Color3.fromRGB(100, 200, 100)
    else
        noclipBtn.Text = "🚧 ОБХОД: ВЫКЛ"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "Обход ВЫКЛЮЧЁН"
        status.TextColor3 = Color3.fromRGB(200, 200, 100)
    end
end)

-- ===== ПОСТРОЕНИЕ ПУТИ =====

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
        local rayOrigin = currentPos + Vector3.new(0, 2, 0)
        local rayDirection = dirUnit * 8
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {player.Character}
        raycastParams.IgnoreWater = true
        local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if rayResult and rayResult.Distance < 6 then
            local leftDir = Vector3.new(-dirUnit.Z, 0, dirUnit.X).Unit
            local leftPos = currentPos + (dirUnit + leftDir * 2).Unit * 4
            leftPos = Vector3.new(leftPos.X, currentPos.Y, leftPos.Z)
            local leftRay = workspace:Raycast(leftPos + Vector3.new(0, 2, 0), Vector3.new(0, -4, 0), raycastParams)
            if not leftRay then
                table.insert(path, leftPos)
                currentPos = leftPos
                status.Text = "Обход слева..."
                continue
            end
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
            local upPos = currentPos + Vector3.new(0, 8, 0)
            table.insert(path, upPos)
            currentPos = upPos
            status.Text = "Обход сверху..."
        else
            local nextPos = currentPos + dirUnit * 5
            nextPos = Vector3.new(nextPos.X, currentPos.Y, nextPos.Z)
            table.insert(path, nextPos)
            currentPos = nextPos
        end
    end
    table.insert(path, endPos)
    return path
end

-- ===== ЗАПОМНИТЬ ТОЧКУ =====

saveBtn.MouseButton1Click:Connect(function()
    local x = tonumber(xInput.Text) or 0
    local y = tonumber(yInput.Text) or 0
    local z = tonumber(zInput.Text) or 0
    
    savedPosition = Vector3.new(x, y, z)
    pointStatus.Text = string.format("✅ Точка: %.1f, %.1f, %.1f", x, y, z)
    pointStatus.TextColor3 = Color3.fromRGB(100, 200, 100)
    status.Text = "Точка сохранена!"
    status.TextColor3 = Color3.fromRGB(100, 200, 100)
end)

-- ===== ЛЕТЕТЬ =====

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
    
    -- Задержка перед полётом
    local delayMs = tonumber(delayInput.Text) or 0
    if delayMs > 0 then
        status.Text = "Задержка " .. delayMs .. " мс..."
        status.TextColor3 = Color3.fromRGB(200, 200, 100)
        task.wait(delayMs / 1000)
    end
    
    local pointsToFollow = {savedPosition}
    if noclipMode then
        local startPos = char.HumanoidRootPart.Position
        pathPoints = findPath(startPos, savedPosition, 40)
        if #pathPoints < 2 then
            status.Text = "ОШИБКА: Не могу построить маршрут"
            status.TextColor3 = Color3.fromRGB(200, 80, 80)
            return
        end
        pointsToFollow = pathPoints
        status.Text = "Маршрут построен! " .. #pathPoints .. " точек"
        status.TextColor3 = Color3.fromRGB(100, 200, 255)
    else
        status.Text = "Летим напрямую"
        status.TextColor3 = Color3.fromRGB(100, 200, 255)
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
    local pointIndex = 2
    
    spawn(function()
        while flying and char and char:FindFirstChild("HumanoidRootPart") and pointIndex <= #pointsToFollow do
            local targetPos = pointsToFollow[pointIndex]
            local currentPos = char.HumanoidRootPart.Position
            local distance = (targetPos - currentPos).Magnitude
            
            if distance < 4 then
                pointIndex = pointIndex + 1
                if pointIndex <= #pointsToFollow then
                    status.Text = "Точка " .. pointIndex .. "/" .. #pointsToFollow
                end
                continue
            end
            
            local direction = (targetPos - currentPos).Unit
            local currentSpeed = tonumber(speedInput.Text) or 50
            if bodyVelocity then
                bodyVelocity.Velocity = direction * currentSpeed
            end
            task.wait()
        end
        
        flying = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        
        if pointIndex > #pointsToFollow then
            status.Text = "✅ ПРИЛЕТЕЛ!"
            status.TextColor3 = Color3.fromRGB(100, 200, 100)
        else
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
    frame.Size = minimized and UDim2.new(0, 320, 0, 40) or UDim2.new(0, 320, 0, 400)
end)

closeBtn.MouseButton1Click:Connect(function()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    humanoid.PlatformStand = false
    screenGui:Destroy()
end)

print("✅ Навигатор загружен! Вводи координаты вручную, ставь задержку и лети.")
