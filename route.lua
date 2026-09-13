-- [[ ARTARIO HUB — Murder Duels ]]
-- Разработчик: artar

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local HitboxScale = 3
local HitboxActive = false
local OriginalSizes = {}
local EspActive = false
local EspColor = Color3.fromRGB(255, 0, 0)
local EspHighlights = {}
local HitboxHotkey = Enum.KeyCode.H
local SettingKeybind = false
local MenuClosed = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArtarioHub"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Bg = Instance.new("ImageLabel", MainFrame)
Bg.Size = UDim2.new(1, 0, 1, 0)
Bg.BackgroundTransparency = 1
Bg.Image = "rbxassetid://133445291771070"
Bg.ScaleType = Enum.ScaleType.Crop
Bg.ZIndex = 0

local Dark = Instance.new("Frame", MainFrame)
Dark.Size = UDim2.new(1, 0, 1, 0)
Dark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Dark.BackgroundTransparency = 0.4
Dark.BorderSizePixel = 0
Dark.ZIndex = 1
Instance.new("UICorner", Dark).CornerRadius = UDim.new(0, 14)

local Top = Instance.new("Frame", MainFrame)
Top.Size = UDim2.new(1, 0, 0, 45)
Top.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
Top.BackgroundTransparency = 0.3
Top.BorderSizePixel = 0
Top.ZIndex = 5
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14)

local Logo = Instance.new("ImageLabel", Top)
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(0.02, 0, 0.1, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://133445291771070"
Logo.ZIndex = 6
Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(0.4, 0, 0, 20)
Title.Position = UDim2.new(0.09, 0, 0.1, 0)
Title.Text = "ARTARIO HUB 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 6

local Author = Instance.new("TextLabel", Top)
Author.Size = UDim2.new(0.4, 0, 0, 16)
Author.Position = UDim2.new(0.09, 0, 0.55, 0)
Author.Text = "by artar"
Author.TextColor3 = Color3.fromRGB(180, 180, 180)
Author.TextSize = 11
Author.TextXAlignment = Enum.TextXAlignment.Left
Author.BackgroundTransparency = 1
Author.Font = Enum.Font.Gotham
Author.ZIndex = 6

local Ver = Instance.new("TextButton", Top)
Ver.Size = UDim2.new(0, 130, 0, 28)
Ver.Position = UDim2.new(0.42, 0, 0.2, 0)
Ver.Text = "Версия 1.1"
Ver.TextColor3 = Color3.fromRGB(0, 0, 0)
Ver.TextSize = 12
Ver.BackgroundColor3 = Color3.fromRGB(80, 255, 100)
Ver.BorderSizePixel = 0
Ver.Font = Enum.Font.GothamBold
Ver.ZIndex = 6
Instance.new("UICorner", Ver).CornerRadius = UDim.new(0, 14)

local MinBtn = Instance.new("TextButton", Top)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0.15, 0)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 18
MinBtn.BackgroundTransparency = 1
MinBtn.Font = Enum.Font.GothamBold
MinBtn.ZIndex = 6

local CloseBtn = Instance.new("TextButton", Top)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.15, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 6

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 5, 0, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 12, 12)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 5
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local AimTab = Instance.new("TextButton", Sidebar)
AimTab.Size = UDim2.new(0.9, 0, 0, 32)
AimTab.Position = UDim2.new(0.05, 0, 0, 15)
AimTab.Text = "  🎯  Аим"
AimTab.TextColor3 = Color3.fromRGB(255, 255, 255)
AimTab.TextSize = 12
AimTab.BackgroundColor3 = Color3.fromRGB(50, 40, 40)
AimTab.BackgroundTransparency = 0.3
AimTab.BorderSizePixel = 0
AimTab.Font = Enum.Font.GothamSemibold
AimTab.TextXAlignment = Enum.TextXAlignment.Left
AimTab.ZIndex = 6
Instance.new("UICorner", AimTab).CornerRadius = UDim.new(0, 6)

local EspTab = Instance.new("TextButton", Sidebar)
EspTab.Size = UDim2.new(0.9, 0, 0, 32)
EspTab.Position = UDim2.new(0.05, 0, 0, 53)
EspTab.Text = "  👁  ЕСП"
EspTab.TextColor3 = Color3.fromRGB(200, 200, 200)
EspTab.TextSize = 12
EspTab.BackgroundTransparency = 1
EspTab.BorderSizePixel = 0
EspTab.Font = Enum.Font.GothamSemibold
EspTab.TextXAlignment = Enum.TextXAlignment.Left
EspTab.ZIndex = 6

