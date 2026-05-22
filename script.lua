-- ================================================
--   BLOX FRUITS OVERSEER - V6 (AUTO FARM + QUEST)
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Config = {
    AutoFarm      = false,
    AutoQuest     = false,
    DistanceAbove = 8,
    MobRange      = 1500,
    HitboxSize    = 60,
    AttackDelay   = 0.35,   -- Delay entre ataques (segundos)
}

-- ================================================
--   INYECCIÓN SEGURA DE GUI
-- ================================================
local CoreTarget
local ok, result = pcall(function() return game:GetService("CoreGui") end)
CoreTarget = (ok and result) or LocalPlayer:WaitForChild("PlayerGui")

for _, v in pairs(CoreTarget:GetChildren()) do
    if v.Name == "Overseer_BloxFruits" then v:Destroy() end
end

local OverseerUI = Instance.new("ScreenGui")
OverseerUI.Name = "Overseer_BloxFruits"
OverseerUI.ResetOnSpawn = false
OverseerUI.DisplayOrder = 999
OverseerUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OverseerUI.Parent = CoreTarget

-- ================================================
--   ÍCONO MINIMIZADO
-- ================================================
local OpenIcon = Instance.new("TextButton")
OpenIcon.Size = UDim2.new(0, 50, 0, 50)
OpenIcon.Position = UDim2.new(0, 20, 0.5, -25)
OpenIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenIcon.Text = "⚔️"
OpenIcon.TextSize = 24
OpenIcon.Visible = false
OpenIcon.ZIndex = 10
OpenIcon.Parent = OverseerUI
Instance.new("UICorner", OpenIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 60, 80)
IconStroke.Thickness = 2
IconStroke.Parent = OpenIcon

-- ================================================
--   PANEL PRINCIPAL (más alto para el nuevo botón)
-- ================================================
local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 320, 0, 270)
MainPanel.Position = UDim2.new(0.5, -160, 0.5, -135)
MainPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainPanel.BorderSizePixel = 0
MainPanel.Active = true
MainPanel.Visible = true
MainPanel.ZIndex = 1
MainPanel.Parent = OverseerUI
Instance.new("UICorner", MainPanel).CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(35, 35, 45)
UIStroke.Thickness = 1
UIStroke.Parent = MainPanel

-- TOPBAR
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Topbar.BorderSizePixel = 0
Topbar.ZIndex = 2
Topbar.Parent = MainPanel
Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "O V E R S E E R  V6"
Title.TextColor3 = Color3.fromRGB(255, 60, 80)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 10
CloseBtn.Parent = Topbar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ================================================
--   BOTÓN AUTO FARM
-- ================================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.075, 0, 0, 55)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
ToggleBtn.Text = "⚔️  INICIAR AUTO FARM"
ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.ZIndex = 3
ToggleBtn.Parent = MainPanel
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)
local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(40, 40, 55)
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BtnStroke.Parent = ToggleBtn

-- ================================================
--   BOTÓN AUTO QUEST
-- ================================================
local QuestBtn = Instance.new("TextButton")
QuestBtn.Size = UDim2.new(0.85, 0, 0, 40)
QuestBtn.Position = UDim2.new(0.075, 0, 0, 105)
QuestBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
QuestBtn.Text = "📋  INICIAR AUTO QUEST"
QuestBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
QuestBtn.Font = Enum.Font.GothamBold
QuestBtn.TextSize = 13
QuestBtn.ZIndex = 3
QuestBtn.Parent = MainPanel
Instance.new("UICorner", QuestBtn).CornerRadius = UDim.new(0, 6)
local QuestStroke = Instance.new("UIStroke")
QuestStroke.Color = Color3.fromRGB(40, 40, 55)
QuestStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
QuestStroke.Parent = QuestBtn

-- LABELS
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0.9, 0, 0, 25)
StatusText.Position = UDim2.new(0.05, 0, 0, 158)
StatusText.BackgroundTransparency = 1
StatusText.Text = "ESTADO: EN ESPERA"
StatusText.TextColor3 = Color3.fromRGB(120, 120, 120)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 12
StatusText.ZIndex = 3
StatusText.Parent = MainPanel

local TargetText = Instance.new("TextLabel")
TargetText.Size = UDim2.new(0.9, 0, 0, 25)
TargetText.Position = UDim2.new(0.05, 0, 0, 183)
TargetText.BackgroundTransparency = 1
TargetText.Text = "OBJETIVO: NINGUNO"
TargetText.TextColor3 = Color3.fromRGB(80, 80, 80)
TargetText.Font = Enum.Font.Gotham
TargetText.TextSize = 12
TargetText.ZIndex = 3
TargetText.Parent = MainPanel

