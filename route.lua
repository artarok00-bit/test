-- [[ ARTARIO HUB — Murder Duels ]]
-- Разработчик: artar

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ===== ДАННЫЕ =====
local EspActive = false
local EspColor = Color3.fromRGB(255, 0, 0)
local EspHighlights = {}

local HitboxActive = false
local HitboxScale = 3
local OriginalSizes = {}

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArtarioHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ===== ГЛАВНОЕ ОКНО =====
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 700, 0, 420)
Main.Position = UDim2.new(0.5, -350, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(22, 18, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Фон (затемнённая картинка)
local Bg = Instance.new("ImageLabel", Main)
Bg.Size = UDim2.new(1, 0, 1, 0)
Bg.BackgroundTransparency = 1
Bg.Image = "rbxassetid://133445291771070"
Bg.ScaleType = Enum.ScaleType.Crop
Bg.ZIndex = 0
Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 12)

local BgDark = Instance.new("Frame", Main)
BgDark.Size = UDim2.new(1, 0, 1, 0)
BgDark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BgDark.BackgroundTransparency = 0.55
BgDark.BorderSizePixel = 0
BgDark.ZIndex = 1
Instance.new("UICorner", BgDark).CornerRadius = UDim.new(0, 12)

-- ===== ШАПКА =====
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 50)
Top.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
Top.BackgroundTransparency = 0.5
Top.BorderSizePixel = 0
Top.ZIndex = 5
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 12)

local Logo = Instance.new("ImageLabel", Top)
Logo.Size = UDim2.new(0, 32, 0, 32)
Logo.Position = UDim2.new(0.02, 0, 0.18, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://133445291771070"
Logo.ZIndex = 6

local NameHub = Instance.new("TextLabel", Top)
NameHub.Size = UDim2.new(0.4, 0, 0, 20)
NameHub.Position = UDim2.new(0.07, 0, 0.1, 0)
NameHub.Text = "ARTARIO HUB 🔥"
NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
NameHub.TextSize = 15
NameHub.TextXAlignment = Enum.TextXAlignment.Left
NameHub.BackgroundTransparency = 1
NameHub.Font = Enum.Font.GothamBold
NameHub.ZIndex = 6

local Author = Instance.new("TextLabel", Top)
Author.Size = UDim2.new(0.4, 0, 0, 16)
Author.Position = UDim2.new(0.07, 0, 0.55, 0)
Author.Text = "by artar"
Author.TextColor3 = Color3.fromRGB(150, 150, 150)
Author.TextSize = 11
Author.TextXAlignment = Enum.TextXAlignment.Left
Author.BackgroundTransparency = 1
Author.Font = Enum.Font.Gotham
Author.ZIndex = 6

local Ver = Instance.new("TextButton", Top)
Ver.Size = UDim2.new(0, 150, 0, 30)
Ver.Position = UDim2.new(0.38, 0, 0.2, 0)
Ver.Text = "Версия 1.0"
Ver.TextColor3 = Color3.fromRGB(0, 0, 0)
Ver.TextSize = 13
Ver.BackgroundColor3 = Color3.fromRGB(80, 255, 100)
Ver.BorderSizePixel = 0
Ver.Font = Enum.Font.GothamBold
Ver.ZIndex = 6
Instance.new("UICorner", Ver).CornerRadius = UDim.new(0, 15)

-- Кнопки свернуть/закрыть
local MinBtn = Instance.new("TextButton", Top)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0.2, 0)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 18
MinBtn.BackgroundTransparency = 1
MinBtn.Font = Enum.Font.GothamBold
MinBtn.ZIndex = 6

local CloseBtn = Instance.new("TextButton", Top)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.2, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 18
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 6

-- ===== ЛЕВОЕ МЕНЮ =====
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 170, 1, -60)
Side.Position = UDim2.new(0, 8, 0, 52)
Side.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
Side.BackgroundTransparency = 0.5
Side.BorderSizePixel = 0
Side.ZIndex = 5
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 10)

-- Поиск
local Search = Instance.new("TextBox", Side)
Search.Size = UDim2.new(0.9, 0, 0, 32)
Search.Position = UDim2.new(0.05, 0, 0.02, 0)
Search.Text = ""
Search.PlaceholderText = "🔍 Search"
Search.TextColor3 = Color3.fromRGB(200, 200, 200)
Search.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
Search.TextSize = 12
Search.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
Search.BackgroundTransparency = 0.3
Search.BorderSizePixel = 0
Search.Font = Enum.Font.Gotham
Search.TextXAlignment = Enum.TextXAlignment.Left
Search.ZIndex = 6
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 8)
local SearchPad = Instance.new("UIPadding", Search)
SearchPad.PaddingLeft = UDim.new(0, 8)