local Right = Instance.new("Frame", MainFrame)
Right.Size = UDim2.new(1, -165, 1, -50)
Right.Position = UDim2.new(0, 160, 0, 48)
Right.BackgroundTransparency = 1
Right.ZIndex = 5

local PanelTitle = Instance.new("TextLabel", Right)
PanelTitle.Size = UDim2.new(0.9, 0, 0, 25)
PanelTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
PanelTitle.Text = "Аим"
PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PanelTitle.TextSize = 15
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.BackgroundTransparency = 1
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.ZIndex = 6

local AimPanel = Instance.new("Frame", Right)
AimPanel.Size = UDim2.new(1, 0, 1, 0)
AimPanel.BackgroundTransparency = 1
AimPanel.ZIndex = 5

-- Карточка хитбоксов
local HitboxCard = Instance.new("Frame", AimPanel)
HitboxCard.Size = UDim2.new(0.95, 0, 0, 80)
HitboxCard.Position = UDim2.new(0.025, 0, 0.1, 0)
HitboxCard.BackgroundColor3 = Color3.fromRGB(35, 28, 28)
HitboxCard.BackgroundTransparency = 0.15
HitboxCard.BorderSizePixel = 0
HitboxCard.ZIndex = 6
Instance.new("UICorner", HitboxCard).CornerRadius = UDim.new(0, 12)

local HcT = Instance.new("TextLabel", HitboxCard)
HcT.Size = UDim2.new(0.7, 0, 0, 20)
HcT.Position = UDim2.new(0.05, 0, 0.1, 0)
HcT.Text = "Включить хитбоксы"
HcT.TextColor3 = Color3.fromRGB(255, 255, 255)
HcT.TextSize = 13
HcT.TextXAlignment = Enum.TextXAlignment.Left
HcT.BackgroundTransparency = 1
HcT.Font = Enum.Font.GothamSemibold
HcT.ZIndex = 7

local HcD = Instance.new("TextLabel", HitboxCard)
HcD.Size = UDim2.new(0.7, 0, 0, 18)
HcD.Position = UDim2.new(0.05, 0, 0.38, 0)
HcD.Text = "Легче попасть по врагам"
HcD.TextColor3 = Color3.fromRGB(180, 180, 180)
HcD.TextSize = 11
HcD.TextXAlignment = Enum.TextXAlignment.Left
HcD.BackgroundTransparency = 1
HcD.Font = Enum.Font.Gotham
HcD.ZIndex = 7

local HTbg = Instance.new("Frame", HitboxCard)
HTbg.Size = UDim2.new(0, 45, 0, 24)
HTbg.Position = UDim2.new(1, -55, 0.5, -12)
HTbg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
HTbg.BorderSizePixel = 0
HTbg.ZIndex = 7
Instance.new("UICorner", HTbg).CornerRadius = UDim.new(1, 0)

local HTknob = Instance.new("Frame", HTbg)
HTknob.Size = UDim2.new(0, 18, 0, 18)
HTknob.Position = UDim2.new(0, 3, 0.5, -9)
HTknob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
HTknob.BorderSizePixel = 0
HTknob.ZIndex = 8
Instance.new("UICorner", HTknob).CornerRadius = UDim.new(1, 0)

local HTbtn = Instance.new("TextButton", HitboxCard)
HTbtn.Size = UDim2.new(1, 0, 1, 0)
HTbtn.BackgroundTransparency = 1
HTbtn.Text = ""
HTbtn.ZIndex = 9

-- Карточка размера
local SizeCard = Instance.new("Frame", AimPanel)
SizeCard.Size = UDim2.new(0.95, 0, 0, 90)
SizeCard.Position = UDim2.new(0.025, 0, 0.35, 0)
SizeCard.BackgroundColor3 = Color3.fromRGB(35, 28, 28)
SizeCard.BackgroundTransparency = 0.15
SizeCard.BorderSizePixel = 0
SizeCard.ZIndex = 6
Instance.new("UICorner", SizeCard).CornerRadius = UDim.new(0, 12)