local QuestText = Instance.new("TextLabel")
QuestText.Size = UDim2.new(0.9, 0, 0, 25)
QuestText.Position = UDim2.new(0.05, 0, 0, 208)
QuestText.BackgroundTransparency = 1
QuestText.Text = "QUEST: SIN QUEST"
QuestText.TextColor3 = Color3.fromRGB(80, 130, 200)
QuestText.Font = Enum.Font.Gotham
QuestText.TextSize = 12
QuestText.ZIndex = 3
QuestText.Parent = MainPanel

local AttackText = Instance.new("TextLabel")
AttackText.Size = UDim2.new(0.9, 0, 0, 25)
AttackText.Position = UDim2.new(0.05, 0, 0, 233)
AttackText.BackgroundTransparency = 1
AttackText.Text = "ATAQUE: INACTIVO"
AttackText.TextColor3 = Color3.fromRGB(80, 80, 80)
AttackText.Font = Enum.Font.Gotham
AttackText.TextSize = 12
AttackText.ZIndex = 3
AttackText.Parent = MainPanel

-- ================================================
--   ARRASTRE PANEL
-- ================================================
local dragging, dragStart, startPos

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainPanel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        MainPanel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ================================================
--   ARRASTRE ÍCONO
-- ================================================
local iconDragging, iconDragStart, iconStartPos, iconMoved

OpenIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconMoved = false
        iconDragStart = input.Position
        iconStartPos = OpenIcon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if iconDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - iconDragStart
        if delta.Magnitude > 5 then
            iconMoved = true
            OpenIcon.Position = UDim2.new(
                iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X,
                iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = false
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = false
    OpenIcon.Visible = true
end)

OpenIcon.MouseButton1Click:Connect(function()
    if not iconMoved then
        MainPanel.Visible = true
        OpenIcon.Visible = false
    end
    iconMoved = false
end)

-- ================================================
--   PERSONAJE
-- ================================================
local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Humanoid = newChar:WaitForChild("Humanoid")
end)

-- ================================================
--   ANTI-AFK
-- ================================================
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendKeyEvent(true, "Space", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "Space", false, game)
end)

-- ================================================
--   COLISIÓN DESACTIVADA MIENTRAS FARMEA
-- ================================================
RunService.Stepped:Connect(function()
    if Config.AutoFarm and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ================================================
--   FUNCIONES DE FARM
-- ================================================
local function TweenMove(targetCFrame)
    if not HumanoidRootPart then return nil end
    local dist = (HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(dist / 350, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )
    tween:Play()
    return tween
end

local function AutoEquip()
    if not Character then return end
    if not Character:FindFirstChildOfClass("Tool") then
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                Humanoid:EquipTool(item)
                break
            end
        end
    end
end

local function ExpandHitbox(targetMob)
    local mobRoot = targetMob and targetMob:FindFirstChild("HumanoidRootPart")
    if mobRoot then
        mobRoot.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
        mobRoot.Transparency = 1
        mobRoot.CanCollide = false
    end
end

local function GetValidMob()
    if not HumanoidRootPart then return nil end
    local nearest, minDist = nil, Config.MobRange
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, obj in ipairs(enemies:GetChildren()) do
        local h = obj:FindFirstChild("Humanoid")
        local r = obj:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health > 0 then
            local d = (HumanoidRootPart.Position - r.Position).Magnitude
            if d < minDist then
                minDist = d
                nearest = obj
            end
        end
    end
    return nearest
end

-- ================================================
--   FIX ATAQUE AUTOMÁTICO
--   Loop separado con delay propio para que ataque
--   de forma continua sin depender del Heartbeat
-- ================================================
local attackRunning = false

local function StartAttackLoop()
    if attackRunning then return end
    attackRunning = true

    task.spawn(function()
        while attackRunning and Config.AutoFarm do
            if Character and HumanoidRootPart and Humanoid and Humanoid.Health > 0 then
                local mob = GetValidMob()
                if mob then
                    ExpandHitbox(mob)
                    AutoEquip()

                    -- Ataque con click
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(850, 500))

                    -- Ataque con tecla Z (habilidades básicas de Blox Fruits)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game)

                    AttackText.Text = "ATAQUE: ✅ CONECTADO"
                    AttackText.TextColor3 = Color3.fromRGB(80, 220, 80)
                else
                    AttackText.Text = "ATAQUE: 🔍 BUSCANDO"
                    AttackText.TextColor3 = Color3.fromRGB(180, 180, 60)
                end
            end
            task.wait(Config.AttackDelay)
        end
        attackRunning = false
        AttackText.Text = "ATAQUE: INACTIVO"
        AttackText.TextColor3 = Color3.fromRGB(80, 80, 80)
    end)