-- Вкладки
local function MakeTab(text, y)
    local btn = Instance.new("TextButton", Side)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 6
    return btn
end

local TPerson = MakeTab("👤  Персонаж", 45)
local TTeleport = MakeTab("🌀  Телепорт", 78)
local TCombat = MakeTab("⚔️  Комбат", 111)
local TTrolling = MakeTab("😈  Троллинг", 144)
local TWall = MakeTab("🧱  Валлхак", 177)
local TVisual = MakeTab("👁  Визуал", 210)
local TButtons = MakeTab("🎮  Кнопки", 243)

-- ===== ПРАВАЯ ПАНЕЛЬ =====
local Right = Instance.new("Frame", Main)
Right.Size = UDim2.new(1, -190, 1, -60)
Right.Position = UDim2.new(0, 185, 0, 52)
Right.BackgroundTransparency = 1
Right.ZIndex = 5

-- Заголовок
local PanelTitle = Instance.new("TextLabel", Right)
PanelTitle.Size = UDim2.new(1, 0, 0, 30)
PanelTitle.Position = UDim2.new(0, 0, 0, 0)
PanelTitle.Text = "Валлхак"
PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PanelTitle.TextSize = 16
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.BackgroundTransparency = 1
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.ZIndex = 6

-- ===== КАРТОЧКА 1: ESP =====
local Card1 = Instance.new("Frame", Right)
Card1.Size = UDim2.new(1, 0, 0, 85)
Card1.Position = UDim2.new(0, 0, 0, 40)
Card1.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
Card1.BackgroundTransparency = 0.1
Card1.BorderSizePixel = 0
Card1.ZIndex = 6
Instance.new("UICorner", Card1).CornerRadius = UDim.new(0, 12)

local C1Title = Instance.new("TextLabel", Card1)
C1Title.Size = UDim2.new(0.7, 0, 0, 22)
C1Title.Position = UDim2.new(0.04, 0, 0.15, 0)
C1Title.Text = "Показать ESP"
C1Title.TextColor3 = Color3.fromRGB(255, 255, 255)
C1Title.TextSize = 14
C1Title.TextXAlignment = Enum.TextXAlignment.Left
C1Title.BackgroundTransparency = 1
C1Title.Font = Enum.Font.GothamSemibold
C1Title.ZIndex = 7

local C1Desc = Instance.new("TextLabel", Card1)
C1Desc.Size = UDim2.new(0.7, 0, 0, 18)
C1Desc.Position = UDim2.new(0.04, 0, 0.5, 0)
C1Desc.Text = "Обводка врагов через стены"
C1Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
C1Desc.TextSize = 11
C1Desc.TextXAlignment = Enum.TextXAlignment.Left
C1Desc.BackgroundTransparency = 1
C1Desc.Font = Enum.Font.Gotham
C1Desc.ZIndex = 7

local C1ToggleBg = Instance.new("Frame", Card1)
C1ToggleBg.Size = UDim2.new(0, 50, 0, 26)
C1ToggleBg.Position = UDim2.new(1, -65, 0.5, -13)
C1ToggleBg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
C1ToggleBg.BorderSizePixel = 0
C1ToggleBg.ZIndex = 7
Instance.new("UICorner", C1ToggleBg).CornerRadius = UDim.new(1, 0)

local C1ToggleKnob = Instance.new("Frame", C1ToggleBg)
C1ToggleKnob.Size = UDim2.new(0, 20, 0, 20)
C1ToggleKnob.Position = UDim2.new(0, 3, 0.5, -10)
C1ToggleKnob.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
C1ToggleKnob.BorderSizePixel = 0
C1ToggleKnob.ZIndex = 8
Instance.new("UICorner", C1ToggleKnob).CornerRadius = UDim.new(1, 0)

local C1Btn = Instance.new("TextButton", Card1)
C1Btn.Size = UDim2.new(1, 0, 1, 0)
C1Btn.BackgroundTransparency = 1
C1Btn.Text = ""
C1Btn.ZIndex = 9

