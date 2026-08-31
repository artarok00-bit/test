local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Данные
local route = {}
local speed = 16
local running = false
local currentIndex = 1
local minimized = false
local selectedColor = Color3.fromRGB(30, 144, 255) -- синий по умолчанию

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Главное окно (с закруглениями)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 320)
frame.Position = UDim2.new(0.5, -175, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Скругление (углы)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Заголовок (шапка)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.05, 0, 0, 0)
titleText.Text = "🚀 Маршрут-меню"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

-- Кнопка свернуть
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
minBtn.Text = "➖"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.TextSize = 16
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minBtn

-- Кнопка закрыть
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0.92, 0, 0.05, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Основное содержимое (скрывается при сворачивании)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.Parent = frame

-- Вкладки
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 35)
tabBar.BackgroundTransparency = 1
tabBar.Parent = content

local routeTab = Instance.new("TextButton")
routeTab.Size = UDim2.new(0.5, -1, 1, 0)
routeTab.Position = UDim2.new(0, 0, 0, 0)
routeTab.Text = "📍 Маршрут"
routeTab.TextColor3 = Color3.new(1, 1, 1)
routeTab.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
routeTab.BorderSizePixel = 0
routeTab.Parent = tabBar

local routeTabCorner = Instance.new("UICorner")
routeTabCorner.CornerRadius = UDim.new(0, 6)
routeTabCorner.Parent = routeTab

local uiTab = Instance.new("TextButton")
uiTab.Size = UDim2.new(0.5, -1, 1, 0)
uiTab.Position = UDim2.new(0.5, 1, 0, 0)
uiTab.Text = "🎨 Интерфейс"
uiTab.TextColor3 = Color3.new(1, 1, 1)
uiTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
uiTab.BorderSizePixel = 0
uiTab.Parent = tabBar

local uiTabCorner = Instance.new("UICorner")
uiTabCorner.CornerRadius = UDim.new(0, 6)
uiTabCorner.Parent = uiTab

-- Панель "Маршрут"
local routePanel = Instance.new("Frame")
routePanel.Size = UDim2.new(1, 0, 1, -35)
routePanel.Position = UDim2.new(0, 0, 0, 35)
routePanel.BackgroundTransparency = 1
routePanel.Parent = content

-- Панель "Интерфейс"
local uiPanel = Instance.new("Frame")
uiPanel.Size = UDim2.new(1, 0, 1, -35)
uiPanel.Position = UDim2.new(0, 0, 0, 35)
uiPanel.BackgroundTransparency = 1
uiPanel.Visible = false
uiPanel.Parent = content

-- ===== МАРШРУТ =====
local input = Instance.new("TextBox")
input.Size = UDim2.new(0.8, 0, 0, 32)
input.Position = UDim2.new(0.1, 0, 0.05, 0)
input.Text = "X, Y, Z"
input.TextColor3 = Color3.new(1, 1, 1)
input.TextSize = 14
input.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
input.BorderSizePixel = 0
input.Parent = routePanel

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = input

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0.35, 0, 0, 32)
addBtn.Position = UDim2.new(0.1, 0, 0.18, 0)
addBtn.Text = "➕ Добавить"
addBtn.TextColor3 = Color3.new(1, 1, 1)
addBtn.TextSize = 14
addBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
addBtn.BorderSizePixel = 0
addBtn.Parent = routePanel

local addCorner = Instance.new("UICorner")
addCorner.CornerRadius = UDim.new(0, 6)
addCorner.Parent = addBtn

local hereBtn = Instance.new("TextButton")
hereBtn.Size = UDim2.new(0.35, 0, 0, 32)
hereBtn.Position = UDim2.new(0.55, 0, 0.18, 0)
hereBtn.Text = "📍 Сюда"
hereBtn.TextColor3 = Color3.new(1, 1, 1)
hereBtn.TextSize = 14
hereBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
hereBtn.BorderSizePixel = 0
hereBtn.Parent = routePanel

local hereCorner = Instance.new("UICorner")
hereCorner.CornerRadius = UDim.new(0, 6)
hereCorner.Parent = hereBtn

local posBtn = Instance.new("TextButton")
posBtn.Size = UDim2.new(0.35, 0, 0, 32)
posBtn.Position = UDim2.new(0.1, 0, 0.32, 0)
posBtn.Text = "📌 Координаты"
posBtn.TextColor3 = Color3.new(1, 1, 1)
posBtn.TextSize = 14
posBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
posBtn.BorderSizePixel = 0
posBtn.Parent = routePanel

local posCorner = Instance.new("UICorner")
posCorner.CornerRadius = UDim.new(0, 6)
posCorner.Parent = posBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.35, 0, 0, 32)
clearBtn.Position = UDim2.new(0.55, 0, 0.32, 0)
clearBtn.Text = "🗑 Очистить"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = 14
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.BorderSizePixel = 0
clearBtn.Parent = routePanel

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.8, 0, 0, 32)
speedInput.Position = UDim2.new(0.1, 0, 0.46, 0)
speedInput.Text = "Скорость: 16"
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.TextSize = 14
speedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
speedInput.BorderSizePixel = 0
speedInput.Parent = routePanel

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedInput

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.35, 0, 0, 35)
startBtn.Position = UDim2.new(0.1, 0, 0.62, 0)
startBtn.Text = "▶ Старт"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.TextSize = 15
startBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
startBtn.BorderSizePixel = 0
startBtn.Parent = routePanel

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 8)
startCorner.Parent = startBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.35, 0, 0, 35)
stopBtn.Position = UDim2.new(0.55, 0, 0.62, 0)
stopBtn.Text = "⏹ Стоп"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.TextSize = 15
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.BorderSizePixel = 0
stopBtn.Parent = routePanel

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 8)
stopCorner.Parent = stopBtn

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 25)
status.Position = UDim2.new(0.05, 0, 0.82, 0)
status.Text = "Готов"
status.TextColor3 = Color3.new(0.7, 0.7, 0.7)
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Center
status.BackgroundTransparency = 1
status.Parent = routePanel

