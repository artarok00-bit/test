local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local route = {}
local speed = 16
local running = false
local currentIndex = 1

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 230)
frame.Position = UDim2.new(0.5, -150, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Маршрут-меню"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(0.8, 0, 0, 30)
input.Position = UDim2.new(0.1, 0, 0.2, 0)
input.Text = "0, 0, 0"
input.TextColor3 = Color3.new(1,1,1)
input.BackgroundColor3 = Color3.fromRGB(60,60,60)
input.Parent = frame

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0.8, 0, 0, 30)
addBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
addBtn.Text = "Добавить точку"
addBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
addBtn.TextColor3 = Color3.new(1,1,1)
addBtn.Parent = frame

addBtn.MouseButton1Click:Connect(function()
    local coords = {}
    for num in string.gmatch(input.Text, "[-%d.]+") do
        table.insert(coords, tonumber(num))
    end
    if #coords >= 3 then
        table.insert(route, Vector3.new(coords[1], coords[2], coords[3]))
        status.Text = "Точка " .. #route .. " добавлена"
    end
end)

local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0.8, 0, 0, 30)
speedSlider.Position = UDim2.new(0.1, 0, 0.5, 0)
speedSlider.Text = "Скорость: 16"
speedSlider.TextColor3 = Color3.new(1,1,1)
speedSlider.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedSlider.Parent = frame

speedSlider.FocusLost:Connect(function()
    local val = tonumber(speedSlider.Text:match("%d+"))
    if val then
        speed = val
        speedSlider.Text = "Скорость: " .. speed
    end
end)

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.38, 0, 0, 30)
startBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
startBtn.Text = "Старт"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.38, 0, 0, 30)
stopBtn.Position = UDim2.new(0.55, 0, 0.7, 0)
stopBtn.Text = "Стоп"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.88, 0)
status.Text = "Готов"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundColor3 = Color3.fromRGB(40,40,40)
status.Parent = frame

local function moveToNext()
    if not running or #route == 0 then return end
    if currentIndex > #route then
        currentIndex = 1
        status.Text = "Маршрут завершён, повтор"
        wait(1)
    end
    
    local target = route[currentIndex]
    if target and char and char.PrimaryPart then
        humanoid.WalkSpeed = speed
        humanoid:MoveTo(target)
        
        repeat
            task.wait()
            if not running then break end
        until (char.PrimaryPart.Position - target).Magnitude < 5 or not running
        
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
    status.Text = "Идём по маршруту..."
    moveToNext()
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    humanoid.WalkSpeed = 16
    status.Text = "Остановлен"
end)