-- ===== КАРТОЧКА 2: ХИТБОКСЫ =====
local Card2 = Instance.new("Frame", Right)
Card2.Size = UDim2.new(1, 0, 0, 85)
Card2.Position = UDim2.new(0, 0, 0, 140)
Card2.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
Card2.BackgroundTransparency = 0.1
Card2.BorderSizePixel = 0
Card2.ZIndex = 6
Instance.new("UICorner", Card2).CornerRadius = UDim.new(0, 12)

local C2Title = Instance.new("TextLabel", Card2)
C2Title.Size = UDim2.new(0.7, 0, 0, 22)
C2Title.Position = UDim2.new(0.04, 0, 0.15, 0)
C2Title.Text = "Увеличить хитбоксы"
C2Title.TextColor3 = Color3.fromRGB(255, 255, 255)
C2Title.TextSize = 14
C2Title.TextXAlignment = Enum.TextXAlignment.Left
C2Title.BackgroundTransparency = 1
C2Title.Font = Enum.Font.GothamSemibold
C2Title.ZIndex = 7

local C2Desc = Instance.new("TextLabel", Card2)
C2Desc.Size = UDim2.new(0.7, 0, 0, 18)
C2Desc.Position = UDim2.new(0.04, 0, 0.5, 0)
C2Desc.Text = "Легче попасть по врагам"
C2Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
C2Desc.TextSize = 11
C2Desc.TextXAlignment = Enum.TextXAlignment.Left
C2Desc.BackgroundTransparency = 1
C2Desc.Font = Enum.Font.Gotham
C2Desc.ZIndex = 7

local C2ToggleBg = Instance.new("Frame", Card2)
C2ToggleBg.Size = UDim2.new(0, 50, 0, 26)
C2ToggleBg.Position = UDim2.new(1, -65, 0.5, -13)
C2ToggleBg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
C2ToggleBg.BorderSizePixel = 0
C2ToggleBg.ZIndex = 7
Instance.new("UICorner", C2ToggleBg).CornerRadius = UDim.new(1, 0)

local C2ToggleKnob = Instance.new("Frame", C2ToggleBg)
C2ToggleKnob.Size = UDim2.new(0, 20, 0, 20)
C2ToggleKnob.Position = UDim2.new(0, 3, 0.5, -10)
C2ToggleKnob.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
C2ToggleKnob.BorderSizePixel = 0
C2ToggleKnob.ZIndex = 8
Instance.new("UICorner", C2ToggleKnob).CornerRadius = UDim.new(1, 0)

local C2Btn = Instance.new("TextButton", Card2)
C2Btn.Size = UDim2.new(1, 0, 1, 0)
C2Btn.BackgroundTransparency = 1
C2Btn.Text = ""
C2Btn.ZIndex = 9

-- ===== КАРТОЧКА 3: РАЗМЕР ХИТБОКСА =====
local Card3 = Instance.new("Frame", Right)
Card3.Size = UDim2.new(1, 0, 0, 60)
Card3.Position = UDim2.new(0, 0, 0, 240)
Card3.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
Card3.BackgroundTransparency = 0.1
Card3.BorderSizePixel = 0
Card3.ZIndex = 6
Instance.new("UICorner", Card3).CornerRadius = UDim.new(0, 12)

local C3Title = Instance.new("TextLabel", Card3)
C3Title.Size = UDim2.new(0.6, 0, 1, 0)
C3Title.Position = UDim2.new(0.04, 0, 0, 0)
C3Title.Text = "Размер хитбокса"
C3Title.TextColor3 = Color3.fromRGB(255, 255, 255)
C3Title.TextSize = 14
C3Title.TextXAlignment = Enum.TextXAlignment.Left
C3Title.BackgroundTransparency = 1
C3Title.Font = Enum.Font.GothamSemibold
C3Title.ZIndex = 7

local C3Input = Instance.new("TextBox", Card3)
C3Input.Size = UDim2.new(0, 80, 0, 32)
C3Input.Position = UDim2.new(1, -95, 0.5, -16)
C3Input.Text = "3"
C3Input.TextColor3 = Color3.fromRGB(255, 255, 255)
C3Input.TextSize = 14
C3Input.BackgroundColor3 = Color3.fromRGB(50, 45, 45)
C3Input.BorderSizePixel = 0
C3Input.Font = Enum.Font.GothamBold
C3Input.TextXAlignment = Enum.TextXAlignment.Center
C3Input.ZIndex = 7
Instance.new("UICorner", C3Input).CornerRadius = UDim.new(0, 6)