end

-- ================================================
--   LOOP DE MOVIMIENTO (Heartbeat)
-- ================================================
local farmConnection = nil
local currentTween = nil

local function LoopFarm()
    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end

    farmConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoFarm then
            if currentTween then currentTween:Cancel() end
            return
        end
        if not Character or not HumanoidRootPart or not Humanoid then return end
        if Humanoid.Health <= 0 then return end

        local mob = GetValidMob()
        if mob and mob:FindFirstChild("HumanoidRootPart") then
            TargetText.Text = "OBJETIVO: " .. string.upper(mob.Name)
            local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, Config.DistanceAbove, 0)
            local faceCFrame = CFrame.new(targetPos.Position, mob.HumanoidRootPart.Position)

            if (HumanoidRootPart.Position - targetPos.Position).Magnitude > 15 then
                currentTween = TweenMove(faceCFrame)
            else
                if currentTween then currentTween:Cancel() end
                HumanoidRootPart.CFrame = faceCFrame
            end
        else
            TargetText.Text = "OBJETIVO: 🔍 BUSCANDO..."
        end
    end)
end

-- ================================================
--   AUTO QUEST
-- ================================================

-- Tabla de NPCs de quest por nivel aproximado
-- (zona, nombre del NPC, posición CFrame)
local QuestNPCs = {
    { name = "Monkey",         minLv = 1,    maxLv = 14,  pos = CFrame.new(977, 20, 1818) },
    { name = "Bandit",         minLv = 15,   maxLv = 29,  pos = CFrame.new(978, 20, 1814) },
    { name = "Pirate",         minLv = 30,   maxLv = 59,  pos = CFrame.new(-1222, 131, 3975) },
    { name = "Brute",          minLv = 60,   maxLv = 89,  pos = CFrame.new(-1234, 131, 3967) },
    { name = "Desert Bandit",  minLv = 90,   maxLv = 119, pos = CFrame.new(958, 7, -831) },
    { name = "Desert Officer", minLv = 120,  maxLv = 174, pos = CFrame.new(949, 7, -841) },
    { name = "Snow Bandit",    minLv = 175,  maxLv = 224, pos = CFrame.new(-1172, 196, -3310) },
    { name = "Arctic Warrior", minLv = 225,  maxLv = 299, pos = CFrame.new(-1178, 196, -3322) },
    { name = "Magma Ninja",    minLv = 300,  maxLv = 374, pos = CFrame.new(-3015, 24, -11810) },
    { name = "Thunder God",    minLv = 375,  maxLv = 449, pos = CFrame.new(-3010, 24, -11820) },
    { name = "Zombie",         minLv = 450,  maxLv = 524, pos = CFrame.new(-6196, 24, -9003) },
    { name = "Vampire",        minLv = 525,  maxLv = 624, pos = CFrame.new(-6200, 24, -9010) },
    { name = "Dragon Crew",    minLv = 625,  maxLv = 699, pos = CFrame.new(11, 118, -6476) },
    { name = "Fishman",        minLv = 700,  maxLv = 774, pos = CFrame.new(-3610, -7, -8222) },
    { name = "Tide Keeper",    minLv = 775,  maxLv = 849, pos = CFrame.new(-3603, -7, -8215) },
    { name = "Dark Master",    minLv = 850,  maxLv = 999, pos = CFrame.new(6119, 72, -12050) },
}

local function GetCurrentLevel()
    local gui = LocalPlayer:WaitForChild("PlayerGui", 3)
    if not gui then return 1 end
    -- Intenta leer el nivel desde los valores del personaje
    local stats = LocalPlayer:FindFirstChild("leaderstats") or
                  LocalPlayer:FindFirstChild("Stats")
    if stats then
        local lv = stats:FindFirstChild("Level") or stats:FindFirstChild("Beli")
        if lv then return lv.Value or 1 end
    end
    return 1
end

local function GetQuestNPC()
    local lv = GetCurrentLevel()
    for _, npc in ipairs(QuestNPCs) do
        if lv >= npc.minLv and lv <= npc.maxLv then
            return npc
        end
    end
    return QuestNPCs[1] -- Por defecto nivel bajo
end

local function HasActiveQuest()
    -- Revisa si hay quest activa mirando el PlayerGui de Blox Fruits
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Quest", true)
    if questGui then return true end

    -- También busca por el sistema de quest del juego
    local questFolder = LocalPlayer:FindFirstChild("Quests")
    if questFolder and #questFolder:GetChildren() > 0 then
        return true
    end
    return false
