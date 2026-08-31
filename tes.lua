local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Данные
local route = {}
local speed = 16
local running = false
local currentIndex = 1
local minimized = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Главное окно (тёмное, как на THUNDERHUB)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 380)
frame.Position = UDim2.new(0.5, -160, 0.5, -190)
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
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.05, 0, 0, 0)
titleText.Text = "МАРШРУТ"
titleText.TextColor3 = Color3.fromRGB(180, 180, 200)
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

-- Кнопка свернуть
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(0.82, 0, 0.08, 0)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
minBtn.TextSize = 20
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

-- Кнопка закрыть
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0.90, 0, 0.08, 0)
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
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.Parent = frame

-- === ПОЛЕ ВВОДА ===
local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(0.85, 0, 0, 20)
inputLabel.Position = UDim2.new(0.075, 0, 0.04, 0)
inputLabel.Text = "КООРДИНАТЫ (X, Y, Z)"
inputLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
inputLabel.TextSize = 11
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.BackgroundTransparency = 1
inputLabel.Parent = content

local input = Instance.new("TextBox")
input.Size = UDim2.new(0.85, 0, 0, 32)
input.Position = UDim2.new(0.075, 0, 0.1, 0)
input.Text = "0, 0, 0"
input.TextColor3 = Color3.fromRGB(200, 200, 220)
input.TextSize = 14
input.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
input.BorderSizePixel = 0
input.Parent = content

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = input

-- === КНОПКА "ДОБАВИТЬ ТОЧКУ" ===
local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0.85, 0, 0, 35)
addBtn.Position = UDim2.new(0.075, 0, 0.2, 0)
addBtn.Text = "ДОБАВИТЬ ТОЧКУ"
addBtn.TextColor3 = Color3.new(1, 1, 1)
addBtn.TextSize = 14
addBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
addBtn.BorderSizePixel = 0
addBtn.Parent = content

local addCorner = Instance.new("UICorner")
addCorner.CornerRadius = UDim.new(0, 4)
addCorner.Parent = addBtn

-- === КОЛИЧЕСТВО ТОЧЕК ===
local pointsLabel = Instance.new("TextLabel")
pointsLabel.Size = UDim2.new(0.85, 0, 0, 25)
pointsLabel.Position = UDim2.new(0.075, 0, 0.31, 0)
pointsLabel.Text = "ТОЧЕК: 0"
pointsLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
pointsLabel.TextSize = 13
pointsLabel.TextXAlignment = Enum.TextXAlignment.Center
pointsLabel.BackgroundTransparency = 1
pointsLabel.Parent = content

-- === СКОРОСТЬ ===
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0, 20)
speedLabel.Position = UDim2.new(0.075, 0, 0.39, 0)
speedLabel.Text = "СКОРОСТЬ"
speedLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = content

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.4, 0, 0, 30)
speedInput.Position = UDim2.new(0.075, 0, 0.43, 0)
speedInput.Text = "16"
speedInput.TextColor3 = Color3.fromRGB(200, 200, 220)
speedInput.TextSize = 14
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
speedInput.BorderSizePixel = 0
speedInput.Parent = content

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 4)
speedCorner.Parent = speedInput

-- === КНОПКИ СТАРТ/СТОП ===
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.4, 0, 0, 35)
startBtn.Position = UDim2.new(0.525, 0, 0.39, 0)
startBtn.Text = "СТАРТ"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.TextSize = 14
startBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
startBtn.BorderSizePixel = 0
startBtn.Parent = content

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 4)
startCorner.Parent = startBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.4, 0, 0, 35)
stopBtn.Position = UDim2.new(0.525, 0, 0.54, 0)
stopBtn.Text = "СТОП"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.TextSize = 14
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.BorderSizePixel = 0
stopBtn.Parent = content

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 4)
stopCorner.Parent = stopBtn

-- === КНОПКА "ОЧИСТИТЬ" ===
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim.new(0.85, 0, 0, 30)
clearBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
clearBtn.Text = "ОЧИСТИТЬ ВСЕ"
clearBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
clearBtn.TextSize = 12
clearBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
clearBtn.BorderSizePixel = 0
clearBtn.Parent = content

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 4)
clearCorner.Parent = clearBtn

-- === СТАТУС ===
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.85, 0, 0, 25)
status.Position = UDim2.new(0.075, 0, 0.78, 0)
status.Text = "ГОТОВ"
status.TextColor3 = Color3.fromRGB(100, 200, 100)
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Center
status.BackgroundTransparency = 1
status.Parent = content

-- === ФУНКЦИИ ===
local function updatePointsLabel()
    pointsLabel.Text = "ТОЧЕК: " .. #route
end

addBtn.MouseButton1Click:Connect(function()
    local coords = {}
    for num in string.gmatch(input.Text, "[-%d.]+") do
        table.insert(coords, tonumber(num))
    end
    if #coords >= 3 then
        table.insert(route, Vector3.new(coords[1], coords[2], coords[3]))
        status.Text = "Точка " .. #route .. " добавлена"
        status.TextColor3 = Color3.fromRGB(100, 200, 100)
        updatePointsLabel()
    else
        status.Text = "ОШИБКА: Введи X, Y, Z"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    route = {}
    status.Text = "Маршрут очищен"
    status.TextColor3 = Color3.fromRGB(200, 200, 100)
    updatePointsLabel()
end)

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and val > 0 then
        speed = val
        status.Text = "Скорость: " .. speed
        status.TextColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

-- === ДВИЖЕНИЕ ===
local function moveToNext()
    if not running or #route == 0 then return end
    if currentIndex > #route then
        currentIndex = 1
        status.Text = "Маршрут завершён, повтор"
        status.TextColor3 = Color3.fromRGB(200, 200, 100)
        wait(1)
    end
    
    local target = route[currentIndex]
    if target and char and char:FindFirstChild("HumanoidRootPart") then
        humanoid.WalkSpeed = speed
        humanoid:MoveTo(target)
        
        status.Text = "Иду к точке " .. currentIndex .. "/" .. #route
        status.TextColor3 = Color3.fromRGB(100, 200, 255)
        
        repeat
            task.wait()
            if not running then break end
        until (char.HumanoidRootPart.Position - target).Magnitude < 5 or not running
        
        currentIndex = currentIndex + 1
        task.wait(0.2)
        moveToNext()
    end
end

startBtn.MouseButton1Click:Connect(function()
    if #route == 0 then 
        status.Text = "ОШИБКА: Нет точек!"
        status.TextColor3 = Color3.fromRGB(200, 80, 80)
        return 
    end
    running = true
    currentIndex = 1
    status.Text = "Забег начат..."
    status.TextColor3 = Color3.fromRGB(100, 200, 100)
    moveToNext()
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    humanoid.WalkSpeed = 16
    status.Text = "Остановлен"
    status.TextColor3 = Color3.fromRGB(200, 200, 100)
end)

-- === УПРАВЛЕНИЕ ОКНОМ ===
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    minBtn.Text = minimized and "+" or "–"
    if minimized then
        frame.Size = UDim2.new(0, 320, 0, 45)
    else
        frame.Size = UDim2.new(0, 320, 0, 380)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

print("✅ Маршрут-меню загружено")