local ST = Instance.new("TextLabel", SizeCard)
ST.Size = UDim2.new(0.5, 0, 0, 20)
ST.Position = UDim2.new(0.05, 0, 0.1, 0)
ST.Text = "Размер хитбокса"
ST.TextColor3 = Color3.fromRGB(255, 255, 255)
ST.TextSize = 13
ST.TextXAlignment = Enum.TextXAlignment.Left
ST.BackgroundTransparency = 1
ST.Font = Enum.Font.GothamSemibold
ST.ZIndex = 7

local SV = Instance.new("TextLabel", SizeCard)
SV.Size = UDim2.new(0.2, 0, 0, 20)
SV.Position = UDim2.new(0.75, 0, 0.1, 0)
SV.Text = "3"
SV.TextColor3 = Color3.fromRGB(255, 255, 255)
SV.TextSize = 13
SV.TextXAlignment = Enum.TextXAlignment.Right
SV.BackgroundTransparency = 1
SV.Font = Enum.Font.GothamBold
SV.ZIndex = 7

local QuickFrame = Instance.new("Frame", SizeCard)
QuickFrame.Size = UDim2.new(0.9, 0, 0, 32)
QuickFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
QuickFrame.BackgroundTransparency = 1
QuickFrame.ZIndex = 7

local quickValues = {3, 10, 30, 50, 100}
for i, val in ipairs(quickValues) do
    local q = Instance.new("TextButton", QuickFrame)
    q.Size = UDim2.new(0.18, 0, 1, 0)
    q.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
    q.Text = tostring(val)
    q.TextColor3 = Color3.fromRGB(255, 255, 255)
    q.TextSize = 11
    q.BackgroundColor3 = Color3.fromRGB(50, 42, 42)
    q.BackgroundTransparency = 0.2
    q.BorderSizePixel = 0
    q.Font = Enum.Font.GothamBold
    q.ZIndex = 8
    Instance.new("UICorner", q).CornerRadius = UDim.new(0, 6)
    q.MouseButton1Click:Connect(function()
        HitboxScale = val
        SV.Text = tostring(val)
        if HitboxActive then DisableHitbox() EnableHitbox() end
    end)
end

-- Карточка хоткея
local KeyCard = Instance.new("Frame", AimPanel)
KeyCard.Size = UDim2.new(0.95, 0, 0, 60)
KeyCard.Position = UDim2.new(0.025, 0, 0.6, 0)
KeyCard.BackgroundColor3 = Color3.fromRGB(35, 28, 28)
KeyCard.BackgroundTransparency = 0.15
KeyCard.BorderSizePixel = 0
KeyCard.ZIndex = 6
Instance.new("UICorner", KeyCard).CornerRadius = UDim.new(0, 12)

local KT = Instance.new("TextLabel", KeyCard)
KT.Size = UDim2.new(0.6, 0, 0, 20)
KT.Position = UDim2.new(0.05, 0, 0.2, 0)
KT.Text = "Горячая клавиша"
KT.TextColor3 = Color3.fromRGB(255, 255, 255)
KT.TextSize = 13
KT.TextXAlignment = Enum.TextXAlignment.Left
KT.BackgroundTransparency = 1
KT.Font = Enum.Font.GothamSemibold
KT.ZIndex = 7

local KeyBtn = Instance.new("TextButton", KeyCard)
KeyBtn.Size = UDim2.new(0.25, 0, 0, 32)
KeyBtn.Position = UDim2.new(0.7, 0, 0.5, -16)
KeyBtn.Text = "H"
KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBtn.TextSize = 13
KeyBtn.BackgroundColor3 = Color3.fromRGB(50, 42, 42)
KeyBtn.BackgroundTransparency = 0.2
KeyBtn.BorderSizePixel = 0
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.ZIndex = 7
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 6)

-- ЕСП панель
local EspPanel = Instance.new("Frame", Right)
EspPanel.Size = UDim2.new(1, 0, 1, 0)
EspPanel.BackgroundTransparency = 1
EspPanel.Visible = false
EspPanel.ZIndex = 5

local EspCard = Instance.new("Frame", EspPanel)
EspCard.Size = UDim2.new(0.95, 0, 0, 80)
EspCard.Position = UDim2.new(0.025, 0, 0.1, 0)
EspCard.BackgroundColor3 = Color3.fromRGB(35, 28, 28)
EspCard.BackgroundTransparency = 0.15
EspCard.BorderSizePixel = 0
EspCard.ZIndex = 6
Instance.new("UICorner", EspCard).CornerRadius = UDim.new(0, 12)