end

local function AcceptQuest(npcData)
    if not HumanoidRootPart then return end

    QuestText.Text = "QUEST: 🚶 YENDO A " .. npcData.name
    QuestText.TextColor3 = Color3.fromRGB(255, 200, 60)

    -- Teleporta al NPC
    HumanoidRootPart.CFrame = npcData.pos + Vector3.new(0, 3, 0)
    task.wait(0.5)

    -- Intenta disparar el remote de quest de Blox Fruits
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local questRemote = remotes:FindFirstChild("SelectQuest")
            or remotes:FindFirstChild("StartQuest")
            or remotes:FindFirstChild("GiveQuest")
        if questRemote then
            pcall(function()
                questRemote:FireServer(npcData.name, 1)
            end)
            QuestText.Text = "QUEST: ✅ " .. npcData.name
            QuestText.TextColor3 = Color3.fromRGB(80, 220, 80)
            return
        end
    end

    -- Fallback: busca el NPC en workspace y lo activa
    local npcModel = workspace:FindFirstChild(npcData.name, true)
    if npcModel then
        local npcRoot = npcModel:FindFirstChild("HumanoidRootPart")
            or npcModel:FindFirstChild("Torso")
            or npcModel.PrimaryPart
        if npcRoot then
            HumanoidRootPart.CFrame = npcRoot.CFrame + Vector3.new(0, 2, 4)
            task.wait(0.3)
            -- Click sobre el NPC para abrir diálogo
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(workspace.CurrentCamera.ViewportSize.X/2,
                                                  workspace.CurrentCamera.ViewportSize.Y/2))
            task.wait(0.5)
            -- Presiona E para confirmar quest
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            QuestText.Text = "QUEST: ✅ " .. npcData.name
            QuestText.TextColor3 = Color3.fromRGB(80, 220, 80)
        end
    else
        QuestText.Text = "QUEST: ⚠️ NPC no encontrado"
        QuestText.TextColor3 = Color3.fromRGB(255, 100, 60)
    end
end

-- Loop de auto quest
local questRunning = false

local function StartQuestLoop()
    if questRunning then return end
    questRunning = true

    task.spawn(function()
        while questRunning and Config.AutoQuest do
            if not HasActiveQuest() then
                local npcData = GetQuestNPC()
                AcceptQuest(npcData)
                task.wait(2)
            else
                QuestText.Text = "QUEST: ✅ ACTIVA"
                QuestText.TextColor3 = Color3.fromRGB(80, 220, 80)
                task.wait(5)  -- Revisa cada 5 seg si sigue activa
            end
        end
        questRunning = false
        QuestText.Text = "QUEST: SIN QUEST"
        QuestText.TextColor3 = Color3.fromRGB(80, 130, 200)
    end)
end

-- ================================================
--   BOTÓN AUTO FARM
-- ================================================
ToggleBtn.MouseButton1Click:Connect(function()
    Config.AutoFarm = not Config.AutoFarm

    if Config.AutoFarm then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
        BtnStroke.Color = Color3.fromRGB(255, 100, 120)
        ToggleBtn.Text = "⚔️  SISTEMA ACTIVO"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusText.Text = "ESTADO: ANIQUILANDO"
        StatusText.TextColor3 = Color3.fromRGB(255, 60, 80)
        LoopFarm()
        StartAttackLoop()   -- ← Loop de ataque independiente
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        BtnStroke.Color = Color3.fromRGB(40, 40, 55)
        ToggleBtn.Text = "⚔️  INICIAR AUTO FARM"
        ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusText.Text = "ESTADO: EN ESPERA"
        StatusText.TextColor3 = Color3.fromRGB(120, 120, 120)
        TargetText.Text = "OBJETIVO: NINGUNO"
        attackRunning = false
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- ================================================
--   BOTÓN AUTO QUEST
-- ================================================
QuestBtn.MouseButton1Click:Connect(function()
    Config.AutoQuest = not Config.AutoQuest

    if Config.AutoQuest then
        QuestBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
        QuestStroke.Color = Color3.fromRGB(80, 160, 255)
        QuestBtn.Text = "📋  QUEST ACTIVO"
        QuestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StartQuestLoop()
    else
        QuestBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        QuestStroke.Color = Color3.fromRGB(40, 40, 55)
        QuestBtn.Text = "📋  INICIAR AUTO QUEST"
        QuestBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        questRunning = false
        QuestText.Text = "QUEST: SIN QUEST"
        QuestText.TextColor3 = Color3.fromRGB(80, 130, 200)
    end
end)

print("✅ Overseer V6 cargado correctamente")