-- ===== ИНТЕРФЕЙС =====
local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(0.8, 0, 0, 25)
colorLabel.Position = UDim2.new(0.1, 0, 0.05, 0)
colorLabel.Text = "Цвет акцентов:"
colorLabel.TextColor3 = Color3.new(1, 1, 1)
colorLabel.TextSize = 14
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.BackgroundTransparency = 1
colorLabel.Parent = uiPanel

-- Кнопки цветов
local colors = {
    {name = "Синий", color = Color3.fromRGB(30, 144, 255)},
    {name = "Красный", color = Color3.fromRGB(220, 50, 50)},
    {name = "Зелёный", color = Color3.fromRGB(50, 200, 50)},
    {name = "Фиолетовый", color = Color3.fromRGB(150, 50, 200)},
    {name = "Оранжевый", color = Color3.fromRGB(255, 150, 0)},
    {name = "Розовый", color = Color3.fromRGB(255, 80, 150)}
}

local colorBtns = {}
for i, c in ipairs(colors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0, 30)
    btn.Position = UDim2.new(0.05 + ((i-1) % 3) * 0.32, 0, 0.15 + math.floor((i-1)/3) * 0.13, 0)
    btn.Text = c.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    btn.BackgroundColor3 = c.color
    btn.BorderSizePixel = 0
    btn.Parent = uiPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    colorBtns[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        selectedColor = c.color
        -- Обновляем все кнопки с акцентным цветом
        routeTab.BackgroundColor3 = selectedColor
        startBtn.BackgroundColor3 = selectedColor
        for _, b in ipairs(colorBtns) do
            b.BackgroundColor3 = colors[tonumber(b.Name)] and colors[tonumber(b.Name)].color or b.BackgroundColor3
        end
        btn.BackgroundColor3 = selectedColor
        btn.Text = "✓ " .. c.name
        status.Text = "Цвет изменён на " .. c.name
    end)
    
    -- Сохраняем индекс для восстановления
    btn.Name = tostring(i)
end

-- ===== ФУНКЦИИ КНОПОК =====
addBtn.MouseButton1Click:Connect(function()
    local coords = {}
    for num in string.gmatch(input.Text, "[-%d.]+") do
        table.insert(coords, tonumber(num))
    end
    if #coords >= 3 then
        if #route < 1000 then
            table.insert(route, Vector3.new(coords[1], coords[2], coords[3]))
            status.Text = "Точка " .. #route .. " добавлена"
        else
            status.Text = "Максимум 1000 точек!"
        end
    else
        status.Text = "Введи X, Y, Z через запятую"
    end
end)

hereBtn.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if #route < 1000 then
            local pos = char.HumanoidRootPart.Position
            table.insert(route, pos)
            status.Text = "Точка " .. #route .. " добавлена (текущая позиция)"
        else
            status.Text = "Максимум 1000 точек!"
        end
    else
        status.Text = "Персонаж не найден"
    end
end)

posBtn.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        status.Text = string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z)
        input.Text = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        print("Твои координаты:", pos)
    else
        status.Text = "Персонаж не найден"
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    route = {}
    status.Text = "Маршрут очищен"
end)

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text:match("%d+"))
    if val then
        speed = val
        speedInput.Text = "Скорость: " .. speed
        status.Text = "Скорость: " .. speed
    end
end)

-- Движение по маршруту
local function moveToNext()
    if not running or #route == 0 then return end
    if currentIndex > #route then
        currentIndex = 1
        status.Text = "Маршрут завершён, повтор"
        wait(0.5)
    end
    
    local target = route[currentIndex]
    if target and char and char:FindFirstChild("HumanoidRootPart") then
        humanoid.WalkSpeed = speed
        humanoid:MoveTo(target)
        
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
        status.Text = "Нет точек!"
        return 
    end
    running = true
    currentIndex = 1
    status.Text = "Идём по маршруту... (" .. #route .. " точек)"
    moveToNext()
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    humanoid.WalkSpeed = 16
    status.Text = "Остановлен"
end)

-- ===== УПРАВЛЕНИЕ ИНТЕРФЕЙСОМ =====
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    minBtn.Text = minimized and "➕" or "➖"
    if minimized then
        frame.Size = UDim2.new(0, 350, 0, 40)
    else
        frame.Size = UDim2.new(0, 350, 0, 320)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Переключение вкладок
routeTab.MouseButton1Click:Connect(function()
    routePanel.Visible = true
    uiPanel.Visible = false
    routeTab.BackgroundColor3 = selectedColor
    uiTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
end)

uiTab.MouseButton1Click:Connect(function()
    routePanel.Visible = false
    uiPanel.Visible = true
    uiTab.BackgroundColor3 = selectedColor
    routeTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
end)

-- Начальная настройка
routeTab.BackgroundColor3 = selectedColor
print("✅ Меню загружено! До 1000 точек, вкладки, настройка цвета.")