local ET = Instance.new("TextLabel", EspCard)
ET.Size = UDim2.new(0.7, 0, 0, 20)
ET.Position = UDim2.new(0.05, 0, 0.1, 0)
ET.Text = "Включить ESP"
ET.TextColor3 = Color3.fromRGB(255, 255, 255)
ET.TextSize = 13
ET.TextXAlignment = Enum.TextXAlignment.Left
ET.BackgroundTransparency = 1
ET.Font = Enum.Font.GothamSemibold
ET.ZIndex = 7

local ED = Instance.new("TextLabel", EspCard)
ED.Size = UDim2.new(0.7, 0, 0, 18)
ED.Position = UDim2.new(0.05, 0, 0.38, 0)
ED.Text = "Обводка врагов через стены"
ED.TextColor3 = Color3.fromRGB(180, 180, 180)
ED.TextSize = 11
ED.TextXAlignment = Enum.TextXAlignment.Left
ED.BackgroundTransparency = 1
ED.Font = Enum.Font.Gotham
ED.ZIndex = 7

local ETbg = Instance.new("Frame", EspCard)
ETbg.Size = UDim2.new(0, 45, 0, 24)
ETbg.Position = UDim2.new(1, -55, 0.5, -12)
ETbg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
ETbg.BorderSizePixel = 0
ETbg.ZIndex = 7
Instance.new("UICorner", ETbg).CornerRadius = UDim.new(1, 0)

local ETknob = Instance.new("Frame", ETbg)
ETknob.Size = UDim2.new(0, 18, 0, 18)
ETknob.Position = UDim2.new(0, 3, 0.5, -9)
ETknob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
ETknob.BorderSizePixel = 0
ETknob.ZIndex = 8
Instance.new("UICorner", ETknob).CornerRadius = UDim.new(1, 0)

local ETbtn = Instance.new("TextButton", EspCard)
ETbtn.Size = UDim2.new(1, 0, 1, 0)
ETbtn.BackgroundTransparency = 1
ETbtn.Text = ""
ETbtn.ZIndex = 9

local ColorCard = Instance.new("Frame", EspPanel)
ColorCard.Size = UDim2.new(0.95, 0, 0, 80)
ColorCard.Position = UDim2.new(0.025, 0, 0.35, 0)
ColorCard.BackgroundColor3 = Color3.fromRGB(35, 28, 28)
ColorCard.BackgroundTransparency = 0.15
ColorCard.BorderSizePixel = 0
ColorCard.ZIndex = 6
Instance.new("UICorner", ColorCard).CornerRadius = UDim.new(0, 12)

local CT = Instance.new("TextLabel", ColorCard)
CT.Size = UDim2.new(0.5, 0, 0, 20)
CT.Position = UDim2.new(0.05, 0, 0.1, 0)
CT.Text = "Цвет обводки"
CT.TextColor3 = Color3.fromRGB(255, 255, 255)
CT.TextSize = 13
CT.TextXAlignment = Enum.TextXAlignment.Left
CT.BackgroundTransparency = 1
CT.Font = Enum.Font.GothamSemibold
CT.ZIndex = 7

local CF = Instance.new("Frame", ColorCard)
CF.Size = UDim2.new(0.9, 0, 0, 32)
CF.Position = UDim2.new(0.05, 0, 0.45, 0)
CF.BackgroundTransparency = 1
CF.ZIndex = 7

local espColors = {
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(180, 0, 255),
    Color3.fromRGB(255, 0, 0)
}

for i, c in ipairs(espColors) do
    local cb = Instance.new("TextButton", CF)
    cb.Size = UDim2.new(0.22, 0, 1, 0)
    cb.Position = UDim2.new((i-1) * 0.26, 0, 0, 0)
    cb.Text = ""
    cb.BackgroundColor3 = c
    cb.BorderSizePixel = 0
    cb.ZIndex = 8
    Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 6)
    cb.MouseButton1Click:Connect(function()
        EspColor = c
        for _, h in pairs(EspHighlights) do
            if h and h.Parent then
                h.FillColor = EspColor
                h.OutlineColor = EspColor
            end
        end
    end)
end