-- ===== ФУНКЦИИ =====
local function UpdateToggle(toggleBg, toggleKnob, enabled)
    if enabled then
        toggleBg.BackgroundColor3 = Color3.fromRGB(255, 160, 50)
        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 27, 0.5, -10)}):Play()
    else
        toggleBg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
        TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
    end
end

-- ESP
local function ApplyEsp(op)
    if op == Player then return end
    local char = op.Character
    if not char or char == Player.Character then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end
    if not char:FindFirstChild("ArtarioESP") then
        local h = Instance.new("Highlight")
        h.Name = "ArtarioESP"
        h.FillColor = EspColor
        h.FillTransparency = 0.7
        h.OutlineColor = EspColor
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = char
        EspHighlights[op] = h
    end
end

local function EnableEsp()
    EspActive = true
    EspHighlights = {}
    for _, p in ipairs(game.Players:GetPlayers()) do ApplyEsp(p) end
    UpdateToggle(C1ToggleBg, C1ToggleKnob, true)
end

local function DisableEsp()
    EspActive = false
    for _, h in pairs(EspHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    EspHighlights = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("ArtarioESP")
            if h then h:Destroy() end
        end
    end
    UpdateToggle(C1ToggleBg, C1ToggleKnob, false)
end

-- ХИТБОКСЫ
local function GetParts(char)
    local parts = {}
    for _, p in ipairs(char:GetChildren()) do
        if p:IsA("BasePart") then table.insert(parts, p) end
    end
    return parts
end

local function ApplyHitbox(op)
    if op == Player then return end
    local char = op.Character
    if not char or char == Player.Character then return end
    for _, part in ipairs(GetParts(char)) do
        if not OriginalSizes[part] then
            OriginalSizes[part] = {Size = part.Size}
            part.Size = part.Size * HitboxScale
        end
    end
end

local function EnableHitbox()
    HitboxActive = true
    OriginalSizes = {}
    for _, p in ipairs(game.Players:GetPlayers()) do ApplyHitbox(p) end
    UpdateToggle(C2ToggleBg, C2ToggleKnob, true)
end

local function DisableHitbox()
    HitboxActive = false
    for part, data in pairs(OriginalSizes) do
        if part and part.Parent then part.Size = data.Size end
    end
    OriginalSizes = {}
    UpdateToggle(C2ToggleBg, C2ToggleKnob, false)
end

-- ===== АВТООБНОВЛЕНИЕ =====
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.5)
        if EspActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyEsp(p) end
        end
        if HitboxActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyHitbox(p) end
        end
    end
end)

-- ===== КНОПКИ =====
C1Btn.MouseButton1Click:Connect(function()
    if EspActive then DisableEsp() else EnableEsp() end
end)

C2Btn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() else EnableHitbox() end
end)

C3Input.FocusLost:Connect(function()
    local val = tonumber(C3Input.Text)
    if val and val >= 1 and val <= 100 then
        HitboxScale = val
        if HitboxActive then DisableHitbox() EnableHitbox() end
    else
        C3Input.Text = tostring(HitboxScale)
    end
end)

-- ===== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК =====
local function ResetTabs()
    for _, t in pairs({TPerson, TTeleport, TCombat, TTrolling, TWall, TVisual, TButtons}) do
        t.TextColor3 = Color3.fromRGB(200, 200, 200)
        t.BackgroundTransparency = 1
    end
end

TWall.MouseButton1Click:Connect(function()
    ResetTabs()
    TWall.TextColor3 = Color3.fromRGB(255, 255, 255)
    TWall.BackgroundColor3 = Color3.fromRGB(45, 38, 38)
    TWall.BackgroundTransparency = 0.3
    PanelTitle.Text = "Валлхак"
end)

-- ===== ЗАКРЫТИЕ =====
CloseBtn.MouseButton1Click:Connect(function()
    if EspActive then DisableEsp() end
    if HitboxActive then DisableHitbox() end
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    if Main.Size.Y.Offset == 420 then
        Main.Size = UDim2.new(0, 700, 0, 50)
    else
        Main.Size = UDim2.new(0, 700, 0, 420)
    end
end)

print("✅ ARTARIO HUB загружен! by artar")