-- ===== ФУНКЦИИ =====
local function UpdateToggle(bg, knob, enabled)
    if enabled then
        bg.BackgroundColor3 = Color3.fromRGB(255, 160, 50)
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 24, 0.5, -9)}):Play()
    else
        bg.BackgroundColor3 = Color3.fromRGB(60, 55, 55)
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
    end
end

local function GetParts(char)
    local parts = {}
    for _, p in ipairs(char:GetChildren()) do
        if p:IsA("BasePart") then table.insert(parts, p) end
    end
    return parts
end

function ApplyHitboxToPlayer(op)
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

function EnableHitbox()
    if MenuClosed then return end
    HitboxActive = true
    OriginalSizes = {}
    for _, op in ipairs(game.Players:GetPlayers()) do ApplyHitboxToPlayer(op) end
    UpdateToggle(HTbg, HTknob, true)
end

function DisableHitbox()
    HitboxActive = false
    for part, data in pairs(OriginalSizes) do
        if part and part.Parent then part.Size = data.Size end
    end
    OriginalSizes = {}
    UpdateToggle(HTbg, HTknob, false)
end

function ApplyEspToPlayer(op)
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

function EnableEsp()
    if MenuClosed then return end
    EspActive = true
    EspHighlights = {}
    for _, op in ipairs(game.Players:GetPlayers()) do ApplyEspToPlayer(op) end
    UpdateToggle(ETbg, ETknob, true)
end

function DisableEsp()
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
    UpdateToggle(ETbg, ETknob, false)
end

-- ===== ХОТКЕЙ =====
local function KeyStr(kc)
    return tostring(kc):gsub("Enum.KeyCode.", "")
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or MenuClosed then return end
    if SettingKeybind then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            HitboxHotkey = input.KeyCode
            KeyBtn.Text = KeyStr(input.KeyCode)
            SettingKeybind = false
        end
        return
    end
    if input.KeyCode == HitboxHotkey then
        if HitboxActive then DisableHitbox() else EnableHitbox() end
    end
end)

-- ===== ЦИКЛ =====
task.spawn(function()
    while ScreenGui.Parent and not MenuClosed do
        task.wait(0.5)
        if EspActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyEspToPlayer(p) end
        end
        if HitboxActive then
            for _, p in ipairs(game.Players:GetPlayers()) do ApplyHitboxToPlayer(p) end
        end
    end
end)

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if MenuClosed then return end
        if EspActive then ApplyEspToPlayer(p) end
        if HitboxActive then ApplyHitboxToPlayer(p) end
    end)
end)

-- ===== ВКЛАДКИ =====
local function ResetTabs()
    AimTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    AimTab.BackgroundTransparency = 1
    EspTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    EspTab.BackgroundTransparency = 1
end

AimTab.MouseButton1Click:Connect(function()
    ResetTabs()
    AimTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimTab.BackgroundColor3 = Color3.fromRGB(50, 40, 40)
    AimTab.BackgroundTransparency = 0.3
    AimPanel.Visible = true
    EspPanel.Visible = false
    PanelTitle.Text = "Аим"
end)

EspTab.MouseButton1Click:Connect(function()
    ResetTabs()
    EspTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    EspTab.BackgroundColor3 = Color3.fromRGB(50, 40, 40)
    EspTab.BackgroundTransparency = 0.3
    AimPanel.Visible = false
    EspPanel.Visible = true
    PanelTitle.Text = "ЕСП"
end)

-- ===== КНОПКИ =====
HTbtn.MouseButton1Click:Connect(function()
    if HitboxActive then DisableHitbox() else EnableHitbox() end
end)

ETbtn.MouseButton1Click:Connect(function()
    if EspActive then DisableEsp() else EnableEsp() end
end)

KeyBtn.MouseButton1Click:Connect(function()
    SettingKeybind = true
    KeyBtn.Text = "..."
end)

CloseBtn.MouseButton1Click:Connect(function()
    MenuClosed = true
    if HitboxActive then DisableHitbox() end
    if EspActive then DisableEsp() end
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    if MainFrame.Size.Y.Offset == 420 then
        MainFrame.Size = UDim2.new(0, 620, 0, 50)
    else
        MainFrame.Size = UDim2.new(0, 620, 0, 420)
    end
end)

print("✅ ARTARIO HUB загружен! by artar")
print("H — вкл/выкл хитбоксы")
