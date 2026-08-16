-- PHANTOM DUELS ULTIMATE SCRIPT
-- Tema: Branco, Preto e Roxo
-- Estilo: Clean, Moderno, Profissional
-- Background Custom ID: 10864112020
-- Insta Reset: Reset normal do jogo
-- Intro removida completamente

local BG = Color3.fromRGB(255, 255, 255)
local SIDEBAR_BG = Color3.fromRGB(245, 240, 255)
local CARD_BG = Color3.fromRGB(248, 245, 255)
local CARD_HOV = Color3.fromRGB(235, 225, 255)
local KB_BG = Color3.fromRGB(230, 220, 255)
local WHITE = Color3.fromRGB(255, 255, 255)
local DIM = Color3.fromRGB(150, 130, 200)
local DIM2 = Color3.fromRGB(200, 180, 230)
local BORDER = Color3.fromRGB(180, 150, 230)
local BORDER2 = Color3.fromRGB(160, 130, 210)
local OPTION_TRANSPARENCY = 0.3
local OPTION_HOVER_TRANSPARENCY = 0.1
local INPUT_TRANSPARENCY = 0.15

local CUSTOM_BG_ID = "10864112020"

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local function getPingMilliseconds()
    local ok, value = pcall(function()
        local stats = game:GetService("Stats")
        local network = stats:FindFirstChild("Network")
        local serverStats = network and network:FindFirstChild("ServerStatsItem")
        local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
        if not pingItem then return nil end
        local numericValue
        pcall(function()
            numericValue = pingItem:GetValue()
        end)
        if type(numericValue) == "number" then return numericValue end
        local valueString = pingItem:GetValueString()
        return tonumber(tostring(valueString):match("[%d%.]+"))
    end)
    return ok and tonumber(value) or nil
end

local function showHighPingAlert()
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local player = Players.LocalPlayer
    local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
    pcall(function()
        local old = CoreGui:FindFirstChild("PrimeHighPingAlert")
        if old then old:Destroy() end
    end)
    pcall(function()
        local old = playerGui and playerGui:FindFirstChild("PrimeHighPingAlert")
        if old then old:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "PrimeHighPingAlert"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = false
    gui.DisplayOrder = 10000
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    local parented = pcall(function()
        gui.Parent = CoreGui
    end)
    if not parented or not gui.Parent then
        gui.Parent = playerGui
    end
    if not gui.Parent then
        gui:Destroy()
        return
    end
    local bar = Instance.new("Frame")
    bar.Name = "AlertBar"
    bar.AnchorPoint = Vector2.new(0.5, 0)
    bar.Position = UDim2.new(0.5, 0, 0, -44)
    bar.Size = UDim2.new(0, 310, 0, 32)
    bar.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
    bar.BackgroundTransparency = 0.06
    bar.BorderSizePixel = 0
    bar.ClipsDescendants = true
    bar.ZIndex = 100
    bar.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = bar
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 100, 220)
    stroke.Transparency = 0.2
    stroke.Thickness = 1
    stroke.Parent = bar
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 60, 140)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 120, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 60, 140)),
    })
    gradient.Parent = bar
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = "⚡ HIGH PING! Your ping is more than 150."
    label.TextColor3 = Color3.fromRGB(200, 150, 255)
    label.TextSize = 13
    label.TextStrokeColor3 = Color3.fromRGB(50, 30, 80)
    label.TextStrokeTransparency = 0.55
    label.TextWrapped = false
    label.TextScaled = false
    label.ZIndex = 102
    label.Parent = bar
    local slideIn = TweenService:Create(
        bar,
        TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0, 10)}
    )
    slideIn:Play()
    slideIn.Completed:Wait()
    task.wait(2)
    local slideOut = TweenService:Create(
        bar,
        TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, 0, 0, -44)}
    )
    slideOut:Play()
    slideOut.Completed:Wait()
    gui:Destroy()
end

local function showHighPingLoop()
    local shown = false
    while not shown do
        local ping = getPingMilliseconds()
        if ping and ping > 150 then
            shown = true
            showHighPingAlert()
            break
        end
        task.wait(1)
    end
end

task.spawn(showHighPingLoop)

do
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local SoundService = game:GetService("SoundService")
    local HttpService = game:GetService("HttpService")
    local noIntroSaved = false
    
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile("PHANTOM_DUELS_CONFIG.json") then
            local decoded = HttpService:JSONDecode(readfile("PHANTOM_DUELS_CONFIG.json"))
            if type(decoded) == "table" then
                if decoded.noIntro ~= nil then
                    noIntroSaved = decoded.noIntro == true
                end
            end
        end
    end)
    
    local sharedEnv = (getgenv and getgenv()) or _G
    sharedEnv.__PHANTOM_NO_INTRO_SAVED = true
    
    for _, n in ipairs({"PrimeIntro", "PrimeHoneypotGui", "AdaptIntro", "AdaptHoneypotGui"}) do
        pcall(function()
            local old = CoreGui:FindFirstChild(n)
            if old then old:Destroy() end
        end)
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

;(function()
local NS, CS, LS, LS2 = 60, 30, 15, 24.5
local laggerPhase = 0
local State = {
    speedToggled = false, laggerToggled = false, autoBatToggled = false,
    speedProfile = "Normal",
    profileLaggerNormalSpeed = 40,
    profileLaggerCarrySpeed = 20,
    hittingCooldown = false, infJumpEnabled = false,
    antiRagdollEnabled = false, fpsBoostEnabled = false,
    antiLagEnabled = false,
    hitboxFollowerEnabled = false,
    guiVisible = true,
    noIntro = true,
    introEnabled = false,
    selectedIntroMusic = 1,
    isStealing = false, stealStartTime = nil, lastStealTick = 0,
    lastKnownHealth = 100,
    dropActive = false,
    dropBrainrotActive = false,
    autoLeftEnabled = false, autoRightEnabled = false,
    tpBatEnabled = false,
    tpBatVersion = 1,
    unwalkEnabled = false,
    stretchRezEnabled = false, removeAccessoriesEnabled = false,
    darkModeEnabled = false, skyStyle = "Off",
    backgroundAssetId = "10864112020",
    backgroundAssetIds = {
        "10864112020",
    },
    theme = "PurpleWhite",
    imageChoiceVisuals = {},
}
local _anyKeyListening, uiLocked = false, false
local setLockUIVisual, MobilePanel, rebuildMobileButtons, resetMobileButtons
local mobileBtnFrames, mobileBtnActive, allMobileBtns = {}, {}, {}
local mobileButtonsByName = {}
local mobileButtonDefaultPositions = {}

local KB = {
    AutoLeft  = {kb = Enum.KeyCode.Z,           gp = nil},
    AutoRight = {kb = Enum.KeyCode.C,           gp = nil},
    Drop      = {kb = Enum.KeyCode.X,           gp = nil},
    TPDown    = {kb = Enum.KeyCode.F,           gp = nil},
    AutoBat   = {kb = Enum.KeyCode.E,           gp = nil},
    AutoBatV2 = {kb = nil,                      gp = nil},
    TPBat     = {kb = nil,                      gp = nil},
    Speed     = {kb = Enum.KeyCode.Q,           gp = nil},
    Lagger    = {kb = Enum.KeyCode.R,           gp = nil},
    InstaReset= {kb = nil,                      gp = nil},
    GuiHide   = {kb = Enum.KeyCode.LeftControl, gp = nil},
}

local function kbMatch(entry, kc)
    return kc == entry.kb or (entry.gp and kc == entry.gp)
end

local function getProfileNormalSpeed()
    return State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS
end

local function getProfileCarrySpeed()
    return State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS
end

State._speedAttachment = nil
State._speedLinearVelocity = nil
State.setupSpeedVelocity = function(root)
    if State._speedLinearVelocity then State._speedLinearVelocity:Destroy(); State._speedLinearVelocity = nil end
    if State._speedAttachment then State._speedAttachment:Destroy(); State._speedAttachment = nil end
    if not root then return nil end
    local attachment = Instance.new("Attachment")
    attachment.Name = "WBBoostAttachment"
    attachment.Parent = root
    local linearVelocity = Instance.new("LinearVelocity")
    linearVelocity.Name = "WBBoostVelocity"
    linearVelocity.Attachment0 = attachment
    linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    linearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
    linearVelocity.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
    linearVelocity.VectorVelocity = Vector3.zero
    linearVelocity.Enabled = true
    linearVelocity.Parent = attachment
    State._speedAttachment = attachment
    State._speedLinearVelocity = linearVelocity
    return linearVelocity
end

State.destroySpeedVelocity = function()
    if State._speedLinearVelocity then pcall(function() State._speedLinearVelocity:Destroy() end); State._speedLinearVelocity = nil end
    if State._speedAttachment then pcall(function() State._speedAttachment:Destroy() end); State._speedAttachment = nil end
end

LP.CharacterAdded:Connect(function() State.destroySpeedVelocity() end)

State.isRagdollSpeed = function(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

State.getActiveMoveSpeed = function()
    if State.laggerToggled then
        return laggerPhase == 2 and LS2 or LS
    end
    return State.speedToggled and getProfileCarrySpeed() or getProfileNormalSpeed()
end

State.getAutoPathSpeed = function()
    return NS
end

local AP = {
    L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), L_FACE=Vector3.new(-482.25,-4.96,92.09),
    R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), R_FACE=Vector3.new(-482.06,-6.93,35.47),
}

local Steal = {
    AutoStealEnabled = false, StealRadius = 10, StealDuration = 1.3,
    Data = {}, plotCache = {}, plotCacheTime = {},
    cachedPrompts = {}, promptCacheTime = 0,
}

local Conns = {
    autoSteal = nil, antiRag = nil,
    anchor = {}, progress = nil,
}

local safetyPositionIsValid
local startBatAimbot, stopBatAimbot

local function findAnyToolMob()
    local c=LP.Character
    if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
    local bp=LP:FindFirstChildOfClass("Backpack")
    if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
    return nil
end

local MOB_SWING_COOLDOWN=0.08
local _aimbotTarget = nil

local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

local function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end

stopBatAimbot = function()
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
    _aimbotTarget = nil
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
    State.hittingCooldown = false
    _autoBatTarget = nil
    _autoBatEquippedThisRun = false
    if State._hitboxFollower and State._hitboxFollower.pausedByBatAim then
        State._hitboxFollower.pausedByBatAim = false
        if State.hitboxFollowerEnabled and not State.tpBatEnabled then State._hitboxFollower.start() end
    end
end

startBatAimbot = function()
    if Conns.aimbot then Conns.aimbot:Disconnect() end
    _autoBatEquippedThisRun = false
    if State._hitboxFollower and State.hitboxFollowerEnabled then
        State._hitboxFollower.pausedByBatAim = true
        State._hitboxFollower.stop()
    end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    Conns.aimbot = RunService.RenderStepped:Connect(function(dt)
        if not State.autoBatToggled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then
            hum.AutoRotate = true
            return
        end
        _aimbotTarget = target
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
        local chaseSpeed = 60
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local curCF  = root.CFrame
            local diffCF = curCF:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            local tiltSpeed = 42
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
            )
        end
        if State.autoSwingEnabled then
            local bat = char:FindFirstChildOfClass("Tool")
            if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
                pcall(function() bat:Activate() end)
            end
        end
    end)
end

State._hitboxFollower = State._hitboxFollower or {
    LOCK_RANGE = 150,
    enabled = false,
    conn = nil,
    pausedByBatAim = false,
}
State._hitboxFollower.pausedByBatAim = State._hitboxFollower.pausedByBatAim == true

function State._hitboxFollower.getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function State._hitboxFollower.tick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    local target = State._hitboxFollower.getClosestTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > State._hitboxFollower.LOCK_RANGE then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed = targetVel.Magnitude
    local predictTime = math.clamp(speed / 150, 0.05, 0.2)
    local predictedPos = target.Position + targetVel * predictTime
    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function State._hitboxFollower.start()
    State._hitboxFollower.enabled = true
    if State._hitboxFollower.conn then State._hitboxFollower.conn:Disconnect() end
    State._hitboxFollower.conn = RunService.RenderStepped:Connect(function()
        if State._hitboxFollower.enabled and not State.autoBatToggled and not State.tpBatEnabled then
            State._hitboxFollower.tick()
        end
    end)
end

function State._hitboxFollower.stop()
    State._hitboxFollower.enabled = false
    if State._hitboxFollower.conn then
        State._hitboxFollower.conn:Disconnect()
        State._hitboxFollower.conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.hitboxFollowerEnabled and not State.autoBatToggled and not State.tpBatEnabled then
        State._hitboxFollower.stop()
        task.wait(0.2)
        State._hitboxFollower.start()
    elseif State.hitboxFollowerEnabled and (State.autoBatToggled or State.tpBatEnabled) then
        State._hitboxFollower.pausedByBatAim = State.autoBatToggled == true
        State._hitboxFollower.stop()
    end
end)

local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1
local h, hrp, speedLbl
local setAutoGrab, setAutoBat, setInfJump, setAntiRag, setFps, setUnwalkToggle, autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual, setIntroToggle, setNoIntroToggle
local setAntiLag, setStretchRez, setRemoveAccessories, setDarkMode, setSkyStyle, setSkySelectorVisual
local setMedusaCounter, setMedusaReset, setBatCounter, setInstaGrab, setAutoSwingVisual
local startAntiRagdoll, stopAntiRagdoll, applyFPSBoost, startAutoSteal, stopAutoSteal
local mobileSpeedSetActive, mobileLaggerSetActive, mobileLaggerCarrySetActive, saveConfig, loadConfig = nil, nil, nil, nil, nil
State._configLoading = false
State._configLoaded = false
State._saveAfterLoad = false
State._saveRequestId = 0
State._lastSaveError = nil
State._configDirty = false
State._positionDirty = false

State._resolveFileFunction = function(name)
    local direct = nil
    if name == "writefile" then direct = writefile
    elseif name == "readfile" then direct = readfile
    elseif name == "isfile" then direct = isfile
    elseif name == "delfile" then direct = delfile
    elseif name == "makefolder" then direct = makefolder
    elseif name == "isfolder" then direct = isfolder end
    if type(direct) == "function" then return direct end
    local environments = {}
    pcall(function()
        if getgenv then table.insert(environments, getgenv()) end
    end)
    pcall(function()
        if getrenv then table.insert(environments, getrenv()) end
    end)
    table.insert(environments, _G)
    for _, environment in ipairs(environments) do
        if type(environment) == "table" then
            local candidate = rawget(environment, name)
            if type(candidate) == "function" then return candidate end
            local synEnvironment = rawget(environment, "syn")
            if type(synEnvironment) == "table" then
                local synCandidate = rawget(synEnvironment, name)
                if type(synCandidate) == "function" then return synCandidate end
            end
        end
    end
    if type(syn) == "table" and type(syn[name]) == "function" then
        return syn[name]
    end
    return nil
end

State._safeWriteFile = function(path, data)
    local writer = State._resolveFileFunction("writefile")
    if type(writer) ~= "function" then
        return false, "writefile no disponible en este ejecutor"
    end
    local ok, err = pcall(writer, path, data)
    if not ok then return false, tostring(err) end
    return true
end

State._safeReadFile = function(path)
    local reader = State._resolveFileFunction("readfile")
    if type(reader) ~= "function" then
        return nil, "readfile no disponible en este ejecutor"
    end
    local ok, result = pcall(reader, path)
    if not ok or type(result) ~= "string" or result == "" then
        return nil, ok and "archivo vacío" or tostring(result)
    end
    return result
end

State._safeDeleteFile = function(path)
    local deleter = State._resolveFileFunction("delfile")
    if type(deleter) ~= "function" then return false end
    local ok = pcall(deleter, path)
    return ok
end

State._readValidJsonFile = function(path)
    local raw = State._safeReadFile(path)
    if type(raw) ~= "string" then return nil, nil end
    local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(decoded) ~= "table" then return nil, raw end
    return decoded, raw
end

State._writeVerifiedJson = function(path, encoded)
    local writeOk, writeErr = State._safeWriteFile(path, encoded)
    if not writeOk then return false, writeErr end
    local decoded, raw = State._readValidJsonFile(path)
    if type(decoded) ~= "table" or raw ~= encoded then
        return false, "la verificación del archivo falló: " .. tostring(path)
    end
    return true
end

State._atomicJsonSave = function(mainPath, backupPath, tempPath, encoded)
    local jsonOk, decoded = pcall(function() return HttpService:JSONDecode(encoded) end)
    if not jsonOk or type(decoded) ~= "table" then
        return false, "JSON inválido antes de guardar"
    end
    local currentData, currentRaw = State._readValidJsonFile(mainPath)
    if type(currentData) == "table" and currentRaw == encoded then
        return true
    end
    if type(currentData) == "table" and type(currentRaw) == "string" then
        local backupOk, backupErr = State._safeWriteFile(backupPath, currentRaw)
        if not backupOk then return false, backupErr end
    end
    local tempOk, tempErr = State._safeWriteFile(tempPath, encoded)
    if not tempOk then return false, tempErr end
    local mainOk, mainErr = State._safeWriteFile(mainPath, encoded)
    if not mainOk then return false, mainErr end
    if type(currentData) ~= "table" then State._safeWriteFile(backupPath, encoded) end
    return true
end

State.requestConfigSave = function()
    if State._configLoading or not State._configLoaded then
        State._saveAfterLoad = true
        State._configDirty = true
        return
    end
    if State._configLoadFailed then
        return
    end
    State._configDirty = true
    State._saveRequestId = State._saveRequestId + 1
    local requestId = State._saveRequestId
    task.delay(1.75, function()
        if requestId ~= State._saveRequestId or State._configLoading then return end
        if not State._configDirty then return end
        if saveConfig then
            local ok, result = pcall(saveConfig)
            if not ok then State._lastSaveError = tostring(result) end
        end
    end)
end

local normalBox, carryBox, laggerBox, laggerBox2, durValBtn, uiScaleBox
local modeValLbl, progressFill, progressPct, progressRadLbl
local radValBtn
local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local autoTPDownEnabled, autoTPDownConn, autoTPDownHeight = false, nil, 20
local startBatAimbotV2, stopBatAimbotV2
local _autoBatLastScan = 0
local _autoBatTarget = nil
local _autoBatEquippedThisRun = false
local autoBatV2SetVisual, setAutoBatV2, setHideButtonsVisual, setAutoTPDownVisual
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local btnInstaReset = nil
State.buttonsSizeValue = State.buttonsSizeValue or 50
State.buttonsShape = State.buttonsShape or "Normal"

function getMobileButtonPixels(value)
    value = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
    return math.floor(36 + (value * 0.48) + 0.5)
end

function normalizeMobileButtonsShape(shape)
    shape = tostring(shape or "Normal")
    if shape == "Circle" or shape == "Normal" or shape == "Square" or shape == "Rectangle" then
        return shape
    end
    return "Normal"
end

function applyShapeToMobileButton(button)
    if not button or not button.Parent then return end
    local pixels = getMobileButtonPixels(State.buttonsSizeValue)
    local textPixels = math.clamp(math.floor(8 + State.buttonsSizeValue * 0.07 + 0.5), 8, 15)
    local shape = normalizeMobileButtonsShape(State.buttonsShape)
    local width, height = pixels, pixels
    local radius = UDim.new(0, math.clamp(math.floor(pixels * 0.30 + 0.5), 8, math.floor(pixels / 2)))
    if shape == "Circle" then
        radius = UDim.new(1, 0)
    elseif shape == "Square" then
        radius = UDim.new(0, 0)
    elseif shape == "Rectangle" then
        width = math.floor(pixels * 1.55 + 0.5)
        height = math.max(28, math.floor(pixels * 0.75 + 0.5))
        radius = UDim.new(0, math.max(5, math.floor(height * 0.18 + 0.5)))
    end
    button.Size = UDim2.new(0, width, 0, height)
    button.TextSize = textPixels
    local corner = button:FindFirstChild("ButtonShapeCorner")
    if not corner or not corner:IsA("UICorner") then corner = button:FindFirstChildOfClass("UICorner") end
    if not corner then
        corner = Instance.new("UICorner")
        corner.Parent = button
    end
    corner.Name = "ButtonShapeCorner"
    corner.CornerRadius = radius
end

function applyMobileButtonsShape(shape)
    State.buttonsShape = normalizeMobileButtonsShape(shape)
    for _, mobileBtn in pairs(mobileButtonsByName) do applyShapeToMobileButton(mobileBtn) end
    for _, specialBtn in ipairs({btnBatV2, btnInstaReset}) do applyShapeToMobileButton(specialBtn) end
    return State.buttonsShape
end

function applyMobileButtonsSize(value)
    State.buttonsSizeValue = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
    applyMobileButtonsShape(State.buttonsShape)
end

local MedusaConfig = {
    Enabled = false,
    Radius = 15,
    Delay = 0.15,
    LastUsed = 0,
    RadiusPart = nil
}

local SAFETY_VOID_MARGIN = 18
local SAFETY_MAX_FLOOR_RAY = 4000
local safetyLastGroundedCFrame = nil
local safetyRestoring = false

local function safetyVoidY()
    local ok, value = pcall(function() return workspace.FallenPartsDestroyHeight end)
    if ok and type(value) == "number" then return value end
    return -500
end

local function safetyFiniteNumber(value)
    return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

safetyPositionIsValid = function(position)
    return typeof(position) == "Vector3"
        and safetyFiniteNumber(position.X)
        and safetyFiniteNumber(position.Y)
        and safetyFiniteNumber(position.Z)
        and position.Y > safetyVoidY() + SAFETY_VOID_MARGIN
end

local function safetyCharacterParts()
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not character or not humanoid or humanoid.Health <= 0 or not root then
        return nil, nil, nil
    end
    return character, humanoid, root
end

local function safetyFloorPosition(root, character)
    if not root or not character or not safetyPositionIsValid(root.Position) then return nil end
    local ignore = {character}
    if MedusaConfig and MedusaConfig.RadiusPart then table.insert(ignore, MedusaConfig.RadiusPart) end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local offset = (humanoid and humanoid.HipHeight or 2) + (root.Size.Y / 2) + 0.05
    local origin = root.Position + Vector3.new(0, 5, 0)
    local distanceToVoid = math.max(100, origin.Y - safetyVoidY() + 50)
    local rayDistance = math.min(SAFETY_MAX_FLOOR_RAY, distanceToVoid)
    local hitPosition = nil
    pcall(function()
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = ignore
        params.FilterType = Enum.RaycastFilterType.Exclude
        pcall(function() params.RespectCanCollide = true end)
        local result = workspace:Raycast(origin, Vector3.new(0, -rayDistance, 0), params)
        if result and result.Instance and result.Position then
            hitPosition = result.Position
        end
    end)
    if not hitPosition then
        pcall(function()
            local ray = Ray.new(origin, Vector3.new(0, -rayDistance, 0))
            local part, position = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
            if part and position then hitPosition = position end
        end)
    end
    if not hitPosition then return nil end
    local landing = Vector3.new(root.Position.X, hitPosition.Y + offset, root.Position.Z)
    if not safetyPositionIsValid(landing) then return nil end
    return landing
end

local function safetyTeleport(root, humanoid, destination, preserveYaw)
    if not root or not root.Parent or not humanoid or humanoid.Health <= 0 then return false end
    if not safetyPositionIsValid(destination) then return false end
    local yaw = 0
    if preserveYaw ~= false then
        local _, currentYaw, _ = root.CFrame:ToOrientation()
        yaw = currentYaw
    end
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = CFrame.new(destination) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    pcall(function() humanoid.PlatformStand = false end)
    return true
end

local function safetyTeleportToFloor(character, humanoid, root)
    local landing = safetyFloorPosition(root, character)
    if not landing then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        return false
    end
    return safetyTeleport(root, humanoid, landing, true)
end

RunService.Heartbeat:Connect(function()
    local _now = os.clock()
    if _now - (State._safetyLastCheck or 0) < 0.1 then return end
    State._safetyLastCheck = _now
    local character, humanoid, root = safetyCharacterParts()
    if not character then return end
    if safetyPositionIsValid(root.Position)
        and humanoid.FloorMaterial ~= Enum.Material.Air
        and root.AssemblyLinearVelocity.Magnitude < 180 then
        safetyLastGroundedCFrame = root.CFrame
    end
    local riskyMovement = State.dropActive
        or State.dropBrainrotActive
        or autoTPDownEnabled
        or State.tpBatEnabled
        or State.autoBatToggled
        or State.autoBatV2Enabled
    if riskyMovement and not safetyPositionIsValid(root.Position) and not safetyRestoring then
        safetyRestoring = true
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if safetyLastGroundedCFrame and safetyPositionIsValid(safetyLastGroundedCFrame.Position) then
            root.CFrame = safetyLastGroundedCFrame + Vector3.new(0, 2, 0)
        end
        task.defer(function() safetyRestoring = false end)
    end
end)

local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

local function startAutoLeft()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp2 = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp2 or not hum then return end
        local spd = State.getAutoPathSpeed()
        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, hrp2.Position.Y, AP.L1.Z)
            if (tgt - hrp2.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - hrp2.Position
                local mv = Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false)
                hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
                return
            end
            local d = AP.L1 - hrp2.Position
            local mv = Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false)
            hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, hrp2.Position.Y, AP.L2.Z)
            if (tgt - hrp2.Position).Magnitude < 1 then
                hum:Move(Vector3.zero,false)
                hrp2.AssemblyLinearVelocity = Vector3.zero
                State.autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if (AP.L_FACE - hrp2.Position).Magnitude > 0.01 then
                    hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.L_FACE.X, hrp2.Position.Y, AP.L_FACE.Z))
                end
                return
            end
            local d = AP.L2 - hrp2.Position
            local mv = Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false)
            hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
        end
    end)
end

local function startAutoRight()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp2 = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp2 or not hum then return end
        local spd = State.getAutoPathSpeed()
        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, hrp2.Position.Y, AP.R1.Z)
            if (tgt - hrp2.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - hrp2.Position
                local mv = Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false)
                hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
                return
            end
            local d = AP.R1 - hrp2.Position
            local mv = Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false)
            hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, hrp2.Position.Y, AP.R2.Z)
            if (tgt - hrp2.Position).Magnitude < 1 then
                hum:Move(Vector3.zero,false)
                hrp2.AssemblyLinearVelocity = Vector3.zero
                State.autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if (AP.R_FACE - hrp2.Position).Magnitude > 0.01 then
                    hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.R_FACE.X, hrp2.Position.Y, AP.R_FACE.Z))
                end
                return
            end
            local d = AP.R2 - hrp2.Position
            local mv = Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false)
            hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
        end
    end)
end

local DROP_ASCEND_DURATION = 0.25
local DROP_ASCEND_SPEED = 240

local function runDrop()
    if State.dropActive then return end
    local char, hum, root = safetyCharacterParts()
    if not char then return end
    State.dropActive = true
    local t0 = tick()
    local dc
    dc = RunService.Heartbeat:Connect(function()
        local currentChar = LP.Character
        local r = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
        if not r or not currentHum or currentHum.Health <= 0 then
            if dc then dc:Disconnect() end
            State.dropActive = false
            return
        end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            if dc then dc:Disconnect() end
            r.AssemblyLinearVelocity = Vector3.zero
            r.AssemblyAngularVelocity = Vector3.zero
            safetyTeleportToFloor(currentChar, currentHum, r)
            State.dropActive = false
            return
        end
        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
    end)
end

local _tpDownActive = false

local function runTPDown()
    if _tpDownActive then return end
    _tpDownActive = true
    pcall(function()
        local character, humanoid, root = safetyCharacterParts()
        if character then safetyTeleportToFloor(character, humanoid, root) end
    end)
    _tpDownActive = false
end

State._tpBatHittingCooldown = false
State._tpBatHRP = nil
State._tpBatH = nil

State._tpBatGetTool = function()
    local char = LP.Character
    if not char then return nil end
    local bat = char:FindFirstChild("Bat")
    if bat then return bat end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        bat = backpack:FindFirstChild("Bat")
        if bat then
            bat.Parent = char
            return bat
        end
    end
    return nil
end

State._tpBatTryHit = function()
    if State._tpBatHittingCooldown then return end
    State._tpBatHittingCooldown = true
    pcall(function()
        local bat = State._tpBatGetTool()
        if bat then
            bat:Activate()
            local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remoteEvent then remoteEvent:FireServer() end
            local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")
            if remoteFunction then
                pcall(function()
                    remoteFunction:InvokeServer()
                end)
            end
        end
    end)
    task.delay(0.08, function()
        State._tpBatHittingCooldown = false
    end)
end

State._tpBatClosest = function()
    if not State._tpBatHRP then return nil, math.huge end
    local closest, closestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (State._tpBatHRP.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closest = player
                end
            end
        end
    end
    return closest, closestDistance
end

RunService.Heartbeat:Connect(function()
    if not State.tpBatEnabled or State.tpBatVersion ~= 1 then return end
    if not State._tpBatH or not State._tpBatHRP
        or not State._tpBatH.Parent or not State._tpBatHRP.Parent then
        local char = LP.Character
        if char then
            State._tpBatH = char:FindFirstChildOfClass("Humanoid")
            State._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
        end
        if not State._tpBatH or not State._tpBatHRP then return end
    end
    local target = State._tpBatClosest()
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(State._tpBatHRP, "PhysicsRepRootPart", targetRoot)
                end)
            end
            local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
            if (State._tpBatHRP.Position - targetPosition).Magnitude > 5 then
                State._tpBatHRP.CFrame = CFrame.new(targetPosition)
            end
            local camera = workspace.CurrentCamera
            if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position) end
            State._tpBatTryHit()
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not State.tpBatEnabled or State.tpBatVersion ~= 1 then return end
    if not State._tpBatH or not State._tpBatHRP then return end
    if not State._tpBatH.Parent or not State._tpBatHRP.Parent then return end
    local target = State._tpBatClosest()
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local camera = workspace.CurrentCamera
            if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position) end
            State._tpBatTryHit()
        end
    end
end)

State._tpBatV2HittingCooldown = false

State._tpBatV2GetTool = function()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        tool = backpack:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

State._tpBatV2TryHit = function()
    if State._tpBatV2HittingCooldown then return end
    State._tpBatV2HittingCooldown = true
    pcall(function()
        local bat = State._tpBatV2GetTool()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function()
        State._tpBatV2HittingCooldown = false
    end)
end

RunService.Heartbeat:Connect(function()
    if not State.tpBatEnabled or State.tpBatVersion ~= 2 then return end
    if not State._tpBatH or not State._tpBatHRP
        or not State._tpBatH.Parent or not State._tpBatHRP.Parent then
        local char = LP.Character
        if char then
            State._tpBatH = char:FindFirstChildOfClass("Humanoid")
            State._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
        end
        if not State._tpBatH or not State._tpBatHRP then return end
    end
    local target = State._tpBatClosest()
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(State._tpBatHRP, "PhysicsRepRootPart", targetRoot)
                end)
            end
            local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
            if (State._tpBatHRP.Position - targetPosition).Magnitude > 8 then
                State._tpBatHRP.CFrame = CFrame.new(targetPosition)
            end
            local camera = workspace.CurrentCamera
            if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position) end
            State._tpBatV2TryHit()
        end
    end
end)

LP.CharacterAdded:Connect(function(character)
    task.wait(0.2)
    State._tpBatH = character:FindFirstChildOfClass("Humanoid")
    State._tpBatHRP = character:FindFirstChild("HumanoidRootPart")
end)

if LP.Character then
    task.spawn(function()
        task.wait(0.2)
        State._tpBatH = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        State._tpBatHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    end)
end

local function startAutoTPDown()
    if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
    autoTPDownConn = task.spawn(function()
        while autoTPDownEnabled do
            task.wait(0.1)
            pcall(function()
                local char = LP.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                if hum.FloorMaterial ~= Enum.Material.Air then return end
                if root.Position.Y < autoTPDownHeight then return end
                safetyTeleportToFloor(char, hum, root)
            end)
        end
    end)
end

local function stopAutoTPDown()
    autoTPDownEnabled = false
    if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
end

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
            if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then
                cursedResetRemote=self
            end
            return oldFire(self,...)
        end))
    end
end)

task.spawn(function()
    task.wait(2)
    if cursedResetRemote then return end
    for _,desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then
            cursedResetRemote=desc
            break
        end
    end
end)

local function normalReset()
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        humanoid.Health = 0
    end
end

for _, name in pairs({"PHANTOMDUELSGUI"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    local moved = false
    frame.Active = true
    local function finishDrag()
        if not dragging then return end
        dragging = false
        dragInput = nil
        if moved then
            moved = false
            if State.requestPositionSave then State.requestPositionSave() end
            if State.requestConfigSave then State.requestConfigSave() end
        end
    end
    frame.InputBegan:Connect(function(inp)
        if uiLocked then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragInput = inp.UserInputType == Enum.UserInputType.Touch and inp or nil
            dragStart = inp.Position
            startPos = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then finishDrag() end
            end)
        end
    end)
    frame.InputChanged:Connect(function(inp)
        if uiLocked then finishDrag(); return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if uiLocked then finishDrag(); return end
        if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = inp.Position - dragStart
            if math.abs(d.X) > 1 or math.abs(d.Y) > 1 then moved = true end
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then finishDrag() end
    end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "PHANTOMDUELSGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then gui.Parent = LP:WaitForChild("PlayerGui") end

local _C={
    [1]=Color3.fromRGB(255, 255, 255),
    [2]=Color3.fromRGB(245, 240, 255),
    [3]=Color3.fromRGB(248, 245, 255),
    [4]=Color3.fromRGB(235, 225, 255),
    [5]=Color3.fromRGB(200, 170, 240),
    [6]=Color3.fromRGB(180, 150, 230),
    [7]=Color3.fromRGB(160, 100, 220),
    [8]=Color3.fromRGB(140, 80, 200),
    [9]=Color3.fromRGB(230, 220, 255),
    [10]=Color3.fromRGB(240, 235, 255),
}

local BG=_C[1]
local SIDEBAR_BG=_C[2]
local CARD_BG=_C[3]
local CARD_HOV=_C[4]
local BORDER=_C[5]
local BORDER2=_C[6]
local WHITE=_C[7]
local DIM=_C[8]
local DIM2=_C[9]
local KB_BG=_C[10]
local INPUT_BG=_C[10]

local W, H, SW = 356, 536, 112
local CORNER = 14
local uiScaleValue = 80
local mainUIScale = nil
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 70, 0, 12)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Visible = false
main.BackgroundTransparency = 0
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, CORNER)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = BORDER
mainStroke.Thickness = 1
mainStroke.Transparency = 0.25
local premiumInnerBorder = Instance.new("Frame", main)
premiumInnerBorder.Name = "PremiumInnerBorder"
premiumInnerBorder.Size = UDim2.new(1, -8, 1, -8)
premiumInnerBorder.Position = UDim2.new(0, 4, 0, 4)
premiumInnerBorder.BackgroundTransparency = 1
premiumInnerBorder.BorderSizePixel = 0
premiumInnerBorder.ZIndex = 2
local premiumInnerCorner = Instance.new("UICorner", premiumInnerBorder)
premiumInnerCorner.CornerRadius = UDim.new(0, math.max(CORNER - 4, 0))
local premiumInnerStroke = Instance.new("UIStroke", premiumInnerBorder)
premiumInnerStroke.Color = Color3.fromRGB(200, 170, 240)
premiumInnerStroke.Thickness = 1
premiumInnerStroke.Transparency = 0.65
mainUIScale = Instance.new("UIScale", main)
mainUIScale.Scale = 0.80
local fullUIBackground = Instance.new("ImageLabel", main)
fullUIBackground.Name = "FullUIBackground"
fullUIBackground.Size = UDim2.new(1, -2, 1, -2)
fullUIBackground.Position = UDim2.new(0, 1, 0, 1)
fullUIBackground.BackgroundTransparency = 1
fullUIBackground.BorderSizePixel = 0
fullUIBackground.Image = "rbxassetid://" .. CUSTOM_BG_ID
fullUIBackground.ImageTransparency = 0.12
fullUIBackground.ScaleType = Enum.ScaleType.Crop
fullUIBackground.ZIndex = 1
local fullUIBackgroundCorner = Instance.new("UICorner", fullUIBackground)
fullUIBackgroundCorner.CornerRadius = UDim.new(0, math.max(CORNER - 1, 0))

State.applyBackgroundImage = function(assetId, shouldSave)
    assetId = tostring(assetId or "")
    local valid = false
    for _, id in ipairs(State.backgroundAssetIds) do
        if id == assetId then valid = true; break end
    end
    if not valid then assetId = State.backgroundAssetIds[1] end
    State.backgroundAssetId = assetId
    if fullUIBackground and fullUIBackground.Parent then
        fullUIBackground.Image = "rbxassetid://" .. assetId
    end
    for id, visual in pairs(State.imageChoiceVisuals) do
        local selected = id == assetId
        if visual.stroke then
            visual.stroke.Color = selected and WHITE or BORDER
            visual.stroke.Thickness = selected and 2.2 or 1
        end
        if visual.badge then
            visual.badge.Text = selected and ("✓ " .. tostring(visual.index)) or tostring(visual.index)
            visual.badge.BackgroundColor3 = selected and WHITE or Color3.fromRGB(200, 180, 230)
            visual.badge.TextColor3 = selected and BG or WHITE
        end
    end
    if shouldSave and State.requestConfigSave then State.requestConfigSave() end
end

local topbar = Instance.new("Frame", main)
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = SIDEBAR_BG
topbar.BackgroundTransparency = 1
topbar.BorderSizePixel = 0
topbar.ZIndex = 10
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, CORNER)
local topPatch = Instance.new("Frame", topbar)
topPatch.Size = UDim2.new(1, 0, 0, CORNER)
topPatch.Position = UDim2.new(0, 0, 1, -CORNER)
topPatch.BackgroundColor3 = SIDEBAR_BG
topPatch.BackgroundTransparency = 1
topPatch.BorderSizePixel = 0
topPatch.ZIndex = 9
local topDiv = Instance.new("Frame", topbar)
topDiv.Size = UDim2.new(1, 0, 0, 1)
topDiv.Position = UDim2.new(0, 0, 1, -1)
topDiv.BackgroundColor3 = BORDER
topDiv.BorderSizePixel = 0
topDiv.BackgroundTransparency = 0.55
topDiv.ZIndex = 11
local premiumTopLine = Instance.new("Frame", topbar)
premiumTopLine.Name = "PremiumTopLine"
premiumTopLine.Size = UDim2.new(1, -28, 0, 2)
premiumTopLine.Position = UDim2.new(0, 14, 0, 3)
premiumTopLine.BackgroundColor3 = WHITE
premiumTopLine.BorderSizePixel = 0
premiumTopLine.ZIndex = 14
local premiumTopCorner = Instance.new("UICorner", premiumTopLine)
premiumTopCorner.CornerRadius = UDim.new(1, 0)
local premiumTopGradient = Instance.new("UIGradient", premiumTopLine)
premiumTopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 100, 220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 220)),
})
premiumTopGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.55)
})
local titleLbl = Instance.new("TextLabel", topbar)
titleLbl.Size = UDim2.new(0, 190, 1, 0)
titleLbl.Position = UDim2.new(0, 17, 0, -3)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = " 👻 Phantom Duels"
titleLbl.TextColor3 = WHITE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 14
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12
local verLbl = Instance.new("TextLabel", topbar)
verLbl.Size = UDim2.new(0, 240, 0, 14)
verLbl.Position = UDim2.new(0, 18, 0, 28)
verLbl.BackgroundTransparency = 1
verLbl.Text = "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤPhantom Duels  ·  v2"
verLbl.TextColor3 = DIM
verLbl.Font = Enum.Font.Gotham
verLbl.TextSize = 8
verLbl.TextXAlignment = Enum.TextXAlignment.Left
verLbl.ZIndex = 12
local minBtn = Instance.new("TextButton", topbar)
minBtn.AutoButtonColor = false
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -36, 0.5, -13)
minBtn.BackgroundColor3 = KB_BG
minBtn.BorderSizePixel = 0
minBtn.Text = "-"
minBtn.TextColor3 = DIM
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.ZIndex = 13
minBtn.BackgroundTransparency = 0.8
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", minBtn).Color = BORDER
minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)

do
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil
    local moved = false
    local dragZone = Instance.new("TextButton", topbar)
    dragZone.Name = "TopbarDragZone"
    dragZone.Size = UDim2.new(1, -48, 1, 0)
    dragZone.Position = UDim2.new(0, 0, 0, 0)
    dragZone.BackgroundTransparency = 1
    dragZone.BorderSizePixel = 0
    dragZone.Text = ""
    dragZone.AutoButtonColor = false
    dragZone.Active = true
    dragZone.ZIndex = 13
    local function finishDrag()
        if not dragging then return end
        dragging = false
        dragInput = nil
        if moved then
            moved = false
            if State.requestPositionSave then State.requestPositionSave() end
            if State.requestConfigSave then State.requestConfigSave() end
        end
    end
    dragZone.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        moved = false
        dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then finishDrag() end
        end)
    end)
    dragZone.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if uiLocked then finishDrag(); return end
        if not dragging then return end
        if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 1 or math.abs(delta.Y) > 1 then moved = true end
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end)
    UIS.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch) then
            finishDrag()
        end
    end)
end

local TAB_BAR_H = 0
local TAB_BAR_Y = 48
local sidebar = Instance.new("Frame", main)
sidebar.Name = "TabBar"
sidebar.Size = UDim2.new(1, 0, 0, TAB_BAR_H)
sidebar.Position = UDim2.new(0, 0, 0, TAB_BAR_Y)
sidebar.BackgroundColor3 = SIDEBAR_BG
sidebar.BackgroundTransparency = 1
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 6
sidebar.ClipsDescendants = true
sidebar.Visible = false
do local _sd=Instance.new("Frame",main); _sd.Size=UDim2.new(1,0,0,1); _sd.Position=UDim2.new(0,0,0,TAB_BAR_Y+TAB_BAR_H); _sd.BackgroundColor3=BORDER; _sd.BackgroundTransparency=0.55; _sd.BorderSizePixel=0; _sd.ZIndex=7; _sd.Visible=false end
local content = Instance.new("Frame", main)
content.Name = "ContentArea"
content.Size = UDim2.new(1, 0, 1, -(TAB_BAR_Y + TAB_BAR_H + 2 + CORNER))
content.Position = UDim2.new(0, 0, 0, TAB_BAR_Y + TAB_BAR_H + 2)
content.BackgroundColor3 = BG
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.ZIndex = 100

local mini = Instance.new("TextButton", gui)
mini.AutoButtonColor = false
mini.Name = "PHANTOMDUELSMini"
mini.Size = UDim2.new(0, 120, 0, 34)
mini.Position = UDim2.new(0, 20, 0, 70)
mini.BackgroundColor3 = BG
mini.BorderSizePixel = 0
mini.Text = " 👻 Phantom"
mini.TextColor3 = WHITE
mini.Font = Enum.Font.GothamBold
mini.TextSize = 11
mini.TextXAlignment = Enum.TextXAlignment.Center
mini.ZIndex = 20
mini.Visible = true
mini.BackgroundTransparency = 0
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 8)
local miniStroke = Instance.new("UIStroke", mini)
miniStroke.Color = BORDER
miniStroke.Thickness = 1
makeDraggable(mini)
mini.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        if State.requestConfigSave then State.requestConfigSave() end
    end
end)

local function showGui()
    main.Visible = true
    mini.Visible = false
    State.guiVisible = true
    main.BackgroundTransparency = 0
    mainUIScale.Scale = 0.85
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    TweenService:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = uiScaleValue / 100}):Play()
end

local function hideGui()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.85}):Play()
    task.delay(0.2, function()
        main.Visible = false
        mini.Visible = true
        State.guiVisible = false
    end)
end

minBtn.MouseButton1Click:Connect(hideGui)
mini.MouseButton1Click:Connect(showGui)
mini.MouseEnter:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=CARD_HOV}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=BG}):Play() end)

local tabs = {}
local tabPages = {}
local activeTabName = nil

local tabDefs = {
    {name="Speed"},
    {name="Bat Aimbot"},
    {name="Mechanics"},
    {name="Movement"},
    {name="Performance"},
    {name="Settings"},
}

local switchTab
local pageLOs = {}

local masterPage = Instance.new("ScrollingFrame", content)
masterPage.Name = "AllOptions"
masterPage.Size = UDim2.new(1, 0, 1, 0)
masterPage.BackgroundTransparency = 1
masterPage.BorderSizePixel = 0
masterPage.ScrollBarThickness = 0
masterPage.ScrollBarImageColor3 = BORDER
masterPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
masterPage.CanvasSize = UDim2.new(0, 0, 0, 0)
masterPage.ZIndex = 3
local mLL = Instance.new("UIListLayout", masterPage)
mLL.SortOrder = Enum.SortOrder.LayoutOrder
mLL.Padding = UDim.new(0, 7)
local mPad = Instance.new("UIPadding", masterPage)
mPad.PaddingLeft = UDim.new(0, 13)
mPad.PaddingRight = UDim.new(0, 13)
mPad.PaddingTop = UDim.new(0, 12)
mPad.PaddingBottom = UDim.new(0, 12)
switchTab = function(name) activeTabName = name end

for i, td in ipairs(tabDefs) do
    local page = Instance.new("Frame", masterPage)
    page.Name = td.name
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.LayoutOrder = i
    page.ZIndex = 3
    local pll = Instance.new("UIListLayout", page)
    pll.SortOrder = Enum.SortOrder.LayoutOrder
    pll.Padding = UDim.new(0, 7)
    tabs[td.name] = {frame=page}
    tabPages[td.name] = page
    pageLOs[td.name] = 0
end

local function lo(tabName) pageLOs[tabName] = pageLOs[tabName] + 1; return pageLOs[tabName] end
local function pg(tabName) return tabPages[tabName] end

local function makeSecHeader(tabName, text)
    local f = Instance.new("Frame", pg(tabName))
    f.Size = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.LayoutOrder = lo(tabName)
    f.ZIndex = 4
    local accent = Instance.new("Frame", f)
    accent.Size = UDim2.new(0, 3, 0, 12)
    accent.Position = UDim2.new(0, 0, 0.5, -6)
    accent.BackgroundColor3 = WHITE
    accent.BorderSizePixel = 0
    accent.ZIndex = 5
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -12, 0, 16)
    t.Position = UDim2.new(0, 9, 0, 1)
    t.BackgroundTransparency = 1
    t.Text = text:upper()
    t.TextColor3 = WHITE
    t.Font = Enum.Font.GothamBold
    t.TextSize = 8
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextWrapped = false
    t.TextTruncate = Enum.TextTruncate.AtEnd
    t.ZIndex = 5
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, -9, 0, 1)
    line.Position = UDim2.new(0, 9, 1, -2)
    line.BackgroundColor3 = BORDER
    line.BackgroundTransparency = 0.25
    line.BorderSizePixel = 0
    line.ZIndex = 4
end

local _unwalkSavedAnimate = nil

local function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
    local anim = c:FindFirstChild("Animate")
    if anim then _unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end

local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif _unwalkSavedAnimate then _unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    _unwalkSavedAnimate = nil
end

local function baseCard(tabName, h2)
    local c = Instance.new("Frame", pg(tabName))
    c.Size = UDim2.new(1, 0, 0, h2 or 38)
    c.BackgroundColor3 = CARD_BG
    c.BackgroundTransparency = OPTION_TRANSPARENCY
    c.BorderSizePixel = 0
    c.LayoutOrder = lo(tabName)
    c.ZIndex = 4
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 12)
    local cSt = Instance.new("UIStroke", c)
    cSt.Color = BORDER
    cSt.Thickness = 1
    cSt.Transparency = 0.18
    local sideAccent = Instance.new("Frame", c)
    sideAccent.Name = "VisualAccent"
    sideAccent.Size = UDim2.new(0, 2, 0.54, 0)
    sideAccent.Position = UDim2.new(0, 1, 0.23, 0)
    sideAccent.BackgroundColor3 = BORDER
    sideAccent.BackgroundTransparency = 0.2
    sideAccent.BorderSizePixel = 0
    sideAccent.ZIndex = 5
    Instance.new("UICorner", sideAccent).CornerRadius = UDim.new(1, 0)
    local bottomDetail = Instance.new("Frame", c)
    bottomDetail.Name = "BottomDetail"
    bottomDetail.Size = UDim2.new(1, -24, 0, 1)
    bottomDetail.Position = UDim2.new(0, 12, 1, -1)
    bottomDetail.BackgroundColor3 = Color3.fromRGB(200, 170, 240)
    bottomDetail.BackgroundTransparency = 0.58
    bottomDetail.BorderSizePixel = 0
    bottomDetail.ZIndex = 5
    c.MouseEnter:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
    c.MouseLeave:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
    return c
end

local function cLabel(p, text, x, w, sz, col, font, xa)
    local l = Instance.new("TextLabel", p)
    l.Size = UDim2.new(0, w or 140, 1, 0)
    l.Position = UDim2.new(0, x or 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = col or WHITE
    l.Font = font or Enum.Font.GothamBold
    l.TextSize = sz or 11
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.ZIndex = 10
    return l
end

local function makePillToggle(parent, defOn, onToggle)
    local PW, PH = 36, 19
    local pbg = Instance.new("Frame", parent)
    pbg.Size = UDim2.new(0, PW, 0, PH)
    pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
    pbg.BackgroundColor3 = defOn and WHITE or DIM2
    pbg.BorderSizePixel = 0
    pbg.ZIndex = 8
    Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
    local ps = Instance.new("UIStroke", pbg)
    ps.Color = defOn and WHITE or BORDER2
    ps.Thickness = 1
    local dot = Instance.new("Frame", pbg)
    dot.Size = UDim2.new(0, 13, 0, 13)
    dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    dot.BackgroundColor3 = defOn and BG or BORDER
    dot.BorderSizePixel = 0
    dot.ZIndex = 9
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local isOn = defOn or false
    local function setV(on)
        isOn = on
        TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
        TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
        TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
            BackgroundColor3 = on and BG or BORDER
        }):Play()
    end
    local clk = Instance.new("TextButton", parent)
    clk.AutoButtonColor = false
    clk.Size = UDim2.new(1, 0, 1, 0)
    clk.BackgroundTransparency = 1
    clk.Text = ""
    clk.ZIndex = 6
    clk.MouseButton1Click:Connect(function()
        if _anyKeyListening then return end
        isOn = not isOn
        setV(isOn)
        if onToggle then pcall(onToggle, isOn) end
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    return setV
end

local function makeKB(parent, kbEntry, onChange)
    local b = Instance.new("TextButton", parent)
    b.AutoButtonColor = false
    b.Size = UDim2.new(0, 44, 0, 20)
    b.BackgroundColor3 = KB_BG
    b.BackgroundTransparency = INPUT_TRANSPARENCY
    b.BorderSizePixel = 0
    local function getDisplayText()
        if kbEntry.gp then return "GP:"..kbEntry.gp.Name
        elseif kbEntry.kb then return kbEntry.kb.Name
        else return "None" end
    end
    b.Text = getDisplayText()
    State._bindButtons = State._bindButtons or {}
    State._bindButtons[kbEntry] = b
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 8
    b.ZIndex = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local bs = Instance.new("UIStroke", b)
    bs.Color = BORDER
    bs.Thickness = 1
    local li = false
    local lc
    local pv = b.Text
    b.MouseButton1Click:Connect(function()
        if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; b.Text=pv; b.TextColor3=WHITE; return end
        pv=b.Text
        li=true
        _anyKeyListening=true
        b.Text="···"
        b.TextColor3=DIM
        TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play()
        lc = UIS.InputBegan:Connect(function(inp)
            if not li then return end
            local isKb = inp.UserInputType == Enum.UserInputType.Keyboard
            local isGp = string.sub(inp.UserInputType.Name, 1, 7) == "Gamepad"
            if not isKb and not isGp then return end
            if inp.KeyCode == Enum.KeyCode.Escape then
                li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
                b.Text=pv; b.TextColor3=WHITE; TweenService:Create(bs,TweenInfo.new(0.1),{Color=BORDER}):Play(); return
            end
            if isGp then
                kbEntry.gp = inp.KeyCode
                kbEntry.kb = nil
                b.Text = "GP:"..inp.KeyCode.Name
                pv = b.Text
            else
                kbEntry.kb = inp.KeyCode
                kbEntry.gp = nil
                b.Text = inp.KeyCode.Name
                pv = b.Text
            end
            b.TextColor3=WHITE
            li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
            TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
            if onChange then onChange(inp.KeyCode) end
            if isGp then
                kbEntry.gp = inp.KeyCode
                kbEntry.kb = nil
            else
                kbEntry.kb = inp.KeyCode
                kbEntry.gp = nil
            end
            if State.requestConfigSave then State.requestConfigSave() end
        end)
    end)
    return b
end

local function rowToggle(tabName, label, sub, defOn, onToggle)
    local c = baseCard(tabName, sub and 58 or 38)
    local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
    if sub then
        titleLabel.Size = UDim2.new(0, 160, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 7)
        local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
        sl.Size = UDim2.new(0, 170, 0, 13)
        sl.Position = UDim2.new(0, 10, 0, 35)
    end
    return makePillToggle(c, defOn, onToggle)
end

local function rowToggleKB(tabName, label, sub, kbEntry, defOn, onToggle, onKeyChange)
    local c = baseCard(tabName, sub and 58 or 38)
    local titleLabel = cLabel(c, label, 10, 120, 11, WHITE, Enum.Font.GothamBold)
    if sub then
        titleLabel.Size = UDim2.new(0, 120, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 7)
        local sl = cLabel(c, sub, 10, 150, 9, DIM, Enum.Font.Gotham)
        sl.Size = UDim2.new(0, 150, 0, 13)
        sl.Position = UDim2.new(0, 10, 0, 35)
    end
    local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
    kb.Position = UDim2.new(1, -(44+10+36+8+19), 0.5, -10)
    kb.ZIndex = 11
    local PW, PH = 36, 19
    local pbg = Instance.new("Frame", c)
    pbg.Size = UDim2.new(0, PW, 0, PH)
    pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
    pbg.BackgroundColor3 = defOn and WHITE or DIM2
    pbg.BorderSizePixel = 0
    pbg.ZIndex = 8
    Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
    local ps = Instance.new("UIStroke", pbg)
    ps.Color = defOn and WHITE or BORDER2
    ps.Thickness = 1
    local dot = Instance.new("Frame", pbg)
    dot.Size = UDim2.new(0, 13, 0, 13)
    dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    dot.BackgroundColor3 = defOn and BG or BORDER
    dot.BorderSizePixel = 0
    dot.ZIndex = 9
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local isOn = defOn or false
    local function setV(on)
        isOn = on
        TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
        TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
        TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
            BackgroundColor3 = on and BG or BORDER
        }):Play()
    end
    local clk = Instance.new("TextButton", c)
    clk.AutoButtonColor = false
    clk.Size = UDim2.new(1, 0, 1, 0)
    clk.BackgroundTransparency = 1
    clk.Text = ""
    clk.ZIndex = 6
    clk.MouseButton1Click:Connect(function()
        if _anyKeyListening then return end
        isOn = not isOn
        setV(isOn)
        if onToggle then pcall(onToggle, isOn) end
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    return setV, kb
end

local function rowKBOnly(tabName, label, sub, kbEntry, onKeyChange)
    local c = baseCard(tabName, sub and 58 or 38)
    local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
    if sub then
        titleLabel.Size = UDim2.new(0, 160, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 7)
        local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
        sl.Size = UDim2.new(0, 170, 0, 13)
        sl.Position = UDim2.new(0, 10, 0, 35)
    end
    local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
    kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
    kb.ZIndex = 11
    return kb
end

local function rowInput(tabName, label, sub, default, onChange)
    local c = baseCard(tabName, sub and 58 or 38)
    local titleLabel = cLabel(c, label, 10, 130, 11, WHITE, Enum.Font.GothamBold)
    if sub then
        titleLabel.Size = UDim2.new(0, 130, 0, 18)
        titleLabel.Position = UDim2.new(0, 10, 0, 7)
        local sl = cLabel(c, sub, 10, 160, 9, DIM, Enum.Font.Gotham)
        sl.Size = UDim2.new(0, 160, 0, 13)
        sl.Position = UDim2.new(0, 10, 0, 35)
    end
    local box = Instance.new("TextBox", c)
    box.Size = UDim2.new(0, 64, 0, 24)
    box.Position = UDim2.new(1, -74, 0.5, -12)
    box.BackgroundColor3 = INPUT_BG
    box.BackgroundTransparency = INPUT_TRANSPARENCY
    box.BorderSizePixel = 0
    box.Text = tostring(default)
    box.TextColor3 = WHITE
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.ClearTextOnFocus = false
    box.ZIndex = 11
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
    local bs = Instance.new("UIStroke", box)
    bs.Color = BORDER
    bs.Thickness = 1
    bs.ZIndex = 12
    box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play() end)
    box.FocusLost:Connect(function()
        TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
        if onChange then local n = tonumber(box.Text); if n then onChange(n) else box.Text = tostring(default) end end
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    return box
end

local function rowActionBtn(tabName, label, onClick)
    local b = Instance.new("TextButton", pg(tabName))
    b.AutoButtonColor = false
    b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = CARD_BG
    b.BackgroundTransparency = OPTION_TRANSPARENCY
    b.BorderSizePixel = 0
    b.Text = label
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.LayoutOrder = lo(tabName)
    b.ZIndex = 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
    local bSt = Instance.new("UIStroke", b)
    bSt.Color = BORDER
    bSt.Thickness = 1.2
    local pressScale = Instance.new("UIScale", b)
    pressScale.Scale = 1
    b.MouseButton1Click:Connect(function()
        TweenService:Create(pressScale, TweenInfo.new(0.06), {Scale=0.975}):Play()
        TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play()
        task.delay(0.08, function()
            if pressScale and pressScale.Parent then TweenService:Create(pressScale, TweenInfo.new(0.09, Enum.EasingStyle.Back), {Scale=1}):Play() end
        end)
        task.delay(0.15, function()
            if b and b.Parent then TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end
        end)
        if onClick then pcall(onClick) end
    end)
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
    return b
end

local function rowCycleSelector(tabName, label, options, defaultValue, onChange)
    local c = baseCard(tabName, 40)
    cLabel(c, label, 10, 110, 11, WHITE, Enum.Font.GothamBold)
    local left = Instance.new("TextButton", c)
    left.AutoButtonColor = false
    left.Size = UDim2.new(0, 26, 0, 24)
    left.Position = UDim2.new(1, -142, 0.5, -12)
    left.BackgroundColor3 = INPUT_BG
    left.BackgroundTransparency = INPUT_TRANSPARENCY
    left.BorderSizePixel = 0
    left.Text = "←"
    left.TextColor3 = WHITE
    left.Font = Enum.Font.GothamBlack
    left.TextSize = 15
    left.ZIndex = 12
    Instance.new("UICorner", left).CornerRadius = UDim.new(0, 12)
    local leftStroke = Instance.new("UIStroke", left)
    leftStroke.Color = BORDER
    leftStroke.Thickness = 1
    local valueLabel = Instance.new("TextLabel", c)
    valueLabel.Size = UDim2.new(0, 78, 0, 24)
    valueLabel.Position = UDim2.new(1, -112, 0.5, -12)
    valueLabel.BackgroundColor3 = INPUT_BG
    valueLabel.BackgroundTransparency = INPUT_TRANSPARENCY
    valueLabel.BorderSizePixel = 0
    valueLabel.TextColor3 = WHITE
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 9
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    valueLabel.ZIndex = 11
    Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(0, 12)
    local valueStroke = Instance.new("UIStroke", valueLabel)
    valueStroke.Color = BORDER
    valueStroke.Thickness = 1
    local right = Instance.new("TextButton", c)
    right.AutoButtonColor = false
    right.Size = UDim2.new(0, 26, 0, 24)
    right.Position = UDim2.new(1, -30, 0.5, -12)
    right.BackgroundColor3 = INPUT_BG
    right.BackgroundTransparency = INPUT_TRANSPARENCY
    right.BorderSizePixel = 0
    right.Text = "→"
    right.TextColor3 = WHITE
    right.Font = Enum.Font.GothamBlack
    right.TextSize = 15
    right.ZIndex = 12
    Instance.new("UICorner", right).CornerRadius = UDim.new(0, 12)
    local rightStroke = Instance.new("UIStroke", right)
    rightStroke.Color = BORDER
    rightStroke.Thickness = 1
    local index = 1
    for i, option in ipairs(options) do
        if option == defaultValue then index = i; break end
    end
    local function setValue(value, fireCallback)
        if type(value) == "number" then
            index = ((math.floor(value) - 1) % #options) + 1
        else
            for i, option in ipairs(options) do
                if option == value then index = i; break end
            end
        end
        valueLabel.Text = options[index]
        if fireCallback and onChange then pcall(onChange, options[index], index) end
        return options[index]
    end
    local function move(direction)
        setValue(index + direction, true)
        if State.requestConfigSave then State.requestConfigSave() end
    end
    left.Activated:Connect(function() move(-1) end)
    right.Activated:Connect(function() move(1) end)
    left.MouseEnter:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
    left.MouseLeave:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)
    right.MouseEnter:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
    right.MouseLeave:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)
    setValue(defaultValue, false)
    return setValue, function() return options[index] end
end

do
makeSecHeader("Speed", "Speed Configuration")
normalBox = rowInput("Speed", "Normal Speed", nil, NS, function(v)
    if v > 0 and v <= 500 then
        if State.speedProfile == "Lagger" then
            State.profileLaggerNormalSpeed = v
        else
            NS = v
        end
        if State.requestConfigSave then State.requestConfigSave() end
    end
end)
carryBox = rowInput("Speed", "Carry Speed", nil, CS, function(v)
    if v > 0 and v <= 500 then
        if State.speedProfile == "Lagger" then
            State.profileLaggerCarrySpeed = v
        else
            CS = v
            _G.CarrySpeedValue = v
        end
        if State.requestConfigSave then State.requestConfigSave() end
    end
end)
laggerBox = rowInput("Speed", "Lagger 1", nil, LS, function(v) if v>0 and v<=500 then LS=v end end)
laggerBox2 = rowInput("Speed", "Lagger 2", nil, LS2, function(v) if v>0 and v<=500 then LS2=v end end)
do
    local c = baseCard("Speed", 38)
    cLabel(c, "Mode", 10, 80, 11, WHITE, Enum.Font.GothamBold)
    modeValLbl = cLabel(c, "Normal", 88, 80, 10, DIM, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    local kb = makeKB(c, KB.Speed, function(k) end)
    kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
    kb.ZIndex = 11
    local clk = Instance.new("TextButton", c)
    clk.AutoButtonColor = false
    clk.Size = UDim2.new(0.65, 0, 1, 0)
    clk.BackgroundTransparency = 1
    clk.Text = ""
    clk.ZIndex = 6
    clk.Active = true
    clk.Activated:Connect(function()
        if _anyKeyListening then return end
        State.speedToggled = not State.speedToggled
        if State.speedToggled then
            State.laggerToggled = false
            if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        end
        if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
        modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
        if State.requestConfigSave then State.requestConfigSave() end
    end)
end
do
    local c = baseCard("Speed", 38)
    cLabel(c, "Lagger Mode", 10, 120, 11, WHITE, Enum.Font.GothamBold)
    local kb = makeKB(c, KB.Lagger, function(k) KB.Lagger.kb = k end)
    kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
    kb.ZIndex = 11
    local clk = Instance.new("TextButton", c)
    clk.AutoButtonColor = false
    clk.Size = UDim2.new(0.65, 0, 1, 0)
    clk.BackgroundTransparency = 1
    clk.Text = ""
    clk.ZIndex = 6
    clk.Active = true
    clk.Activated:Connect(function()
        if _anyKeyListening then return end
        State.laggerToggled = not State.laggerToggled
        if State.laggerToggled then
            State.speedToggled = false
            if mobileSpeedSetActive then mobileSpeedSetActive(false) end
        end
        modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
        if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
        if State.requestConfigSave then State.requestConfigSave() end
    end)
end
makeSecHeader("Bat Aimbot", "Bat Combat V1 & V2")
do
    local sv
    sv, _ = rowToggleKB("Bat Aimbot", "Auto Bat V1", "Predictive mode", KB.AutoBat, false,
    function(on)
        State.autoBatToggled = on
        if on then
            if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
            if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
            if State.autoBatV2Enabled then
                State.autoBatV2Enabled = false
                if autoBatV2SetVisual then autoBatV2SetVisual(false) end
                if mobileBatV2SetActive then mobileBatV2SetActive(false) end
                stopBatAimbotV2()
            end
            startBatAimbot()
        else
            stopBatAimbot()
        end
        if mobileBatV1SetActive then mobileBatV1SetActive(on) end
    end,
    function(k) KB.AutoBat.kb = k end)
    autoBatSetVisual = sv
    setAutoBat = sv
end
do
    local sv
    sv, _ = rowToggleKB("Bat Aimbot", "Bat V2", "Advanced version", KB.AutoBatV2, false,
    function(on)
        State.autoBatV2Enabled = on
        if on then
            if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
            if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
            if State.autoBatToggled then
                State.autoBatToggled = false
                if autoBatSetVisual then autoBatSetVisual(false) end
                stopBatAimbot()
            end
            if startBatAimbotV2 then startBatAimbotV2() end
        else
            if stopBatAimbotV2 then stopBatAimbotV2() end
        end
        if mobileBatV2SetActive then mobileBatV2SetActive(on) end
    end,
    function() end)
    autoBatV2SetVisual = sv
    setAutoBatV2 = sv
end

State._setTPBatEnabled = function(on)
    State.tpBatEnabled = on == true
    if State._hitboxFollower then
        if State.tpBatEnabled then
            if State.hitboxFollowerEnabled then State._hitboxFollower.stop() end
        elseif State.hitboxFollowerEnabled and not State.autoBatToggled then
            State._hitboxFollower.start()
        end
    end
end

State._tpBatConfigSetVisual = rowToggleKB("Bat Aimbot", "TP Bat", "Auto teleport and hit", KB.TPBat, false,
function(on)
    State._setTPBatEnabled(on)
    if State._tpBatSetter then State._tpBatSetter(on) end
    if State.requestConfigSave then State.requestConfigSave() end
end,
function() end)

State._tpBatVersionSetVisual = rowToggle("Bat Aimbot", "TP Bat V2", "Off = TP Bat V1 / On = TP Bat V2", false,
function(on)
    State.tpBatVersion = on and 2 or 1
    State._tpBatV2HittingCooldown = false
    State._tpBatHittingCooldown = false
    if State._updateTPBatButtonText then State._updateTPBatButtonText() end
    if State.requestConfigSave then State.requestConfigSave() end
end)

makeSecHeader("Mechanics", "Game Mechanics")
if not KB.InstaReset then KB.InstaReset = {kb=nil, gp=nil} end
local cInsta = baseCard("Mechanics", 48)
cInsta.LayoutOrder = lo("Mechanics")
cLabel(cInsta, "Insta Reset", 10, 120, 11, WHITE, Enum.Font.GothamBold)
local slInsta = cLabel(cInsta, "Reset normal do jogo", 10, 150, 9, DIM, Enum.Font.Gotham)
slInsta.Size = UDim2.new(0, 150, 0, 13)
slInsta.Position = UDim2.new(0, 10, 0, 24)
local plusBtn = Instance.new("TextButton", cInsta)
plusBtn.AutoButtonColor = false
plusBtn.Size = UDim2.new(0, 20, 0, 20)
plusBtn.Position = UDim2.new(1, -(44+10+36+8+20+4), 0.5, -10)
plusBtn.BackgroundColor3 = KB_BG
plusBtn.BorderSizePixel = 0
plusBtn.Text = "+"
plusBtn.TextColor3 = WHITE
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 14
plusBtn.ZIndex = 11
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 10)
local pbs = Instance.new("UIStroke", plusBtn)
pbs.Color = BORDER
pbs.Thickness = 1
plusBtn.MouseButton1Click:Connect(function()
    TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play()
    task.delay(0.1, function() TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)
    if btnInstaReset then
        btnInstaReset.Visible = not btnInstaReset.Visible
        if State.requestConfigSave then State.requestConfigSave() end
    end
end)
local kbInsta = makeKB(cInsta, KB.InstaReset, function() end)
kbInsta.Position = UDim2.new(1, -(44+10+36+8), 0.5, -10)
kbInsta.ZIndex = 11
local setInstaToggleVisual
setInstaToggleVisual = makePillToggle(cInsta, false, function(on)
    State.instaResetEnabled = on
    if on then
        if btnInstaReset then
            TweenService:Create(btnInstaReset, TweenInfo.new(0.08), {BackgroundColor3=WHITE, TextColor3=BG}):Play()
            task.delay(0.22, function()
                TweenService:Create(btnInstaReset, TweenInfo.new(0.15), {BackgroundColor3=BG, TextColor3=WHITE}):Play()
            end)
        end
        task.spawn(normalReset)
        task.wait(0.2)
        if setInstaToggleVisual then setInstaToggleVisual(false) end
    end
end)
setInfJump       = rowToggle("Mechanics", "Infinite Jump",  nil, false, function(on) State.infJumpEnabled = on end)
setLinieVisual   = rowToggle("Mechanics", "Linia ESP", nil, false, function(on) State.linieEnabled = on end)
setAntiRag       = rowToggle("Mechanics", "Anti Ragdoll",   nil, false, function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setUnwalkToggle  = rowToggle("Mechanics", "Unwalk",         nil, false, function(on) State.unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end end)
setMedusaCounter = rowToggle("Mechanics", "Medusa Counter", nil, false, function(on) State.medusaCounterEnabled=on; refreshMedusaHooks() end)
setMedusaReset   = rowToggle("Mechanics", "Medusa Reset", "Reset automático ao ser medusado", false, function(on) State.medusaResetEnabled=on; refreshMedusaHooks() end)
setBatCounter = rowToggle("Mechanics", "Bat Counter",    nil, false, function(on) State.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end end)
setAutoMedusaVisual = rowToggle("Mechanics", "Auto Medusa", "Uso automático y predictivo", false, function(on)
    MedusaConfig.Enabled = on
end)
rowInput("Mechanics", "Medusa Radius", "Detection range", MedusaConfig.Radius, function(v)
    MedusaConfig.Radius = v
    if MedusaConfig.RadiusPart then MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2) end
end)
rowInput("Mechanics", "Medusa Delay", "Spam Delay", MedusaConfig.Delay, function(v)
    MedusaConfig.Delay = v
end)

makeSecHeader("Movement", "Movement & Teleport")
rowKBOnly("Movement", "TP Down", "Teleport to floor", KB.TPDown, function(k) KB.TPDown.kb=k end)
do
    local sv
    sv, _ = rowToggleKB("Movement", "Auto Left", nil, KB.AutoLeft, false,
    function(on)
        State.autoLeftEnabled = on
        if on then
            if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
            if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
            if State.autoBatV2Enabled then
                State.autoBatV2Enabled = false
                if autoBatV2SetVisual then autoBatV2SetVisual(false) end
                if mobileBatV2SetActive then mobileBatV2SetActive(false) end
                stopBatAimbotV2()
            end
            local char = LP.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then startAutoLeft() end
        else stopAutoLeft() end
        if mobileAutoLeftSetActive then mobileAutoLeftSetActive(on) end
    end, function(k) KB.AutoLeft.kb=k end)
    autoLeftSetVisual = sv
end
do
    local sv
    sv, _ = rowToggleKB("Movement", "Auto Right", nil, KB.AutoRight, false,
    function(on)
        State.autoRightEnabled = on
        if on then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
            if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
            if State.autoBatV2Enabled then State.autoBatV2Enabled=false; if autoBatV2SetVisual then autoBatV2SetVisual(false) end; stopBatAimbotV2() end
            local char = LP.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then startAutoRight() end
        else stopAutoRight() end
        if mobileAutoRightSetActive then mobileAutoRightSetActive(on) end
    end, function(k) KB.AutoRight.kb=k end)
    autoRightSetVisual = sv
end
rowKBOnly("Movement", "Drop",    nil, KB.Drop,   function(k) KB.Drop.kb=k end)
do
    setAutoTPDownVisual = rowToggle("Movement", "Auto TP Down", nil, false, function(on)
        autoTPDownEnabled = on
        if mobileAutoTPSetActive then mobileAutoTPSetActive(on) end
        if on then startAutoTPDown() else stopAutoTPDown() end
    end)
    rowInput("Movement", "TP Down Height", nil, autoTPDownHeight, function(v)
        autoTPDownHeight = math.clamp(v, 0, 500)
    end)
end

makeSecHeader("Performance", "Performance")
do
    local _Lighting = game:GetService("Lighting")
    local _antiLagConn = nil
    local function applyAntiLag(instance)
        if instance:IsA("ParticleEmitter") then
            instance.Enabled = false
        elseif instance:IsA("Decal") then
            instance.Transparency = 1
        elseif instance:IsA("BasePart") then
            instance.Material = Enum.Material.Plastic
            instance.Reflectance = 0
            instance.CastShadow = false
        end
    end
    local function optimizeLighting()
        _Lighting.GlobalShadows = false
        _Lighting.FogEnd = 9e9
        _Lighting.Brightness = 1
        _Lighting.EnvironmentDiffuseScale = 0
        _Lighting.EnvironmentSpecularScale = 0
        for _, child in pairs(_Lighting:GetChildren()) do
            if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then child.Enabled = false end
        end
    end
    local function enableAntiLag()
        optimizeLighting()
        for _, desc in pairs(workspace:GetDescendants()) do
            applyAntiLag(desc)
            if desc:IsA("Accessory") then desc:Destroy() end
        end
        if _antiLagConn then _antiLagConn:Disconnect() end
        _antiLagConn = workspace.DescendantAdded:Connect(function(desc)
            applyAntiLag(desc)
            if desc:IsA("Accessory") then desc:Destroy() end
        end)
    end
    local function disableAntiLag()
        if _antiLagConn then _antiLagConn:Disconnect(); _antiLagConn = nil end
    end
    setAntiLag = function(on)
        State.antiLagEnabled = on
        if on then enableAntiLag() else disableAntiLag() end
    end
    local setAntiLagVisual = rowToggle("Performance", "Anti Lag", nil, false, function(on) setAntiLag(on) end)
    local rawSetAntiLag = setAntiLag
    setAntiLag = function(on) setAntiLagVisual(on); rawSetAntiLag(on) end
end
do
    local connection = nil
    local function rawSet(on)
        State.stretchRezEnabled = on
        if on then
            workspace.CurrentCamera.FieldOfView = 120
            if connection then connection:Disconnect() end
            connection = RunService.RenderStepped:Connect(function()
                if not State.stretchRezEnabled then
                    if connection then connection:Disconnect(); connection = nil end
                    return
                end
                workspace.CurrentCamera.FieldOfView = 120
            end)
        else
            if connection then connection:Disconnect(); connection = nil end
            workspace.CurrentCamera.FieldOfView = 70
        end
    end
    local visual = rowToggle("Performance", "Stretch Rez", nil, false, function(on) rawSet(on) end)
    setStretchRez = function(on) visual(on); rawSet(on) end
end
do
    local connection = nil
    local function removeFromCharacter(character)
        if not character then return end
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                pcall(function() obj:Destroy() end)
            end
        end
    end
    local function rawSet(on)
        State.removeAccessoriesEnabled = on
        if on then
            for _, player in pairs(Players:GetPlayers()) do removeFromCharacter(player.Character) end
            if not connection then
                connection = Players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Connect(function(character)
                        task.wait(0.5)
                        if State.removeAccessoriesEnabled then removeFromCharacter(character) end
                    end)
                end)
            end
        else
            if connection then connection:Disconnect(); connection = nil end
        end
    end
    local visual = rowToggle("Performance", "Remove Accessories", nil, false, function(on) rawSet(on) end)
    setRemoveAccessories = function(on) visual(on); rawSet(on) end
end

do
    local Lighting = game:GetService("Lighting")
    local defaults = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        ExposureCompensation = Lighting.ExposureCompensation,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        FogColor = Lighting.FogColor,
    }
    local styles = {
        {name="Off"},
        {name="Galaxy", tint=Color3.fromRGB(226, 224, 255), ambient=Color3.fromRGB(88, 84, 130), atmosphere=Color3.fromRGB(150, 148, 210), decay=Color3.fromRGB(92, 80, 160), clock=0.4, brightness=2.2, density=0.32, glare=0.28, haze=1.1, bloom=0.5, stars=4500},
        {name="Aurora", tint=Color3.fromRGB(222, 255, 240), ambient=Color3.fromRGB(78, 122, 108), atmosphere=Color3.fromRGB(130, 235, 200), decay=Color3.fromRGB(90, 190, 165), clock=1.2, brightness=2.4, density=0.3, glare=0.4, haze=1.35, bloom=0.6, stars=4000},
        {name="Green",  tint=Color3.fromRGB(228, 255, 226), ambient=Color3.fromRGB(84, 122, 84),  atmosphere=Color3.fromRGB(150, 225, 150), decay=Color3.fromRGB(100, 175, 100), clock=6.6, brightness=2.5, density=0.26, glare=0.22, haze=0.95, bloom=0.42, stars=1200},
        {name="Blue",   tint=Color3.fromRGB(224, 238, 255), ambient=Color3.fromRGB(80, 104, 140), atmosphere=Color3.fromRGB(140, 190, 250), decay=Color3.fromRGB(90, 140, 210), clock=5.8, brightness=2.5, density=0.28, glare=0.24, haze=1.0, bloom=0.45, stars=2500},
        {name="Red",    tint=Color3.fromRGB(255, 228, 224), ambient=Color3.fromRGB(130, 88, 84),  atmosphere=Color3.fromRGB(235, 130, 115), decay=Color3.fromRGB(190, 95, 85),  clock=17.6, brightness=2.4, density=0.28, glare=0.26, haze=1.05, bloom=0.48, stars=1500},
        {name="Pink",   tint=Color3.fromRGB(255, 230, 244), ambient=Color3.fromRGB(132, 96, 118), atmosphere=Color3.fromRGB(245, 160, 205), decay=Color3.fromRGB(205, 120, 165), clock=17.0, brightness=2.4, density=0.26, glare=0.26, haze=1.0, bloom=0.5, stars=2000},
        {name="Orange", tint=Color3.fromRGB(255, 238, 220), ambient=Color3.fromRGB(136, 108, 78), atmosphere=Color3.fromRGB(250, 180, 110), decay=Color3.fromRGB(210, 140, 80),  clock=17.9, brightness=2.5, density=0.26, glare=0.3, haze=1.0, bloom=0.45, stars=1200},
        {name="Cyan",   tint=Color3.fromRGB(222, 250, 255), ambient=Color3.fromRGB(80, 122, 132), atmosphere=Color3.fromRGB(135, 225, 240), decay=Color3.fromRGB(90, 180, 200), clock=6.2, brightness=2.5, density=0.28, glare=0.26, haze=1.05, bloom=0.45, stars=1800},
    }
    local function findStyle(name)
        for _, style in ipairs(styles) do
            if style.name == name then return style end
        end
        return styles[1]
    end
    local function clearSky()
        for _, name in ipairs({"GalaxySky", "PrimeColorSky", "PrimeSkyTint", "PrimeSkyAtmosphere", "PrimeSkyBloom"}) do
            local object = Lighting:FindFirstChild(name)
            if object then object:Destroy() end
        end
    end
    local function apply(styleName)
        local style = findStyle(styleName)
        clearSky()
        State.skyStyle = style.name
        State.darkModeEnabled = style.name ~= "Off"
        if style.name == "Off" then
            Lighting.Brightness = defaults.Brightness
            Lighting.ClockTime = defaults.ClockTime
            Lighting.ExposureCompensation = defaults.ExposureCompensation
            Lighting.OutdoorAmbient = defaults.OutdoorAmbient
            Lighting.Ambient = defaults.Ambient
            Lighting.FogColor = defaults.FogColor
            return style.name
        end
        local sky = Instance.new("Sky")
        sky.Name = "PrimeColorSky"
        sky.SkyboxBk = "rbxassetid://159454299"
        sky.SkyboxDn = "rbxassetid://159454296"
        sky.SkyboxFt = "rbxassetid://159454293"
        sky.SkyboxLf = "rbxassetid://159454286"
        sky.SkyboxRt = "rbxassetid://159454289"
        sky.SkyboxUp = "rbxassetid://159454291"
        sky.StarCount = style.stars or 2000
        sky.Parent = Lighting
        local correction = Instance.new("ColorCorrectionEffect")
        correction.Name = "PrimeSkyTint"
        correction.TintColor = style.tint
        correction.Brightness = 0.06
        correction.Contrast = 0.08
        correction.Saturation = 0.1
        correction.Parent = Lighting
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Name = "PrimeSkyAtmosphere"
        atmosphere.Color = style.atmosphere
        atmosphere.Decay = style.decay
        atmosphere.Density = style.density or 0.28
        atmosphere.Offset = 0.15
        atmosphere.Glare = style.glare or 0.25
        atmosphere.Haze = style.haze or 1
        atmosphere.Parent = Lighting
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "PrimeSkyBloom"
        bloom.Intensity = style.bloom or 0.45
        bloom.Size = 24
        bloom.Threshold = 1.2
        bloom.Parent = Lighting
        Lighting.Brightness = style.brightness or 2.4
        Lighting.ClockTime = style.clock or 14
        Lighting.ExposureCompensation = 0.25
        Lighting.OutdoorAmbient = style.ambient
        Lighting.Ambient = style.ambient:Lerp(Color3.fromRGB(200, 150, 255), 0.12)
        Lighting.FogColor = style.atmosphere:Lerp(Color3.fromRGB(200, 150, 255), 0.15)
        return style.name
    end
    local names = {}
    for _, style in ipairs(styles) do table.insert(names, style.name) end
    setSkySelectorVisual = rowCycleSelector("Performance", "Sky Color", names, State.skyStyle or "Off", function(styleName)
        apply(styleName)
    end)
    setSkyStyle = function(styleName)
        local applied = apply(styleName)
        if setSkySelectorVisual then setSkySelectorVisual(applied, false) end
        return applied
    end
    setDarkMode = function(on)
        return setSkyStyle(on and ((State.skyStyle and State.skyStyle ~= "Off") and State.skyStyle or "Galaxy") or "Off")
    end
end

setNoIntroToggle = rowToggle("Performance", "No Intro", "Desactiva la intro al volver a ejecutar", true, function(on)
    State.noIntro = on == true
    State.introEnabled = not State.noIntro
    if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

makeSecHeader("Settings", "Interface & Binds")
buttonsSizeBox = rowInput("Settings", "Buttons Size", "0 = mínimo • 100 = máximo", State.buttonsSizeValue, function(v)
    local n = math.clamp(math.floor(v + 0.5), 0, 100)
    applyMobileButtonsSize(n)
    if buttonsSizeBox then buttonsSizeBox.Text = tostring(n) end
    if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)
State._buttonsShapeSelectorVisual = rowCycleSelector(
    "Settings",
    "Buttons Shape",
    {"Circle", "Normal", "Square", "Rectangle"},
    State.buttonsShape,
    function(shapeName)
        applyMobileButtonsShape(shapeName)
    end
)
rowKBOnly("Settings", "Hide / Show GUI", nil, KB.GuiHide, function(k) KB.GuiHide.kb=k end)
setHideButtonsVisual = rowToggle("Settings", "Hide Buttons", "Oculta todos los botones flotantes", false, function(on)
    State.hideButtonsEnabled = on
    local visible = not on
    if MobilePanel then MobilePanel.Visible = visible end
    for _, mobileBtn in pairs(mobileButtonsByName) do
        if mobileBtn and mobileBtn.Parent then
            mobileBtn.Visible = visible
        end
    end
    if btnBatV2 then btnBatV2.Visible = visible end
    if btnInstaReset then btnInstaReset.Visible = visible end
    if pbFrame then pbFrame.Visible = visible end
    if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)
setLockUIVisual = rowToggle("Settings", "Lock UI", nil, false, function(on)
    uiLocked = on
    _G.AceGuiLocked = on and true or false
    if State._setStealBarLocked then State._setStealBarLocked(_G.AceGuiLocked) end
    if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)
local saveBtn; saveBtn = rowActionBtn("Settings", "Save Config", function()
    if saveConfig then
        local ok, saved = pcall(saveConfig, saveBtn)
        if (not ok or saved ~= true) and State._lastSaveError then warn("[PHANTOM AUTO SAVE] " .. tostring(State._lastSaveError)) end
    elseif State.savePositionBackup then
        local saved = State.savePositionBackup()
        if saveBtn and saveBtn.Parent then
            local previous = saveBtn.Text
            saveBtn.Text = saved and "Positions Saved!" or "Save Failed!"
            task.delay(1.5, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = previous end
            end)
        end
    end
end)
rowActionBtn("Settings", "Reset Mobile Buttons", function()
    if resetMobileButtons then resetMobileButtons() end
    if pbFrame then pbFrame.Position = UDim2.new(0.5,-190,1,-58) end
    if setAutoGrab then setAutoGrab(false) end
end)
end

do
    local BTN_SIZE = 60
    local BTN_GAP  = 12
    local PADDING  = 6
    MobilePanel = Instance.new("Frame")
    MobilePanel.Name = "MobileButtonsPanel"
    MobilePanel.Size = UDim2.new(0, PADDING * 2 + 3 * BTN_SIZE + 2 * BTN_GAP, 0, PADDING * 2 + 4 * BTN_SIZE + 3 * BTN_GAP)
    MobilePanel.Position = UDim2.new(1, -140, 0, 10)
    MobilePanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MobilePanel.BackgroundTransparency = 1
    MobilePanel.BorderSizePixel = 0
    MobilePanel.ZIndex = 95
    MobilePanel.Parent = gui

    local Q_OFF      = Color3.fromRGB(240, 235, 255)
    local Q_ON       = Color3.fromRGB(160, 100, 220)
    local Q_TEXT_OFF = Color3.fromRGB(180, 150, 220)
    State._purpleAnimatedButtons = State._purpleAnimatedButtons or {}
    State._purpleAnimationPeriod = 5.5

    local purpleTextPalette = {
        Color3.fromRGB(160, 100, 220),
        Color3.fromRGB(200, 150, 255),
        Color3.fromRGB(140, 80, 200),
        Color3.fromRGB(180, 120, 240),
        Color3.fromRGB(220, 170, 255),
        Color3.fromRGB(150, 90, 210),
    }

    local function paletteColor(palette, progress)
        local count = #palette
        if count == 0 then return Color3.fromRGB(160, 100, 220) end
        if count == 1 then return palette[1] end
        progress = progress % 1
        local scaled = progress * count
        local index = math.floor(scaled) + 1
        local nextIndex = (index % count) + 1
        local alpha = scaled - math.floor(scaled)
        alpha = alpha * alpha * (3 - 2 * alpha)
        return palette[index]:Lerp(palette[nextIndex], alpha)
    end

    State._registerPurpleAnimatedButton = function(button)
        if not button then return end
        button:SetAttribute("PurpleActive", false)
        button:SetAttribute("PurpleFlash", false)
        button.BackgroundColor3 = Q_OFF
        button.TextColor3 = Q_TEXT_OFF
        State._purpleAnimatedButtons[button] = {
            background = button.BackgroundColor3,
            text = button.TextColor3,
        }
    end

    if not State._purpleAnimationStarted then
        State._purpleAnimationStarted = true
        task.spawn(function()
            local lastClock = os.clock()
            while gui and gui.Parent do
                local now = os.clock()
                local dt = math.min(now - lastClock, 0.1)
                lastClock = now
                local progress = (now / State._purpleAnimationPeriod) % 1
                local blend = 1 - math.exp(-dt * 8)
                for button, visual in pairs(State._purpleAnimatedButtons) do
                    if button and button.Parent then
                        local active = button:GetAttribute("PurpleActive") == true
                        local flash = button:GetAttribute("PurpleFlash") == true
                        local targetBackground
                        local targetText
                        if active or flash then
                            targetBackground = Q_ON
                            targetText = paletteColor(purpleTextPalette, progress)
                        else
                            targetBackground = Q_OFF
                            targetText = Q_TEXT_OFF
                        end
                        visual.background = visual.background:Lerp(targetBackground, blend)
                        visual.text = visual.text:Lerp(targetText, blend)
                        button.BackgroundColor3 = visual.background
                        button.TextColor3 = visual.text
                    else
                        State._purpleAnimatedButtons[button] = nil
                    end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    end

    State._blueShineLabels = State._blueShineLabels or {}
    State._blueShineGradients = State._blueShineGradients or {}

    local function attachBlueTextShine(button)
        if not button or button:FindFirstChild("BlueTextShine") then return end
        button.TextTransparency = 1
        local shineText = Instance.new("TextLabel")
        shineText.Name = "BlueTextShine"
        shineText.BackgroundTransparency = 1
        shineText.BorderSizePixel = 0
        shineText.Size = UDim2.fromScale(1, 1)
        shineText.Position = UDim2.fromScale(0, 0)
        shineText.Text = button.Text
        shineText.TextColor3 = Color3.fromRGB(160, 100, 220)
        shineText.TextTransparency = 0
        shineText.TextScaled = button.TextScaled
        shineText.TextSize = button.TextSize
        shineText.Font = button.Font
        shineText.TextWrapped = button.TextWrapped
        shineText.LineHeight = button.LineHeight
        shineText.TextXAlignment = button.TextXAlignment
        shineText.TextYAlignment = button.TextYAlignment
        shineText.ZIndex = button.ZIndex + 1
        shineText.Active = false
        shineText.Selectable = false
        shineText.Parent = button
        local shineGradient = Instance.new("UIGradient")
        shineGradient.Name = "CleanBlueShine"
        shineGradient.Rotation = 0
        shineGradient.Offset = Vector2.new(-1.25, 0)
        shineGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(150, 100, 220)),
            ColorSequenceKeypoint.new(0.38, Color3.fromRGB(180, 120, 240)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(220, 170, 255)),
            ColorSequenceKeypoint.new(0.62, Color3.fromRGB(190, 130, 245)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 100, 220)),
        })
        shineGradient.Parent = shineText
        State._blueShineLabels[button] = shineText
        State._blueShineGradients[button] = shineGradient
        button:GetPropertyChangedSignal("Text"):Connect(function()
            if shineText.Parent then shineText.Text = button.Text end
        end)
        button:GetPropertyChangedSignal("Visible"):Connect(function()
            if shineText.Parent then shineText.Visible = button.Visible end
        end)
        button:GetPropertyChangedSignal("TextSize"):Connect(function()
            if shineText.Parent then shineText.TextSize = button.TextSize end
        end)
        button:GetPropertyChangedSignal("ZIndex"):Connect(function()
            if shineText.Parent then shineText.ZIndex = button.ZIndex + 1 end
        end)
    end

    if not State._blueShineSequenceStarted then
        State._blueShineSequenceStarted = true
        task.spawn(function()
            while gui and gui.Parent do
                local animatedAny = false
                for button, gradient in pairs(State._blueShineGradients) do
                    if not (gui and gui.Parent) then break end
                    if button and button.Parent and gradient and gradient.Parent and button.Visible then
                        animatedAny = true
                        gradient.Offset = Vector2.new(-1.25, 0)
                        local tween = TweenService:Create(
                            gradient,
                            TweenInfo.new(1.45, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                            {Offset = Vector2.new(1.25, 0)}
                        )
                        tween:Play()
                        tween.Completed:Wait()
                        task.wait(0.06)
                    elseif button and not button.Parent then
                        State._blueShineLabels[button] = nil
                        State._blueShineGradients[button] = nil
                    end
                end
                if not animatedAny then task.wait(0.5) else task.wait(0.8) end
            end
        end)
    end

    local function createMobileButton(name, displayText, col, row, isToggle, onAction)
        local xPos = PADDING + col * (BTN_SIZE + BTN_GAP)
        local yPos = PADDING + row * (BTN_SIZE + BTN_GAP)
        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. name
        btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
        local defaultPos = UDim2.new(1, -140 + xPos, 0, 10 + yPos)
        btn.Position = defaultPos
        btn.BackgroundColor3 = Q_OFF
        btn.Text = displayText
        btn.TextColor3 = Q_TEXT_OFF
        btn.TextScaled = false
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.TextWrapped = true
        btn.LineHeight = 1.2
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 99
        btn.Parent = gui
        State._registerPurpleAnimatedButton(btn)
        attachBlueTextShine(btn)
        mobileButtonsByName[name] = btn
        mobileButtonDefaultPositions[name] = defaultPos
        makeDraggable(btn)
        btn.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if State.requestConfigSave then State.requestConfigSave() end
            end
        end)
        Instance.new("UICorner", btn).Name = "ButtonShapeCorner"
        local mobileStroke = Instance.new("UIStroke")
        mobileStroke.Name = "PurpleOuterStroke"
        mobileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        mobileStroke.Color = Color3.fromRGB(180, 150, 230)
        mobileStroke.Thickness = 0.9
        mobileStroke.Transparency = 0.22
        mobileStroke.LineJoinMode = Enum.LineJoinMode.Round
        mobileStroke.Parent = btn
        applyMobileButtonsSize(State.buttonsSizeValue)
        local isOn = false
        local function setter(s)
            isOn = s
            btn:SetAttribute("PurpleActive", s == true)
        end
        local function flash()
            btn:SetAttribute("PurpleFlash", true)
            task.delay(0.35, function()
                if btn and btn.Parent then btn:SetAttribute("PurpleFlash", false) end
            end)
        end
        btn.Activated:Connect(function()
            if isToggle then
                isOn = not isOn
                setter(isOn)
                if onAction then onAction(isOn) end
            else
                flash()
                if onAction then onAction() end
            end
            if State.requestConfigSave then State.requestConfigSave() end
        end)
        return btn, setter
    end

    createMobileButton("Drop", "DROP\nBR", 0, 0, false, function() task.spawn(runDrop) end)

    btnBatV2 = Instance.new("TextButton")
    btnBatV2.Name = "Btn_BatnV2"
    btnBatV2.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
    btnBatV2.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING)
    btnBatV2.BackgroundColor3 = Q_OFF
    btnBatV2.Text = "BAT V2"
    btnBatV2.TextColor3 = Q_TEXT_OFF
    btnBatV2.TextScaled = false
    btnBatV2.TextSize = 11
    btnBatV2.Font = Enum.Font.GothamBold
    btnBatV2.TextWrapped = true
    btnBatV2.LineHeight = 1.2
    btnBatV2.BorderSizePixel = 0
    btnBatV2.AutoButtonColor = false
    btnBatV2.ZIndex = 100
    btnBatV2.Parent = gui
    State._registerPurpleAnimatedButton(btnBatV2)
    attachBlueTextShine(btnBatV2)
    Instance.new("UICorner", btnBatV2).Name = "ButtonShapeCorner"
    local batV2Stroke = Instance.new("UIStroke")
    batV2Stroke.Name = "PurpleOuterStroke"
    batV2Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    batV2Stroke.Color = Color3.fromRGB(180, 150, 230)
    batV2Stroke.Thickness = 0.9
    batV2Stroke.Transparency = 0.22
    batV2Stroke.LineJoinMode = Enum.LineJoinMode.Round
    batV2Stroke.Parent = btnBatV2
    applyMobileButtonsSize(State.buttonsSizeValue)
    makeDraggable(btnBatV2)
    btnBatV2.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if State.requestConfigSave then State.requestConfigSave() end
        end
    end)
    State._batV2On = false
    State._setBatV2Visual = function(s)
        State._batV2On = s
        btnBatV2:SetAttribute("PurpleActive", s == true)
        if autoBatV2SetVisual then autoBatV2SetVisual(s) end
    end
    btnBatV2.Activated:Connect(function()
        State._batV2On = not State._batV2On
        State._setBatV2Visual(State._batV2On)
        State.autoBatV2Enabled = State._batV2On
        if State._batV2On then
            if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
            if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
            if State.autoBatToggled then
                State.autoBatToggled = false
                if autoBatSetVisual then autoBatSetVisual(false) end
                stopBatAimbot()
            end
            if startBatAimbotV2 then startBatAimbotV2() end
        else
            if stopBatAimbotV2 then stopBatAimbotV2() end
        end
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    local oldAutoBatV2SetVisual = autoBatV2SetVisual
    autoBatV2SetVisual = function(on)
        State._batV2On = on
        btnBatV2:SetAttribute("PurpleActive", on == true)
        if oldAutoBatV2SetVisual then oldAutoBatV2SetVisual(on) end
    end
    mobileBatV2SetActive = function(on) autoBatV2SetVisual(on) end

    btnInstaReset = Instance.new("TextButton")
    btnInstaReset.Name = "Btn_InstaReset"
    btnInstaReset.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
    btnInstaReset.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING + BTN_SIZE + BTN_GAP)
    btnInstaReset.BackgroundColor3 = Q_OFF
    btnInstaReset.Text = "INSTA\nRESET"
    btnInstaReset.TextColor3 = Q_TEXT_OFF
    btnInstaReset.TextScaled = false
    btnInstaReset.TextSize = 11
    btnInstaReset.Font = Enum.Font.GothamBold
    btnInstaReset.TextWrapped = true
    btnInstaReset.LineHeight = 1.2
    btnInstaReset.BorderSizePixel = 0
    btnInstaReset.AutoButtonColor = false
    btnInstaReset.ZIndex = 100
    btnInstaReset.Parent = gui
    State._registerPurpleAnimatedButton(btnInstaReset)
    attachBlueTextShine(btnInstaReset)
    Instance.new("UICorner", btnInstaReset).Name = "ButtonShapeCorner"
    local instaResetStroke = Instance.new("UIStroke")
    instaResetStroke.Name = "PurpleOuterStroke"
    instaResetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    instaResetStroke.Color = Color3.fromRGB(180, 150, 230)
    instaResetStroke.Thickness = 0.9
    instaResetStroke.Transparency = 0.22
    instaResetStroke.LineJoinMode = Enum.LineJoinMode.Round
    instaResetStroke.Parent = btnInstaReset
    applyMobileButtonsSize(State.buttonsSizeValue)
    makeDraggable(btnInstaReset)
    btnInstaReset.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if State.requestConfigSave then State.requestConfigSave() end
        end
    end)
    btnInstaReset.Activated:Connect(function()
        btnInstaReset:SetAttribute("PurpleFlash", true)
        task.delay(0.35, function()
            if btnInstaReset and btnInstaReset.Parent then btnInstaReset:SetAttribute("PurpleFlash", false) end
        end)
        if setInstaToggleVisual then
            setInstaToggleVisual(true)
            task.delay(0.2, function() setInstaToggleVisual(false) end)
        end
        task.spawn(normalReset)
        if State.requestConfigSave then State.requestConfigSave() end
    end)

    resetMobileButtons = function()
        for name, btn in pairs(mobileButtonsByName) do
            local defaultPos = mobileButtonDefaultPositions[name]
            if btn and defaultPos then btn.Position = defaultPos end
        end
        btnBatV2.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING)
        btnInstaReset.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING + BTN_SIZE + BTN_GAP)
        if State.requestPositionSave then State.requestPositionSave() end
        if State.requestConfigSave then State.requestConfigSave() end
    end

    do
        local setter = select(2, createMobileButton("AutoLeft", "AUTO\nLEFT", 1, 0, true, function(on)
            State.autoLeftEnabled = on
            if on then
                if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
                if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
                if State.autoBatV2Enabled then
                    State.autoBatV2Enabled = false
                    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
                    if mobileBatV2SetActive then mobileBatV2SetActive(false) end
                    stopBatAimbotV2()
                end
                local char = LP.Character
                local hum = char and char:FindFirstChild("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.WalkSpeed > 0 and not root.Anchored then startAutoLeft() end
            else
                stopAutoLeft()
            end
        end))
        local previous = autoLeftSetVisual
        autoLeftSetVisual = function(on)
            setter(on)
            if previous then previous(on) end
        end
        mobileAutoLeftSetActive = function(on) autoLeftSetVisual(on) end
        if mobileBtnActive then mobileBtnActive.AutoLeft = setter end
    end

    do
        local setter = select(2, createMobileButton("AutoBat", "BAT\nAIMBOT", 0, 1, true, function(on)
            State.autoBatToggled = on
            if on then
                if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
                if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
                if State._batV2On then
                    State._batV2On = false; State._setBatV2Visual(false); State.autoBatV2Enabled = false
                    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
                    if stopBatAimbotV2 then stopBatAimbotV2() end
                end
                startBatAimbot()
            else
                stopBatAimbot()
            end
        end))
        local previous = autoBatSetVisual
        autoBatSetVisual = function(on)
            setter(on)
            if previous then previous(on) end
        end
        mobileBatV1SetActive = function(on) autoBatSetVisual(on) end
        if mobileBtnActive then mobileBtnActive.AutoBat = setter end
    end

    do
        local setter = select(2, createMobileButton("AutoRight", "AUTO\nRIGHT", 1, 1, true, function(on)
            State.autoRightEnabled = on
            if on then
                if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
                if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
                if State.autoBatV2Enabled then
                    State.autoBatV2Enabled = false
                    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
                    if mobileBatV2SetActive then mobileBatV2SetActive(false) end
                    stopBatAimbotV2()
                end
                local char = LP.Character
                local hum = char and char:FindFirstChild("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.WalkSpeed > 0 and not root.Anchored then startAutoRight() end
            else
                stopAutoRight()
            end
        end))
        local previous = autoRightSetVisual
        autoRightSetVisual = function(on)
            setter(on)
            if previous then previous(on) end
        end
        mobileAutoRightSetActive = function(on) autoRightSetVisual(on) end
        if mobileBtnActive then mobileBtnActive.AutoRight = setter end
    end

    createMobileButton("TPDown", "TP\nDOWN", 0, 2, false, function() task.spawn(runTPDown) end)

    State._tpBatButton, State._tpBatSetter = createMobileButton("TPBat", "TP\nBAT", 0, 4, true, function(on)
        State._setTPBatEnabled(on)
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
        if State._updateTPBatButtonText then State._updateTPBatButtonText() end
    end)

    State._updateTPBatButtonText = function()
        local btn = State._tpBatButton
        if not btn or not btn.Parent then return end
        btn.Text = "TP\nBAT " .. ((State.tpBatVersion == 2) and "2" or "1")
    end

    State._tpBatSetVisual = function(on)
        State._setTPBatEnabled(on)
        if State._tpBatSetter then State._tpBatSetter(on) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
        if State._updateTPBatButtonText then State._updateTPBatButtonText() end
    end
    State._updateTPBatButtonText()

    local function _forceWalkSpeed(v)
        pcall(function()
            local c = LP.Character
            local hum2 = c and c:FindFirstChildOfClass("Humanoid")
            if hum2 and v and v > 0 then hum2.WalkSpeed = v end
        end)
    end

    do
        local setter
        local _, s = createMobileButton("Speed", "CARRY\nSPD", 1, 2, true, function(on)
            State.speedToggled = on and true or false
            if on then
                State.laggerToggled = false
                laggerPhase = 0
                if mobileLaggerSetActive then mobileLaggerSetActive(false) end
                _forceWalkSpeed(getProfileCarrySpeed())
                if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry" end
                task.defer(function() if setter then setter(true) end end)
            else
                _forceWalkSpeed(getProfileNormalSpeed())
                if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
            end
        end)
        setter = s
        mobileSpeedSetActive = function(on) if setter then setter(on) end end
    end

    do
        local set1, set2
        local _, s1 = createMobileButton("Lagger", "LAGGER\n1", 0, 3, true, function(on)
            if on then
                State.laggerToggled = true
                laggerPhase = 1
                State.speedToggled = false
                if mobileSpeedSetActive then mobileSpeedSetActive(false) end
                if set2 then set2(false) end
                _forceWalkSpeed(LS)
                if modeValLbl then modeValLbl.Text = "Lagger 1" end
                task.defer(function() if set1 then set1(true) end end)
            else
                State.laggerToggled = false
                laggerPhase = 0
                _forceWalkSpeed(getProfileNormalSpeed())
                if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
            end
        end)
        set1 = s1
        local _, s2 = createMobileButton("Lagger2", "LAGGER\n2", 1, 3, true, function(on)
            if on then
                State.laggerToggled = true
                laggerPhase = 2
                State.speedToggled = false
                if mobileSpeedSetActive then mobileSpeedSetActive(false) end
                if set1 then set1(false) end
                _forceWalkSpeed(LS2)
                if modeValLbl then modeValLbl.Text = "Lagger 2" end
                task.defer(function() if set2 then set2(true) end end)
            else
                State.laggerToggled = false
                laggerPhase = 0
                _forceWalkSpeed(getProfileNormalSpeed())
                if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
            end
        end)
        set2 = s2
        mobileLaggerSetActive = function(on)
            if on then
                State.laggerToggled = true
                if laggerPhase ~= 2 then laggerPhase = 1 end
                if laggerPhase == 2 then
                    if set1 then set1(false) end
                    if set2 then set2(true) end
                    _forceWalkSpeed(LS2)
                else
                    if set2 then set2(false) end
                    if set1 then set1(true) end
                    _forceWalkSpeed(LS)
                end
            else
                laggerPhase = 0
                State.laggerToggled = false
                if set1 then set1(false) end
                if set2 then set2(false) end
            end
        end
    end

    do
        local wasFrozen = false
        local _frozenLastCheck = 0
        RunService.Heartbeat:Connect(function()
            local _now = os.clock()
            if _now - _frozenLastCheck < 0.12 then return end
            _frozenLastCheck = _now
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if not hrp or not hum then return end
            local isCurrentlyFrozen = hrp.Anchored or hum.WalkSpeed == 0
            if isCurrentlyFrozen then
                if State.autoBatV2Enabled or State._batV2On then
                    State._batV2On = false
                    State._setBatV2Visual(false)
                    State.autoBatV2Enabled = false
                    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
                    if stopBatAimbotV2 then stopBatAimbotV2() end
                end
                if State.autoBatToggled then
                    State.autoBatToggled = false
                    if autoBatSetVisual then autoBatSetVisual(false) end
                    stopBatAimbot()
                end
                if not wasFrozen then
                    wasFrozen = true
                    if State.autoLeftEnabled then stopAutoLeft() end
                    if State.autoRightEnabled then stopAutoRight() end
                end
            else
                if wasFrozen then
                    wasFrozen = false
                    if State.autoLeftEnabled then startAutoLeft() end
                    if State.autoRightEnabled then startAutoRight() end
                end
            end
        end)
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESP = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESP[player] then return end
    local Line = Drawing.new("Line")
    Line.Color = Color3.fromRGB(160, 100, 220)
    Line.Thickness = 0.1
    Line.Transparency = 0.7
    Line.Visible = false
    local Distance = Drawing.new("Text")
    Distance.Color = Color3.fromRGB(180, 130, 230)
    Distance.Size = 11
    Distance.Center = true
    Distance.Outline = true
    Distance.Visible = false
    ESP[player] = {Line, Distance}
end

for _, v in ipairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(player)
    if ESP[player] then
        for _, obj in ipairs(ESP[player]) do obj:Remove() end
        ESP[player] = nil
    end
    if player.Character then
        local hl = player.Character:FindFirstChild("HologramPurple")
        if hl then hl:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if not State.linieEnabled then
        if not State._espCleaned then
            State._espCleaned = true
            for player, objs in pairs(ESP) do
                local char = player.Character
                if char then
                    local hl = char:FindFirstChild("HologramPurple")
                    if hl then hl:Destroy() end
                end
                for _, obj in ipairs(objs) do obj.Visible = false end
            end
        end
        return
    end
    State._espCleaned = false
    local _now = os.clock()
    if _now - (State._espLastUpdate or 0) < 0.0222 then return end
    State._espLastUpdate = _now
    Camera = workspace.CurrentCamera
    if not Camera then return end
    local _camPos = Camera.CFrame.Position
    local _vp = Camera.ViewportSize
    local _fromX, _fromY = _vp.X / 2, _vp.Y
    for player, objs in pairs(ESP) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")
        if hrp and hum and head and hum.Health > 0 then
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)
            local holo = char:FindFirstChild("HologramPurple")
            if not holo then
                holo = Instance.new("Highlight")
                holo.Name = "HologramPurple"
                holo.FillColor = Color3.fromRGB(130, 80, 200)
                holo.FillTransparency = 0.5
                holo.OutlineColor = Color3.fromRGB(180, 120, 240)
                holo.OutlineTransparency = 0.2
                holo.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                holo.Parent = char
            end
            if visible then
                local distance = math.floor((hrp.Position - _camPos).Magnitude)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - feetPos.Y)
                objs[1].Visible = true
                objs[1].From = Vector2.new(_fromX, _fromY)
                objs[1].To = Vector2.new(pos.X, pos.Y)
                objs[2].Visible = true
                objs[2].Position = Vector2.new(pos.X, pos.Y - height / 2 - 16)
                objs[2].Text = distance .. " Studs"
            else
                for _, obj in ipairs(objs) do obj.Visible = false end
            end
        else
            if char then
                local hl = char:FindFirstChild("HologramPurple")
                if hl then hl:Destroy() end
            end
            for _, obj in ipairs(objs) do obj.Visible = false end
        end
    end
end)

State._positionConfigFile = "PHANTOM_DUELS_POSITIONS.json"
State._positionBackupFile = "PHANTOM_DUELS_POSITIONS.backup.json"
State._positionTempFile = "PHANTOM_DUELS_POSITIONS.tmp.json"
State._positionSaveRequestId = 0

State._positionSnapshot = function(guiObject)
    if not guiObject then return nil end
    local ok, position = pcall(function() return guiObject.Position end)
    if not ok or not position then return nil end
    return {xs=position.X.Scale, xo=position.X.Offset, ys=position.Y.Scale, yo=position.Y.Offset}
end

State._restoreSavedPosition = function(guiObject, data)
    if not guiObject or type(data) ~= "table" or data.xs == nil then return end
    pcall(function()
        guiObject.Position = UDim2.new(
            tonumber(data.xs) or 0,
            tonumber(data.xo) or 0,
            tonumber(data.ys) or 0,
            tonumber(data.yo) or 0
        )
    end)
end

State.savePositionBackup = function()
    local buttonPositions = {}
    for name, button in pairs(mobileButtonsByName) do buttonPositions[name] = State._positionSnapshot(button) end
    local payload = {
        version = 2,
        mainPos = State._positionSnapshot(main),
        miniPos = State._positionSnapshot(mini),
        panelPos = State._positionSnapshot(MobilePanel),
        pbPos = State._positionSnapshot(pbFrame),
        batV2Pos = State._positionSnapshot(btnBatV2),
        instaResetPos = State._positionSnapshot(btnInstaReset),
        autoStealBarPos = State._positionSnapshot(State.autoStealBarFrame),
        mobileButtonPositions = buttonPositions,
    }
    local encodedOk, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
    if not encodedOk then return false end
    if encoded == State._lastPositionJson then
        State._positionDirty = false
        return true
    end
    local saved, err = State._atomicJsonSave(
        State._positionConfigFile,
        State._positionBackupFile,
        State._positionTempFile,
        encoded
    )
    if saved then
        State._lastPositionJson = encoded
        State._positionDirty = false
    else
        State._lastSaveError = err
    end
    return saved
end

State.loadPositionBackup = function()
    local mainData, mainRaw = State._readValidJsonFile(State._positionConfigFile)
    local tempData, tempRaw = State._readValidJsonFile(State._positionTempFile)
    local backupData, backupRaw = State._readValidJsonFile(State._positionBackupFile)
    local data, raw, recovered = nil, nil, false
    if type(tempData) == "table" and (type(mainData) ~= "table" or tempRaw ~= mainRaw) then
        data, raw, recovered = tempData, tempRaw, true
    elseif type(mainData) == "table" then
        data, raw = mainData, mainRaw
    elseif type(backupData) == "table" then
        data, raw, recovered = backupData, backupRaw, true
    end
    if type(data) ~= "table" then return false end
    State._lastPositionJson = raw
    State._positionDirty = false
    local function apply()
        State._restoreSavedPosition(main, data.mainPos)
        State._restoreSavedPosition(mini, data.miniPos)
        State._restoreSavedPosition(MobilePanel, data.panelPos)
        State._restoreSavedPosition(pbFrame, data.pbPos)
        State._restoreSavedPosition(btnBatV2, data.batV2Pos)
        State._restoreSavedPosition(btnInstaReset, data.instaResetPos)
        State._restoreSavedPosition(State.autoStealBarFrame, data.autoStealBarPos)
        if type(data.mobileButtonPositions) == "table" then
            for name, positionData in pairs(data.mobileButtonPositions) do
                State._restoreSavedPosition(mobileButtonsByName[name], positionData)
            end
        end
    end
    apply()
    task.delay(0.45, apply)
    task.delay(1.2, apply)
    if recovered and type(raw) == "string" then
        task.defer(function()
            State._atomicJsonSave(
                State._positionConfigFile,
                State._positionBackupFile,
                State._positionTempFile,
                raw
            )
        end)
    end
    return true
end

State.requestPositionSave = function()
    State._positionDirty = true
    State._positionSaveRequestId = State._positionSaveRequestId + 1
    local requestId = State._positionSaveRequestId
    task.delay(0.55, function()
        if requestId ~= State._positionSaveRequestId then return end
        if not State._positionDirty then return end
        local ok, result = pcall(State.savePositionBackup)
        if not ok then State._lastSaveError = tostring(result) end
    end)
end

task.spawn(function()
    task.wait(0.15)
    pcall(State.loadPositionBackup)
end)

local LUST_BYPASS_AIMBOT_SPEED = 60
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5
local BAT_V2_SWING_COOLDOWN = 0.1
local bypassHittingCooldown = false

local function getClosestPlayerV2()
    local char = LP.Character
    if not char then return nil, math.huge end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, bestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < bestDistance then
                    bestDistance = distance
                    closest = player
                end
            end
        end
    end
    return closest, bestDistance
end

local function tryHitBypassBat()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function() humanoid:EquipTool(bat) end)
                end
            end
            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() bat:Activate() end)
            end
        end
    end)
    task.delay(BAT_V2_SWING_COOLDOWN, function()
        bypassHittingCooldown = false
    end)
    task.delay(0.2, function()
        if bypassHittingCooldown then bypassHittingCooldown = false end
    end)
end

startBatAimbotV2 = function()
    if Conns.aimbotV2 then return end
    State.autoBatV2Enabled = true
    Conns.aimbotV2 = RunService.Heartbeat:Connect(function()
        if not State.autoBatV2Enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end
        local humanoidState = humanoid:GetState()
        if humanoidState == Enum.HumanoidStateType.Physics
            or humanoidState == Enum.HumanoidStateType.Ragdoll
            or humanoidState == Enum.HumanoidStateType.FallingDown then
            return
        end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then
                pcall(function() humanoid:EquipTool(bat) end)
            end
        end
        local target = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVelocity = targetRoot.AssemblyLinearVelocity
                local movementDirection = targetVelocity.Magnitude > 0.1
                    and targetVelocity.Unit
                    or targetRoot.CFrame.LookVector
                local offset = movementDirection * BAT_V2_FOLLOW_DIST
                    + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                local desiredPosition = targetRoot.Position + offset
                local directionToTarget = desiredPosition - root.Position
                if directionToTarget.Magnitude > 0.5 then
                    local movementVector = directionToTarget.Unit * LUST_BYPASS_AIMBOT_SPEED
                    root.AssemblyLinearVelocity = Vector3.new(
                        movementVector.X,
                        movementVector.Y,
                        movementVector.Z
                    )
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end
                if State.autoSwingEnabled
                    and (root.Position - targetRoot.Position).Magnitude <= BAT_V2_HIT_DIST then
                    tryHitBypassBat()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

stopBatAimbotV2 = function()
    State.autoBatV2Enabled = false
    if Conns.aimbotV2 then
        Conns.aimbotV2:Disconnect()
        Conns.aimbotV2 = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function()
            if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", nil) end
        end)
    end
    bypassHittingCooldown = false
    State.lastMoveDir = Vector3.zero
end

;(function()
local function _isfile(path)
    local checker = State._resolveFileFunction("isfile")
    if type(checker) == "function" then
        local ok, exists = pcall(checker, path)
        if ok then return exists == true end
    end
    local raw = State._safeReadFile(path)
    return type(raw) == "string"
end

local function _readfile(path)
    local raw, err = State._safeReadFile(path)
    if type(raw) ~= "string" then error(err or "readfile failed", 0) end
    return raw
end

local function _writefile(path, data)
    local ok, err = State._safeWriteFile(path, data)
    if not ok then error(err or "writefile failed", 0) end
    return true
end

local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

local PLOT_CACHE_DURATION=2
local PROMPT_CACHE_REFRESH=0.15
local STEAL_COOLDOWN=0.1
local MEDUSA_COOLDOWN=25
local DROP_AUTO_OFF_DELAY=0.15
local CONFIG_FILE="PHANTOM_DUELS_CONFIG.json"
State._configTempFile="PHANTOM_DUELS_CONFIG.tmp.json"
State._legacyConfigFile="PHANTOM_CONFIG.json"
State._configBackupFile="PHANTOM_DUELS_CONFIG.backup.json"
State._legacyConfigBackupFile="PHANTOM_CONFIG.backup.json"
State._legacyConfigTempFile="PHANTOM_CONFIG.tmp.json"

State.autoLeftPhase=1
State.autoRightPhase=1
State.medusaLastUsed=0
State.medusaDebounce=false
State.medusaCounterEnabled=false
State.medusaResetEnabled=false
State.batAimbotToggled=false
State.autoSwingEnabled=false
State.hittingCooldown=false
State.batCounterEnabled=false
State.batCounterDebounce=false
State.dropEnabled=false
State._tpInProgress=false
State.lastMoveDir=Vector3.new(0,0,0)
State._prevCarry=CS
State._prevSpeed=false
State.laggerEnabled=false
Conns.autoLeft=nil
Conns.autoRight=nil
Conns.aimbot=nil
Conns.batCounter=nil
Conns.unwalk=nil
local Presets={}
local PRESET_FILE="PHANTOM_Presets.json"
local LAST_PRESET_FILE="PHANTOM_LastPreset.json"

local function loadPresetsFile()
    local hasFile=false
    pcall(function() hasFile=_isfile(PRESET_FILE) end)
    if not hasFile then return end
    local raw
    pcall(function() raw=_readfile(PRESET_FILE) end)
    if not raw then return end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then Presets=dec end
end

local function loadLastPresetName()
    local hasFile=false
    pcall(function() hasFile=_isfile(LAST_PRESET_FILE) end)
    if not hasFile then return nil end
    local raw
    pcall(function() raw=_readfile(LAST_PRESET_FILE) end)
    if not raw then return nil end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then return dec.lastPreset end
    return nil
end

local function createRadiusPart()
    local p = Instance.new("Part")
    p.Name = "MedusaRadius"
    p.Anchored = true
    p.CanCollide = false
    pcall(function() p.CanQuery = false end)
    p.Transparency = 1
    p.Material = Enum.Material.Neon
    p.Color = Color3.fromRGB(160, 100, 220)
    p.Shape = Enum.PartType.Cylinder
    p.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2)
    p.Parent = workspace
    MedusaConfig.RadiusPart = p
end

local function isMedusaEquipped()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == "Medusa's Head" then
            return tool
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not MedusaConfig.Enabled then
        if MedusaConfig.RadiusPart and MedusaConfig.RadiusPart.Transparency ~= 1 then
            MedusaConfig.RadiusPart.Transparency = 1
        end
        return
    end
    local _now = os.clock()
    if _now - (State._medusaLast or 0) < 0.05 then return end
    State._medusaLast = _now
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if not MedusaConfig.RadiusPart then createRadiusPart() end
    MedusaConfig.RadiusPart.Transparency = 0.7
    MedusaConfig.RadiusPart.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.5, 0)) * CFrame.Angles(0, 0, math.rad(90))
    local tool = isMedusaEquipped()
    if tool and (tick() - MedusaConfig.LastUsed >= MedusaConfig.Delay) then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local pRoot = plr.Character.HumanoidRootPart
                if (pRoot.Position - root.Position).Magnitude <= MedusaConfig.Radius then
                    tool:Activate()
                    MedusaConfig.LastUsed = tick()
                    break
                end
            end
        end
    end
end)

local function doTpDown()
    pcall(function()
        local character, humanoid, root = safetyCharacterParts()
        if character then safetyTeleportToFloor(character, humanoid, root) end
    end)
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function findBatForCounter()
    local c=LP.Character
    if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _,ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end

local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end
        task.wait(0.05)
    end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

local function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char=LP.Character
        if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid")
        if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5)
                State.batCounterDebounce=false
            end)
        end
    end)
end

local function stopBatCounter()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end

local function findMedusa()
    local c=LP.Character
    if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n=t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp=LP:FindFirstChild("Backpack")
    if bp then
        for _,t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n=t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if State.medusaDebounce then return end
    if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character
    if not c then return end
    State.medusaDebounce=true
    local med=findMedusa()
    if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then
        local hum2=c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    State.medusaLastUsed=tick()
    State.medusaDebounce=false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if State.medusaResetEnabled then task.spawn(normalReset)
            elseif State.medusaCounterEnabled then useMedusaCounter() end
        end
    end)
end

function setupMedusaCounter(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end
    Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end))
end

function stopMedusaCounter()
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end
    Conns.anchor={}
end

function refreshMedusaHooks()
    if State.medusaCounterEnabled or State.medusaResetEnabled then
        setupMedusaCounter(LP.Character)
    else
        stopMedusaCounter()
    end
end

local function faceSouth()
    pcall(function()
        local c=LP.Character
        if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0) end
    end)
end

local function faceNorth()
    pcall(function()
        local c=LP.Character
        if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0) end
    end)
end

local function startAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end
    State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local c=LP.Character
        if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart")
        local hum2=c:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd=State.getAutoPathSpeed()
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(AP.L1.X,root.Position.Y,AP.L1.Z)
            if (tgt-root.Position).Magnitude<1 then
                State.autoLeftPhase=2
                local d=(AP.L2-root.Position)
                local mv=Vector3.new(d.X,0,d.Z).Unit
                hum2:Move(mv,false)
                root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
                return
            end
            local d=(AP.L1-root.Position)
            local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false)
            root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(AP.L2.X,root.Position.Y,AP.L2.Z)
            if (tgt-root.Position).Magnitude<1 then
                hum2:Move(Vector3.zero,false)
                root.AssemblyLinearVelocity=Vector3.zero
                State.autoLeftEnabled=false
                if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
                State.autoLeftPhase=1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                faceSouth()
                return
            end
            local d=(AP.L2-root.Position)
            local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false)
            root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
    State.autoLeftPhase=1
    local c=LP.Character
    if c then
        local hum2=c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:Move(Vector3.zero,false) end
    end
end

local function startAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect() end
    State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local c=LP.Character
        if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart")
        local hum2=c:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd=State.getAutoPathSpeed()
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(AP.R1.X,root.Position.Y,AP.R1.Z)
            if (tgt-root.Position).Magnitude<1 then
                State.autoRightPhase=2
                local d=(AP.R2-root.Position)
                local mv=Vector3.new(d.X,0,d.Z).Unit
                hum2:Move(mv,false)
                root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
                return
            end
            local d=(AP.R1-root.Position)
            local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false)
            root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(AP.R2.X,root.Position.Y,AP.R2.Z)
            if (tgt-root.Position).Magnitude<1 then
                hum2:Move(Vector3.zero,false)
                root.AssemblyLinearVelocity=Vector3.zero
                State.autoRightEnabled=false
                if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
                State.autoRightPhase=1
                if autoRightSetVisual then autoRightSetVisual(false) end
                faceNorth()
                return
            end
            local d=(AP.R2-root.Position)
            local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false)
            root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
    State.autoRightPhase=1
    local c=LP.Character
    if c then
        local hum2=c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:Move(Vector3.zero,false) end
    end
end

local antiRagdollConn = nil

local function resetAntiRagdollCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint")
                or obj:IsA("BallSocketConstraint")
                or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end
        workspace.CurrentCamera.CameraSubject = hum
        local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModule = playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local success, module = pcall(require, controlModule)
                if success and module and module.Enable then module:Enable() end
            end
        end
    end)
end

startAntiRagdoll = function()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead
            or hum.PlatformStand == true
            or hum.Sit == true then
            resetAntiRagdollCharacter(char)
        end
    end)
end

stopAntiRagdoll = function()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local ContentProvider = game:GetService("ContentProvider")
local Anims = {
    idle1 = "rbxassetid://133806214992291",
    idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309",
    run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985",
    fall = "rbxassetid://116936326516985",
    climb = "rbxassetid://116936326516985",
    swim = "rbxassetid://116936326516985",
    swimidle = "rbxassetid://116936326516985"
}

task.spawn(function() pcall(function() ContentProvider:PreloadAsync(Anims) end) end)

local function applyAnimPack(char)
    local a = char:FindFirstChild("Animate")
    if not a then return end
    local function s(o, id) if o then o.AnimationId = id end end
    s(a.idle and a.idle.Animation1, Anims.idle1)
    s(a.idle and a.idle.Animation2, Anims.idle2)
    s(a.walk and a.walk.WalkAnim, Anims.walk)
    s(a.run and a.run.RunAnim, Anims.run)
    s(a.jump and a.jump.JumpAnim, Anims.jump)
    s(a.fall and a.fall.FallAnim, Anims.fall)
    s(a.climb and a.climb.ClimbAnim, Anims.climb)
    s(a.swim and a.swim.Swim, Anims.swim)
    s(a.swimidle and a.swimidle.SwimIdle, Anims.swimidle)
end

local animHBConn

function startNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
    local char = LP.Character
    if char then
        applyAnimPack(char)
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
            for _, t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop(0) end
            hum2:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    local _animLast = 0
    animHBConn = RunService.Heartbeat:Connect(function()
        if not State.nuevaAnimacionEnabled then return end
        local _now = os.clock()
        if _now - _animLast < 0.25 then return end
        _animLast = _now
        local c = LP.Character
        if c then applyAnimPack(c) end
    end)
end

function stopNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
end

local applyFPSBoost
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v)
        pcall(function()
            if v:IsA("Model") then
                v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled
                v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
            elseif v:IsA("MeshPart") then
                v.CastShadow=false
                v.DoubleSided=false
                v.RenderFidelity=Enum.RenderFidelity.Performance
            elseif v:IsA("BasePart") then
                v.CastShadow=false
                v.Material=Enum.Material.Plastic
                v.Reflectance=0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency=1
            elseif v:IsA("SpecialMesh") then
                v.TextureId=""
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled=false
            elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then
                v:Destroy()
            elseif v:IsA("Attachment") then
                v.Visible=false
            end
        end)
    end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=game:GetService("Lighting")
        for _,v in pairs(L:GetDescendants()) do
            pcall(function()
                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then
                    v:Destroy()
                end
            end)
        end
        pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
        L.GlobalShadows=false
        L.FogEnd=9e9
        L.Brightness=0
        local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then
            pcall(function() sethiddenproperty(ter,"Decoration",false) end)
            ter.WaterReflectance=0
            ter.WaterTransparency=0.7
            ter.WaterWaveSize=0
            ter.WaterWaveSpeed=0
        end
    end)
    if not State._fpsBoostConn then
        State._fpsBoostConn = workspace.DescendantAdded:Connect(function(v)
            if State.fpsBoostEnabled then pO(v) end
        end)
    end
end

repeat task.wait() until game:IsLoaded()

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS               = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Stats             = game:GetService("Stats")
local CoreGui           = game:GetService("CoreGui")
local LP                = Players.LocalPlayer
local PlayerGui         = LP:WaitForChild("PlayerGui")
local plots             = workspace:WaitForChild("Plots")
local autoStealEnabled  = true
local selectedStealMode = "Normal"
local autoStealRadius   = 62
_G.AceStealRadii        = _G.AceStealRadii or { Normal = 62, Semi = 9 }

local CONFIG = {
    AUTO_STEAL_ENABLED = true,
    HOLD_MIN   = 1.3,
    HOLD_MAX   = 2.6,
    ENTRY_DELAY= 0.3,
    COOLDOWN   = 0.05,
    STEAL_RANGE= 62,
    PRIME_RANGE= 80,
    STEAL_MODE = "Normal",
}

_G.__AceDuelsSetupStealBar = function()
    local existing = PlayerGui:FindFirstChild("StealBarGui")
    if existing then existing:Destroy() end
    local existingCore = CoreGui:FindFirstChild("StealBarGui")
    if existingCore then existingCore:Destroy() end
    local oldCandy = CoreGui:FindFirstChild("CandyStealBar")
    if oldCandy then oldCandy:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "StealBarGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui
    if State and State.registerThemeRoot then State.registerThemeRoot(gui) end
    local function drag(frame)
        local dragging, dragStart, startPos = false, nil, nil
        frame.InputBegan:Connect(function(input)
            if _G.AceGuiLocked == true then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos  = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if State and State.requestPositionSave then pcall(State.requestPositionSave) end
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                          or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    local pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "StealBar"
    pbFrame.Size = UDim2.new(0, 262, 0, 29)
    pbFrame.Position = UDim2.new(0.5, -131, 1, -70)
    pbFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)
    local STEAL_PURPLE        = Color3.fromRGB(160, 100, 220)
    local STEAL_PURPLE_BRIGHT = Color3.fromRGB(200, 150, 255)
    local STEAL_PURPLE_DIM    = Color3.fromRGB(130, 80, 200)
    local pbSt = Instance.new("UIStroke", pbFrame)
    pbSt.Color = STEAL_PURPLE
    pbSt.Thickness = 1.1
    pbSt.Transparency = 0.25
    drag(pbFrame)
    if State then State.autoStealBarFrame = pbFrame end
    if State then State._setStealBarLocked = function(locked)
        _G.AceGuiLocked = locked and true or false
    end end

    local fillRegion = Instance.new("Frame", pbFrame)
    fillRegion.Size = UDim2.new(0, 148, 1, -8)
    fillRegion.Position = UDim2.new(0, 4, 0, 4)
    fillRegion.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 2
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)
    local fillRegGradient = Instance.new("UIGradient", fillRegion)
    fillRegGradient.Color = ColorSequence.new(Color3.fromRGB(220, 210, 255), Color3.fromRGB(230, 225, 255))
    fillRegGradient.Rotation = 90
    local fillRegStroke = Instance.new("UIStroke", fillRegion)
    fillRegStroke.Color = STEAL_PURPLE
    fillRegStroke.Thickness = 1
    fillRegStroke.Transparency = 0.65
    local progressFill = Instance.new("Frame", fillRegion)
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = STEAL_PURPLE
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 3
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    local fillGradient = Instance.new("UIGradient", progressFill)
    fillGradient.Color = ColorSequence.new(STEAL_PURPLE_BRIGHT, STEAL_PURPLE_DIM)
    fillGradient.Rotation = 90
    local stealLbl = Instance.new("TextLabel", fillRegion)
    stealLbl.Size = UDim2.new(0, 46, 1, 0)
    stealLbl.Position = UDim2.new(0, 6, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "STEAL"
    stealLbl.TextColor3 = Color3.fromRGB(160, 100, 220)
    stealLbl.Font = Enum.Font.GothamSemibold
    stealLbl.TextSize = 11
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left
    stealLbl.ZIndex = 5
    local progressPct = Instance.new("TextLabel", fillRegion)
    progressPct.Size = UDim2.new(0, 46, 1, 0)
    progressPct.Position = UDim2.new(1, -50, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(160, 100, 220)
    progressPct.Font = Enum.Font.GothamSemibold
    progressPct.TextSize = 10
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.ZIndex = 5
    local progressRadLbl = Instance.new("TextLabel", pbFrame)
    progressRadLbl.Size = UDim2.new(0, 76, 1, 0)
    progressRadLbl.Position = UDim2.new(0, 156, 0, 0)
    progressRadLbl.BackgroundTransparency = 1
    progressRadLbl.Text = "0 FPS | 0ms"
    progressRadLbl.TextColor3 = Color3.fromRGB(160, 100, 220)
    progressRadLbl.Font = Enum.Font.GothamSemibold
    progressRadLbl.TextSize = 11
    progressRadLbl.TextXAlignment = Enum.TextXAlignment.Center
    progressRadLbl.ZIndex = 4
    local barState = "IDLE"

    local function setBarState(state)
        barState = state
        if state == "STEALING" then
            TweenService:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 150, 255)}):Play()
            TweenService:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(230, 220, 255)}):Play()
        elseif state == "READY" then
            TweenService:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 150, 255)}):Play()
            TweenService:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(240, 235, 255)}):Play()
            progressPct.Text = "0%"
            progressPct.TextColor3 = Color3.fromRGB(200, 150, 255)
        else
            TweenService:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 150, 220)}):Play()
            TweenService:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(245, 240, 255)}):Play()
            progressPct.Text = "0%"
            progressPct.TextColor3 = Color3.fromRGB(180, 150, 220)
        end
    end

    task.spawn(function()
        local lastFrame = os.clock()
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = os.clock()
            local dt = now - lastFrame
            lastFrame = now
            if dt > 0 then fpsAvg = fpsAvg + ((1/dt) - fpsAvg) * 0.08 end
        end)
        while pbFrame and pbFrame.Parent do
            local ping = 0
            pcall(function()
                local stat = Stats.Network.ServerStatsItem["Data Ping"]
                if stat then ping = tonumber(stat:GetValue()) or 0 end
            end)
            progressRadLbl.Text = string.format("FPS:%d | PING:%dms",
                math.floor(fpsAvg + 0.5), math.floor(ping + 0.5))
            task.wait(0.5)
        end
    end)

    local StealBar = {}
    function StealBar.SetProgress(p)
        p = math.clamp(p, 0, 1)
        progressFill.Size = UDim2.new(p, 0, 1, 0)
        progressPct.Text = math.floor(p * 100 + 0.5) .. "%"
    end
    function StealBar.Reset()
        StealBar.SetProgress(0)
        setBarState("IDLE")
    end
    function StealBar.SetState(state)
        setBarState(state)
    end
    setBarState("IDLE")
    _G.StealBar = StealBar
end

_G.__AceDuelsSetupStealBar()

_G.__AceSetupNormalAutoSteal = function()
    _G.AceNormalSteal = _G.AceNormalSteal or {
        enabled = false, radius = 62, duration = 1.3,
        animals = {}, promptCache = {}, internalCache = {},
        scannerStarted = false, scanning = false,
        isStealing = false, stealConn = nil,
        refreshThread = nil, lastSteal = 0, cooldown = 0.08,
    }
    if _G.AceNormalSteal.stealConn then
        pcall(function() _G.AceNormalSteal.stealConn:Disconnect() end)
        _G.AceNormalSteal.stealConn = nil
    end
    _G.AceNormalSteal.enabled = false
    _G.AceNormalSteal.isStealing = false

    local function barProgress(p)
        p = math.clamp(tonumber(p) or 0, 0, 1)
        pcall(function()
            if _G.StealBar then
                _G.StealBar.SetState("STEALING")
                _G.StealBar.SetProgress(p)
            end
        end)
    end

    local function resetBar()
        pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
    end

    local function getRoot()
        local char = LP.Character
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    end

    local function isMyBase(plotName)
        local plot = plots and plots:FindFirstChild(plotName)
        if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        local yourBase = sign and sign:FindFirstChild("YourBase")
        return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
    end

    local function scanPlotsN()
        local a = _G.AceNormalSteal
        a.animals = {}
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") and not isMyBase(plot.Name) then
                local podiums = plot:FindFirstChild("AnimalPodiums")
                if podiums then
                    for _, podium in ipairs(podiums:GetChildren()) do
                        if podium:IsA("Model") then
                            local base = podium:FindFirstChild("Base")
                            local spawn = base and base:FindFirstChild("Spawn")
                            if spawn then
                                table.insert(a.animals, {
                                    plot = plot.Name,
                                    slot = podium.Name,
                                    worldPosition = spawn.Position,
                                    uid = plot.Name .. "_" .. podium.Name,
                                })
                            end
                        end
                    end
                end
            end
        end
    end

    local function ensureScanner()
        local a = _G.AceNormalSteal
        if a.scannerStarted then return end
        a.scannerStarted = true
        task.spawn(function()
            task.wait(1)
            while _G.AceNormalSteal do
                if _G.AceNormalSteal.enabled then pcall(scanPlotsN) end
                task.wait(3)
            end
        end)
    end

    local function findPrompt(data)
        if not data then return nil end
        local a = _G.AceNormalSteal
        local cached = a.promptCache[data.uid]
        if cached and cached.Parent then return cached end
        local plot = plots and plots:FindFirstChild(data.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        local podium = podiums and podiums:FindFirstChild(data.slot)
        local base = podium and podium:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        local attach = spawn and spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, prompt in ipairs(attach:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                a.promptCache[data.uid] = prompt
                return prompt
            end
        end
        return nil
    end

    local function cacheCallbacks(prompt)
        local a = _G.AceNormalSteal
        if a.internalCache[prompt] then return end
        local data = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if type(conn.Function) == "function" then table.insert(data.hold, conn.Function) end
                end
                for _, conn in ipairs(getconnections(prompt.Triggered)) do
                    if type(conn.Function) == "function" then table.insert(data.trigger, conn.Function) end
                end
            end
        end)
        if #data.hold > 0 or #data.trigger > 0 then
            a.internalCache[prompt] = data
        end
    end

    local function doSteal(prompt)
        local a = _G.AceNormalSteal
        if not prompt or not prompt.Parent or a.isStealing then return end
        if tick() - (a.lastSteal or 0) < (a.cooldown or 0.08) then return end
        cacheCallbacks(prompt)
        local data = a.internalCache[prompt]
        if not data or not data.ready then return end
        data.ready = false
        a.isStealing = true
        a.lastSteal = tick()
        pcall(function() if _G.StealBar then _G.StealBar.SetState("STEALING") end end)
        task.spawn(function()
            if #data.hold > 0 then
                for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
            end
            local startTime = tick()
            local dur = 1.3
            a.duration = dur
            while a.enabled and selectedStealMode == "Normal" and tick() - startTime < dur do
                barProgress((tick() - startTime) / dur)
                task.wait(0.02)
            end
            if not a.enabled or selectedStealMode ~= "Normal" then
                data.ready = true
                a.isStealing = false
                resetBar()
                return
            end
            barProgress(1)
            if #data.trigger > 0 then
                for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
            end
            pcall(function()
                if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end
            end)
            task.wait(0.12)
            data.ready = true
            a.isStealing = false
            resetBar()
        end)
    end

    local function nearestAnimal()
        local a = _G.AceNormalSteal
        local root = getRoot()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, data in ipairs(a.animals) do
            if data.worldPosition and not isMyBase(data.plot) then
                local dist = (root.Position - data.worldPosition).Magnitude
                if dist < bestDist then best, bestDist = data, dist end
            end
        end
        if best and bestDist <= (tonumber(a.radius) or 62) then return best end
        return nil
    end

    _G.AceNormalAutoStealSetRadius = function(v)
        _G.AceNormalSteal.radius = tonumber(v) or _G.AceNormalSteal.radius or 62
    end

    _G.AceNormalAutoStealStop = function()
        local a = _G.AceNormalSteal
        a.enabled = false
        a.isStealing = false
        if a.stealConn then a.stealConn:Disconnect(); a.stealConn = nil end
        resetBar()
    end

    _G.AceNormalAutoStealStart = function()
        local a = _G.AceNormalSteal
        a.radius = tonumber(autoStealRadius) or a.radius or 62
        a.duration = 1.3
        a.enabled = true
        ensureScanner()
        pcall(scanPlotsN)
        if a.stealConn then a.stealConn:Disconnect(); a.stealConn = nil end
        local _stealLast = 0
        a.stealConn = RunService.Heartbeat:Connect(function()
            if not a.enabled then return end
            local _now = os.clock()
            if _now - _stealLast < 0.1 then return end
            _stealLast = _now
            if selectedStealMode ~= "Normal" then _G.AceNormalAutoStealStop(); return end
            if a.isStealing then return end
            local target = nearestAnimal()
            if not target then return end
            local prompt = findPrompt(target)
            if prompt then doSteal(prompt) end
        end)
    end

    _G.AceNormalAutoStealSync = function()
        if selectedStealMode == "Normal" and autoStealEnabled then
            _G.AceNormalAutoStealStart()
        else
            _G.AceNormalAutoStealStop()
        end
    end
end

_G.__AceSetupNormalAutoSteal()

_G.__AceSetupSemiAutoSteal = function()
    _G.AceSemiSteal = _G.AceSemiSteal or {}
    local A = _G.AceSemiSteal
    if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
    A.enabled = false
    A.holdMin = 1.3
    A.holdMax = 2.6
    A.entryDelay = 0.3
    A.cooldown = 0.05
    A.primeRange = 80
    A.radius = tonumber(autoStealRadius) or 10
    A.plotSync = A.plotSync or {caches = {}, connections = {}}
    A.animals = A.animals or {}
    A.promptCache = A.promptCache or {}
    A.internalCache = A.internalCache or {}
    A.state = A.state or {active=false, startTime=0, phase="idle", label="", lastResult="", lastResultTime=0}

    local function barSet(p, label)
        pcall(function()
            if _G.StealBar then
                _G.StealBar.SetState(label or "STEALING")
                _G.StealBar.SetProgress(math.clamp(tonumber(p) or 0, 0, 1))
            end
        end)
    end

    local function barReset()
        pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
    end

    local function rootPart()
        local char = LP.Character
        return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
    end

    local function splitPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
        return out
    end

    local function resolvePath(path, root)
        local current, parent, key = root, nil, nil
        for _, part in ipairs(splitPath(path)) do
            parent = current
            key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end

    local function applySyncDiff(channelName, packet)
        local cache = A.plotSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolvePath(path, cache)
        if action == "Changed" then
            if parent ~= nil then parent[key] = a end
        elseif action == "ArrayInsert" then
            if current ~= nil then table.insert(current, b, a) end
        elseif action == "ArrayRemoved" then
            if current ~= nil then table.remove(current, b) end
        elseif action == "DictionaryInsert" then
            if current ~= nil then current[b] = a end
        elseif action == "DictionaryRemoved" then
            if current ~= nil then current[b] = nil end
        end
    end

    local function attachPlotChannel(remote)
        if A.plotSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not plots:FindFirstChild(channelName) then return end
        if A.requestData and A.plotSync.caches[channelName] == nil then
            local ok, data = pcall(function() return A.requestData:InvokeServer(channelName) end)
            A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
        elseif A.plotSync.caches[channelName] == nil then
            A.plotSync.caches[channelName] = {}
        end
        A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
        end)
    end

    local function ensureSync()
        if A.syncReady then return true end
        local ok = pcall(function()
            A.packages = ReplicatedStorage:WaitForChild("Packages", 10)
            A.datas    = ReplicatedStorage:WaitForChild("Datas", 10)
            if not (A.packages and A.datas) then return end
            A.animalsData = require(A.datas:WaitForChild("Animals", 10))
            local sync = A.packages:WaitForChild("Synchronizer", 10)
            A.channelFolder = sync:WaitForChild("Channel", 10)
            A.routeRemote   = sync:FindFirstChild("CommunicationRoute", 10)
            A.requestData   = sync:FindFirstChild("RequestData")
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then attachPlotChannel(child) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then attachPlotChannel(child) end
            end)
            A.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, channelName = action[1], tostring(action[2])
                    if plots:FindFirstChild(channelName) then
                        if kind == "ListenerAdded" then
                            local remote = A.channelFolder:FindFirstChild(channelName)
                            if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(A.plotSync.connections) do
                                if tostring(remote.Name) == channelName then
                                    pcall(function() conn:Disconnect() end)
                                    A.plotSync.connections[remote] = nil
                                    A.plotSync.caches[channelName] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            A.syncReady = true
        end)
        return ok and A.syncReady == true
    end

    local function getPlotOwner(plot)
        local sign = plot and plot:FindFirstChild("PlotSign")
        local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label or label.Text == "Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end

    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot then return false end
        local plot = plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        local owner = getPlotOwner(plot)
        return owner == LP.DisplayName or owner == LP.Name
    end

    local function podiumFor(animalData)
        local plot = plots:FindFirstChild(animalData.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        return podiums and podiums:FindFirstChild(animalData.slot) or nil
    end

    local function animalPos(animalData)
        local podium = podiumFor(animalData)
        return podium and podium:GetPivot().Position or nil
    end

    local function distToAnimal(animalData)
        local root = rootPart()
        local pos = animalPos(animalData)
        return root and pos and (root.Position - pos).Magnitude or math.huge
    end

    local function findPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = A.promptCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local podium = podiumFor(animalData)
        local base = podium and podium:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        local attach = spawn and spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, prompt in ipairs(attach:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                A.promptCache[animalData.uid] = prompt
                return prompt
            end
        end
        return nil
    end

    local function scanAllPlots()
        if not ensureSync() then return 0 end
        local newCache = {}
        for _, plot in ipairs(plots:GetChildren()) do
            local cache = A.plotSync.caches[plot.Name]
            local animalList = cache and cache.AnimalList
            if typeof(animalList) == "table" then
                for slot, animalData in pairs(animalList) do
                    if type(animalData) == "table" then
                        local animalName = animalData.Index
                        local info = A.animalsData and A.animalsData[animalName]
                        if info then
                            table.insert(newCache, {
                                name = info.DisplayName or animalName,
                                plot = plot.Name,
                                slot = tostring(slot),
                                uid  = plot.Name .. "_" .. tostring(slot),
                            })
                        end
                    end
                end
            end
        end
        A.animals = newCache
        return #newCache
    end

    local function pickClosest()
        local root = rootPart()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(A.animals) do
            if not isMyBaseAnimal(animalData) then
                local pos = animalPos(animalData)
                local dist = pos and (root.Position - pos).Magnitude or math.huge
                if dist <= (A.primeRange or 80) and dist < bestDist then
                    best, bestDist = animalData, dist
                end
            end
        end
        return best
    end

    local function buildCallbacks(prompt)
        if A.internalCache[prompt] then return end
        local data = {holdCallbacks={}, triggerCallbacks={}, ready=true}
        local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if okHold and type(holds) == "table" then
            for _, conn in ipairs(holds) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
        if okTrigger and type(triggers) == "table" then
            for _, conn in ipairs(triggers) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
    end

    local function executeSemi(prompt, animalData)
        if not prompt or not prompt.Parent or not animalData then return false end
        buildCallbacks(prompt)
        local data = A.internalCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        A.state.active = true
        A.state.startTime = tick()
        A.state.phase = "holding"
        A.state.label = animalData.name or "Animal"
        task.spawn(function()
            local startTime = A.state.startTime
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
            while A.enabled and selectedStealMode == "Semi" and tick() - startTime < (A.holdMin or 1.3) do
                barSet((tick() - startTime) / (A.holdMax or 2.6), "STEALING")
                task.wait()
            end
            A.state.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 10)
            local fired = false
            while A.enabled and selectedStealMode == "Semi" and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > (A.holdMax or 2.6) then break end
                barSet(elapsed / (A.holdMax or 2.6), "STEALING")
                if distToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                    if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
                    if A.enabled and selectedStealMode == "Semi" then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                        pcall(function()
                            if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end
                        end)
                        fired = true
                    end
                    break
                end
                task.wait()
            end
            A.state.lastResult = fired and ("Stole " .. tostring(A.state.label))
                                      or  ("Missed window: " .. tostring(A.state.label))
            A.state.active = false
            A.state.phase = "idle"
            A.state.lastResultTime = tick()
            if fired then barSet(1, "STEALING") end
            task.wait(A.cooldown or 0.05)
            data.ready = true
            barReset()
        end)
        return true
    end

    local function ensureScanThread()
        if A.scanThread then return end
        A.scanThread = task.spawn(function()
            while _G.AceSemiSteal do
                if A.enabled or selectedStealMode == "Semi" then pcall(scanAllPlots) end
                task.wait(5)
            end
        end)
    end

    _G.AceSemiAutoStealSetRadius = function(v)
        local n = tonumber(v)
        if n then A.radius = n end
    end

    _G.AceSemiAutoStealStop = function()
        A.enabled = false
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.state.active = false
        A.state.phase = "idle"
        barReset()
    end

    _G.AceSemiAutoStealStart = function()
        A.radius = tonumber(autoStealRadius) or A.radius or 10
        A.enabled = true
        ensureSync()
        ensureScanThread()
        pcall(scanAllPlots)
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        local _semiLast = 0
        A.conn = RunService.Heartbeat:Connect(function()
            if not A.enabled then return end
            local _now = os.clock()
            if _now - _semiLast < 0.1 then return end
            _semiLast = _now
            if selectedStealMode ~= "Semi" then _G.AceSemiAutoStealStop(); return end
            if A.state.active then return end
            local target = pickClosest()
            if not target then return end
            local prompt = findPromptForAnimal(target)
            if prompt then executeSemi(prompt, target) end
        end)
    end

    _G.AceSemiAutoStealSync = function()
        if selectedStealMode == "Semi" and autoStealEnabled then
            _G.AceSemiAutoStealStart()
        else
            _G.AceSemiAutoStealStop()
        end
    end
end

_G.__AceSetupSemiAutoSteal()

_G.AceAutoStealSync = function()
    if not autoStealEnabled then
        if _G.AceNormalAutoStealStop then _G.AceNormalAutoStealStop() end
        if _G.AceSemiAutoStealStop   then _G.AceSemiAutoStealStop()   end
        return
    end
    if selectedStealMode == "Normal" then
        if _G.AceSemiAutoStealStop   then _G.AceSemiAutoStealStop()   end
        if _G.AceNormalAutoStealSync then _G.AceNormalAutoStealSync() end
    elseif selectedStealMode == "Semi" then
        if _G.AceNormalAutoStealStop then _G.AceNormalAutoStealStop() end
        if _G.AceSemiAutoStealSync   then _G.AceSemiAutoStealSync()   end
    end
end

local function setMode(mode)
    if mode ~= "Normal" and mode ~= "Semi" then mode = "Normal" end
    selectedStealMode = mode
    CONFIG.STEAL_MODE = mode
    autoStealRadius = _G.AceStealRadii[mode] or autoStealRadius
    CONFIG.STEAL_RANGE = autoStealRadius
    if Steal then Steal.StealRadius = autoStealRadius end
    _G.AceAutoStealSync()
end

local function setRadius(v)
    v = tonumber(v)
    if not v then return end
    autoStealRadius = v
    _G.AceStealRadii[selectedStealMode] = v
    CONFIG.STEAL_RANGE = v
    if Steal then Steal.StealRadius = v end
    if _G.AceNormalAutoStealSetRadius then _G.AceNormalAutoStealSetRadius(v) end
    if _G.AceSemiAutoStealSetRadius   then _G.AceSemiAutoStealSetRadius(v)   end
end

function startAutoSteal()
    autoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    if Steal then Steal.AutoStealEnabled = true end
    _G.AceAutoStealSync()
end

function stopAutoSteal()
    autoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    if Steal then Steal.AutoStealEnabled = false end
    if _G.AceNormalAutoStealStop then _G.AceNormalAutoStealStop() end
    if _G.AceSemiAutoStealStop   then _G.AceSemiAutoStealStop()   end
end

do
    local oldCtl = PlayerGui:FindFirstChild("AceStealControls")
    if oldCtl then oldCtl:Destroy() end
    pcall(function() makeSecHeader("Mechanics", "Auto Steal") end)
    local semiSetVisual
    local autoSetVisual
    autoSetVisual = rowToggle("Mechanics", "Auto Steal", "Ace steal engine", autoStealEnabled and true or false, function(on)
        if on then startAutoSteal() else stopAutoSteal() end
    end)
    semiSetVisual = rowToggle("Mechanics", "Semi Steal Mode", "Off = Normal · On = Semi", selectedStealMode == "Semi", function(on)
        setMode(on and "Semi" or "Normal")
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    State._semiSetVisual = semiSetVisual
    rowInput("Mechanics", "Steal Radius", "Detection range", autoStealRadius, function(v)
        v = tonumber(v)
        if v and v >= 0.5 and v <= 300 then setRadius(v); if State.requestConfigSave then State.requestConfigSave() end end
    end)
end

selectedStealMode = "Normal"
autoStealRadius   = _G.AceStealRadii.Normal or 62
CONFIG.STEAL_RANGE = autoStealRadius
if Steal then Steal.StealRadius = autoStealRadius; Steal.AutoStealEnabled = true end
autoStealEnabled = true
_G.AceAutoStealSync()

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end
end)

saveConfig = function(btn)
    if State._configLoading or not State._configLoaded then
        State._saveAfterLoad = true
        return false
    end
    if State._configLoadFailed and not btn then
        return false
    end
    if State._saveInProgress then
        State._saveQueued = true
        return false
    end
    State._saveInProgress = true

    local function keySnapshot(entry)
        return {
            kb = entry and entry.kb and entry.kb.Name or nil,
            gp = entry and entry.gp and entry.gp.Name or nil,
        }
    end

    local function positionSnapshot(guiObject)
        if not guiObject then return nil end
        local ok, p = pcall(function() return guiObject.Position end)
        if not ok or not p then return nil end
        return {
            xs = p.X.Scale,
            xo = p.X.Offset,
            ys = p.Y.Scale,
            yo = p.Y.Offset,
        }
    end

    local savedStealRadius = Steal.StealRadius
    local savedAutoStealEnabled = Steal.AutoStealEnabled
    if CONFIG then
        if type(CONFIG.STEAL_RANGE) == "number" then
            savedStealRadius = CONFIG.STEAL_RANGE
        end
        if CONFIG.AUTO_STEAL_ENABLED ~= nil then savedAutoStealEnabled = CONFIG.AUTO_STEAL_ENABLED == true end
    end

    local cfg = {
        configVersion = 8,
        normalSpeed = NS,
        carrySpeed = CS,
        profileLaggerNormalSpeed = State.profileLaggerNormalSpeed,
        profileLaggerCarrySpeed = State.profileLaggerCarrySpeed,
        speedProfile = State.speedProfile,
        laggerSpeed = LS,
        laggerCarrySpeed = LS2,
        stealRadius = savedStealRadius,
        stealDuration = Steal.StealDuration,
        uiScale = uiScaleValue,
        backgroundAssetId = State.backgroundAssetId,
        buttonsSize = State.buttonsSizeValue,
        buttonsShape = State.buttonsShape,
        uiLocked = uiLocked,
        guiVisible = State.guiVisible,
        autoLeftKey = keySnapshot(KB.AutoLeft),
        autoRightKey = keySnapshot(KB.AutoRight),
        dropKey = keySnapshot(KB.Drop),
        tpDownKey = keySnapshot(KB.TPDown),
        autoBatKey = keySnapshot(KB.AutoBat),
        autoBatV2Key = keySnapshot(KB.AutoBatV2),
        instaResetKey = keySnapshot(KB.InstaReset),
        tpBatKey = keySnapshot(KB.TPBat),
        speedKey = keySnapshot(KB.Speed),
        laggerKey = keySnapshot(KB.Lagger),
        guiHideKey = keySnapshot(KB.GuiHide),
        infJump = State.infJumpEnabled,
        antiRagdoll = State.antiRagdollEnabled,
        fpsBoost = State.fpsBoostEnabled,
        medusaCounter = State.medusaCounterEnabled,
        medusaReset = State.medusaResetEnabled,
        batCounter = State.batCounterEnabled,
        autoStealEnabled = savedAutoStealEnabled,
        stealMode = selectedStealMode,
        stealRadiusNormal = _G.AceStealRadii and _G.AceStealRadii.Normal or nil,
        stealRadiusSemi   = _G.AceStealRadii and _G.AceStealRadii.Semi   or nil,
        unwalkEnabled = State.unwalkEnabled,
        desyncEnabled = State.desyncEnabled,
        autoSwing = State.autoSwingEnabled,
        autoBatToggled = State.autoBatToggled,
        autoBatV2Toggled = State.autoBatV2Enabled,
        tpBatEnabled = State.tpBatEnabled,
        tpBatVersion = (State.tpBatVersion == 2) and 2 or 1,
        stretchRez = State.stretchRezEnabled,
        removeAccessories = State.removeAccessoriesEnabled,
        antiLag = State.antiLagEnabled,
        hitboxFollower = State.hitboxFollowerEnabled,
        darkMode = State.darkModeEnabled,
        skyStyle = State.skyStyle,
        noIntro = State.noIntro == true,
        introEnabled = State.noIntro ~= true,
        selectedIntroMusic = State.selectedIntroMusic,
        autoTPDown = autoTPDownEnabled,
        autoTPDownHeight = autoTPDownHeight,
        speedToggled = State.speedToggled,
        laggerMode = State.laggerToggled,
        laggerPhase = laggerPhase,
        linieEnabled = State.linieEnabled,
        autoMedusaEnabled = MedusaConfig and MedusaConfig.Enabled or nil,
        medusaRadius = MedusaConfig and MedusaConfig.Radius or nil,
        medusaDelay = MedusaConfig and MedusaConfig.Delay or nil,
        instaReset = State.instaResetEnabled,
        instaResetVisible = btnInstaReset and btnInstaReset.Visible or nil,
        hideButtons = State.hideButtonsEnabled,
        panelPos = positionSnapshot(MobilePanel),
        mobileButtonPositions = (function()
            local positions = {}
            for name, mobileBtn in pairs(mobileButtonsByName) do
                positions[name] = positionSnapshot(mobileBtn)
            end
            return positions
        end)(),
        mainPos = positionSnapshot(main),
        miniPos = positionSnapshot(mini),
        pbPos = positionSnapshot(pbFrame),
        batV2Pos = positionSnapshot(btnBatV2),
        instaResetPos = positionSnapshot(btnInstaReset),
        autoStealBarPos = positionSnapshot(State.autoStealBarFrame),
    }

    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(cfg)
    end)

    local saved = false
    if encodeOk and encoded then
        if not btn and encoded == State._lastConfigJson then
            State._configDirty = false
            State._saveInProgress = false
            State._saveQueued = false
            return true
        end
        local atomicOk, atomicResult, atomicErr = pcall(function()
            return State._atomicJsonSave(
                CONFIG_FILE,
                State._configBackupFile,
                State._configTempFile,
                encoded
            )
        end)
        saved = atomicOk and atomicResult == true
        if saved then
            State._lastConfigJson = encoded
            State._lastSaveError = nil
            State._configLoadFailed = false
            State._allowInitialConfigCreation = false
            if State.savePositionBackup then pcall(State.savePositionBackup) end
            State._configDirty = false
        else
            State._lastConfigJson = nil
            State._lastSaveError = tostring((atomicOk and atomicErr) or atomicResult or "No se pudo escribir la configuración")
            warn("[PHANTOM AUTO SAVE] " .. State._lastSaveError)
        end
    else
        State._lastSaveError = "No se pudo convertir la configuración a JSON"
    end

    State._saveInProgress = false
    if btn and btn.Parent then
        local previousText = btn.Text
        btn.Text = saved and "Saved!" or "Failed!"
        task.delay(1.5, function()
            if btn and btn.Parent then btn.Text = previousText end
        end)
    end

    if State._saveQueued then
        State._saveQueued = false
        if State.requestConfigSave then State.requestConfigSave() end
    end
    return saved
end

loadConfig = function()
    local function readConfigFile(path)
        local decoded, raw = State._readValidJsonFile(path)
        if type(decoded) ~= "table" then return nil, raw end
        return decoded, raw
    end

    local mainCfg, mainRaw = readConfigFile(CONFIG_FILE)
    local tempCfg, tempRaw = readConfigFile(State._configTempFile)
    local backupCfg, backupRaw = readConfigFile(State._configBackupFile)
    local legacyCfg, legacyRaw = readConfigFile(State._legacyConfigFile)
    local legacyTempCfg, legacyTempRaw = readConfigFile(State._legacyConfigTempFile)
    local legacyBackupCfg, legacyBackupRaw = readConfigFile(State._legacyConfigBackupFile)

    local cfg, raw = nil, nil
    local loadedFromBackup = false
    local loadedFromLegacy = false
    local loadedFromTemp = false

    if type(tempCfg) == "table" and (type(mainCfg) ~= "table" or tempRaw ~= mainRaw) then
        cfg, raw = tempCfg, tempRaw
        loadedFromTemp = true
    elseif type(mainCfg) == "table" then
        cfg, raw = mainCfg, mainRaw
    elseif type(backupCfg) == "table" then
        cfg, raw = backupCfg, backupRaw
        loadedFromBackup = true
    elseif type(legacyTempCfg) == "table" and (type(legacyCfg) ~= "table" or legacyTempRaw ~= legacyRaw) then
        cfg, raw = legacyTempCfg, legacyTempRaw
        loadedFromLegacy = true
        loadedFromTemp = true
    elseif type(legacyCfg) == "table" then
        cfg, raw = legacyCfg, legacyRaw
        loadedFromLegacy = true
    elseif type(legacyBackupCfg) == "table" then
        cfg, raw = legacyBackupCfg, legacyBackupRaw
        loadedFromLegacy = true
        loadedFromBackup = true
    end

    local hadAnyConfigFile = false
    for _, path in ipairs({
        CONFIG_FILE,
        State._configTempFile,
        State._configBackupFile,
        State._legacyConfigFile,
        State._legacyConfigTempFile,
        State._legacyConfigBackupFile,
    }) do
        local exists = false
        pcall(function() exists = _isfile(path) end)
        if exists then hadAnyConfigFile = true break end
    end

    if not cfg then
        State._configLoaded = true
        State._configLoadFailed = hadAnyConfigFile
        State._allowInitialConfigCreation = not hadAnyConfigFile
        State._saveAfterLoad = false
        State._lastSaveError = hadAnyConfigFile and "Se encontraron configuraciones dañadas; no se sobrescribieron" or nil
        if State.loadPositionBackup then pcall(State.loadPositionBackup) end
        return false
    end

    State._configLoading = true
    State._configLoadFailed = false
    State._allowInitialConfigCreation = false

    local applyOk = pcall(function()
        if type(cfg.normalSpeed) == "number" then
            NS = cfg.normalSpeed
            if normalBox then normalBox.Text = tostring(NS) end
        end
        if type(cfg.carrySpeed) == "number" then
            CS = cfg.carrySpeed
            if carryBox then carryBox.Text = tostring(CS) end
        end
        if type(cfg.profileLaggerNormalSpeed) == "number" then
            State.profileLaggerNormalSpeed = cfg.profileLaggerNormalSpeed
        end
        if type(cfg.profileLaggerCarrySpeed) == "number" then
            State.profileLaggerCarrySpeed = cfg.profileLaggerCarrySpeed
        end
        if type(cfg.laggerSpeed) == "number" then
            LS = cfg.laggerSpeed
            if laggerBox then laggerBox.Text = tostring(LS) end
        end
        if type(cfg.laggerCarrySpeed) == "number" then
            LS2 = cfg.laggerCarrySpeed
            if laggerBox2 then laggerBox2.Text = tostring(LS2) end
        end
        if type(cfg.uiScale) == "number" then
            uiScaleValue = math.clamp(math.floor(cfg.uiScale + 0.5), 50, 150)
            if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
        end
        if cfg.backgroundAssetId and State.applyBackgroundImage then
            State.applyBackgroundImage(cfg.backgroundAssetId, false)
        elseif State.applyBackgroundImage then
            State.applyBackgroundImage(State.backgroundAssetId, false)
        end
        if type(cfg.buttonsSize) == "number" then
            State.buttonsSizeValue = math.clamp(math.floor(cfg.buttonsSize + 0.5), 0, 100)
        end
        if cfg.buttonsShape ~= nil then State.buttonsShape = normalizeMobileButtonsShape(cfg.buttonsShape) end
        applyMobileButtonsSize(State.buttonsSizeValue)
        if buttonsSizeBox then buttonsSizeBox.Text = tostring(State.buttonsSizeValue) end
        if State._buttonsShapeSelectorVisual then State._buttonsShapeSelectorVisual(State.buttonsShape, false) end
        if cfg.uiLocked ~= nil then
            uiLocked = cfg.uiLocked == true
            _G.AceGuiLocked = uiLocked
            if State._setStealBarLocked then State._setStealBarLocked(uiLocked) end
            if setLockUIVisual then setLockUIVisual(uiLocked) end
        end
        if cfg.guiVisible ~= nil then
            State.guiVisible = cfg.guiVisible == true
            if main then main.Visible = State.guiVisible end
            if mini then mini.Visible = not State.guiVisible end
        end
        if cfg.selectedIntroMusic ~= nil then
            State.selectedIntroMusic = cfg.selectedIntroMusic
        end
        if cfg.noIntro ~= nil then
            State.noIntro = cfg.noIntro == true
        elseif cfg.introEnabled ~= nil then
            State.noIntro = cfg.introEnabled ~= true
        end
        State.introEnabled = not State.noIntro
        if setNoIntroToggle then setNoIntroToggle(State.noIntro, false) end
        if type(cfg.autoTPDownHeight) == "number" then autoTPDownHeight = math.clamp(cfg.autoTPDownHeight, 0, 500) end
        if cfg.autoTPDown ~= nil then
            autoTPDownEnabled = cfg.autoTPDown == true
            if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
            if autoTPDownEnabled then startAutoTPDown() else stopAutoTPDown() end
        end
        local savedRadius = cfg.stealRadius or cfg.grabRadius
        if savedRadius == 61 or savedRadius == 63 then savedRadius = 10 end
        if type(savedRadius) == "number" then
            Steal.StealRadius = savedRadius
            if progressRadLbl then progressRadLbl.Text = "Radius: " .. tostring(savedRadius) end
            if radValBtn then radValBtn.Text = tostring(savedRadius) end
            if radBox then radBox.Text = tostring(savedRadius) end
            if CONFIG then CONFIG.STEAL_RANGE = savedRadius end
        end
        if type(cfg.stealDuration) == "number" then
            Steal.StealDuration = cfg.stealDuration
            if durValBtn then durValBtn.Text = tostring(Steal.StealDuration) end
        end
        if MedusaConfig then
            if type(cfg.medusaRadius) == "number" then
                MedusaConfig.Radius = cfg.medusaRadius
                if MedusaConfig.RadiusPart then
                    MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius * 2, MedusaConfig.Radius * 2)
                end
            end
            if type(cfg.medusaDelay) == "number" then
                MedusaConfig.Delay = cfg.medusaDelay
            end
        end

        local function loadKey(entry, data)
            if not entry or type(data) ~= "table" then return end
            entry.kb = nil
            entry.gp = nil
            if data.kb and Enum.KeyCode[data.kb] then entry.kb = Enum.KeyCode[data.kb] end
            if data.gp and Enum.KeyCode[data.gp] then entry.gp = Enum.KeyCode[data.gp] end
            if State._bindButtons and State._bindButtons[entry] then
                State._bindButtons[entry].Text =
                    entry.gp and ("GP:" .. entry.gp.Name)
                    or (entry.kb and entry.kb.Name or "None")
            end
        end

        loadKey(KB.AutoLeft, cfg.autoLeftKey)
        loadKey(KB.AutoRight, cfg.autoRightKey)
        loadKey(KB.Drop, cfg.dropKey)
        loadKey(KB.TPDown, cfg.tpDownKey)
        loadKey(KB.AutoBat, cfg.autoBatKey)
        loadKey(KB.AutoBatV2, cfg.autoBatV2Key)
        loadKey(KB.InstaReset, cfg.instaResetKey)
        loadKey(KB.TPBat, cfg.tpBatKey)
        loadKey(KB.Speed, cfg.speedKey)
        loadKey(KB.Lagger, cfg.laggerKey)
        loadKey(KB.GuiHide, cfg.guiHideKey)

        if cfg.infJump ~= nil then
            State.infJumpEnabled = cfg.infJump == true
            if setInfJump then setInfJump(State.infJumpEnabled) end
        end
        if cfg.antiRagdoll ~= nil then
            State.antiRagdollEnabled = cfg.antiRagdoll == true
            if setAntiRag then setAntiRag(State.antiRagdollEnabled) end
            if State.antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        if cfg.fpsBoost ~= nil then
            State.fpsBoostEnabled = cfg.fpsBoost == true
            if setFps then setFps(State.fpsBoostEnabled) end
            if State.fpsBoostEnabled then pcall(applyFPSBoost) end
        end
        if cfg.medusaCounter ~= nil then
            State.medusaCounterEnabled = cfg.medusaCounter == true
            if setMedusaCounter then setMedusaCounter(State.medusaCounterEnabled) end
        end
        if cfg.medusaReset ~= nil then
            State.medusaResetEnabled = cfg.medusaReset == true
            if setMedusaReset then setMedusaReset(State.medusaResetEnabled) end
        end
        refreshMedusaHooks()
        if cfg.batCounter ~= nil then
            State.batCounterEnabled = cfg.batCounter == true
            if setBatCounter then setBatCounter(State.batCounterEnabled) end
            if State.batCounterEnabled then startBatCounter() else stopBatCounter() end
        end
        if cfg.autoStealEnabled ~= nil then
            local autoStealOn = cfg.autoStealEnabled == true
            Steal.AutoStealEnabled = autoStealOn
            if CONFIG then CONFIG.AUTO_STEAL_ENABLED = autoStealOn end
            if setAutoGrab then setAutoGrab(autoStealOn) end
            if autoStealOn then pcall(startAutoSteal) else pcall(stopAutoSteal) end
        end
        if _G.AceStealRadii then
            if type(cfg.stealRadiusNormal) == "number" then _G.AceStealRadii.Normal = cfg.stealRadiusNormal end
            if type(cfg.stealRadiusSemi)   == "number" then _G.AceStealRadii.Semi   = cfg.stealRadiusSemi   end
        end
        if type(cfg.stealMode) == "string" and (cfg.stealMode == "Normal" or cfg.stealMode == "Semi") then
            selectedStealMode = cfg.stealMode
            if CONFIG then CONFIG.STEAL_MODE = cfg.stealMode end
            if _G.AceStealRadii and _G.AceStealRadii[cfg.stealMode] then
                autoStealRadius = _G.AceStealRadii[cfg.stealMode]
                if CONFIG then CONFIG.STEAL_RANGE = autoStealRadius end
                if Steal then Steal.StealRadius = autoStealRadius end
            end
            if semiSetVisual then pcall(semiSetVisual, cfg.stealMode == "Semi")
            elseif State._semiSetVisual then pcall(State._semiSetVisual, cfg.stealMode == "Semi") end
            if _G.AceAutoStealSync then pcall(_G.AceAutoStealSync) end
        end
        if cfg.autoSwing ~= nil then
            State.autoSwingEnabled = cfg.autoSwing == true
            if setAutoSwingVisual then setAutoSwingVisual(State.autoSwingEnabled) end
        end
        if cfg.unwalkEnabled ~= nil then
            State.unwalkEnabled = cfg.unwalkEnabled == true
            if setUnwalkToggle then setUnwalkToggle(State.unwalkEnabled) end
            if State.unwalkEnabled then startUnwalk() else stopUnwalk() end
        end
        if cfg.stretchRez ~= nil and setStretchRez then
            State.stretchRezEnabled = cfg.stretchRez == true
            setStretchRez(State.stretchRezEnabled)
        end
        if cfg.removeAccessories ~= nil and setRemoveAccessories then
            State.removeAccessoriesEnabled = cfg.removeAccessories == true
            setRemoveAccessories(State.removeAccessoriesEnabled)
        end
        if cfg.antiLag ~= nil and setAntiLag then
            State.antiLagEnabled = cfg.antiLag == true
            setAntiLag(State.antiLagEnabled)
        end
        if cfg.hitboxFollower ~= nil or cfg.hitboxFollowerEnabled ~= nil then
            State.hitboxFollowerEnabled = (cfg.hitboxFollower ~= nil and cfg.hitboxFollower == true)
                or (cfg.hitboxFollower == nil and cfg.hitboxFollowerEnabled == true)
            if State._setHitboxFollower then State._setHitboxFollower(State.hitboxFollowerEnabled) end
            if State.hitboxFollowerEnabled then
                State._hitboxFollower.start()
            else
                State._hitboxFollower.stop()
            end
        end
        if cfg.skyStyle ~= nil and setSkyStyle then
            setSkyStyle(cfg.skyStyle)
        elseif cfg.darkMode ~= nil and setDarkMode then
            setDarkMode(cfg.darkMode == true)
        end
        if cfg.desyncEnabled ~= nil then
            State.desyncEnabled = cfg.desyncEnabled == true
        end
        if cfg.linieEnabled ~= nil then
            State.linieEnabled = cfg.linieEnabled == true
            if setLinieVisual then setLinieVisual(State.linieEnabled) end
        end
        if cfg.autoMedusaEnabled ~= nil then
            if MedusaConfig then MedusaConfig.Enabled = cfg.autoMedusaEnabled == true end
            if setAutoMedusaVisual then setAutoMedusaVisual(cfg.autoMedusaEnabled == true) end
        end
        local savedInstaReset = cfg.instaReset
        if savedInstaReset == nil then savedInstaReset = cfg.instaResetEnabled end
        if savedInstaReset ~= nil then
            State.instaResetEnabled = savedInstaReset == true
            if setInstaToggleVisual then setInstaToggleVisual(State.instaResetEnabled) end
        end
        if cfg.hideButtons ~= nil then
            State.hideButtonsEnabled = cfg.hideButtons == true
            if setHideButtonsVisual then setHideButtonsVisual(State.hideButtonsEnabled) end
            local visible = not State.hideButtonsEnabled
            if MobilePanel then MobilePanel.Visible = visible end
            for _, mobileBtn in pairs(mobileButtonsByName) do
                if mobileBtn then mobileBtn.Visible = visible end
            end
            if btnBatV2 then btnBatV2.Visible = visible end
            if btnInstaReset then btnInstaReset.Visible = visible and (cfg.instaResetVisible ~= false) end
            if pbFrame then pbFrame.Visible = visible end
        elseif cfg.instaResetVisible ~= nil and btnInstaReset then
            btnInstaReset.Visible = cfg.instaResetVisible == true
        end
        State.speedProfile = "Normal"
        if normalBox then normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS) end
        if carryBox then carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS) end
        State.speedToggled = cfg.speedToggled == true
        State.laggerToggled = cfg.laggerMode == true
        laggerPhase = tonumber(cfg.laggerPhase) or (State.laggerToggled and 1 or 0)
        laggerPhase = math.clamp(math.floor(laggerPhase), 0, 2)
        if State.laggerToggled then
            State.speedToggled = false
        elseif laggerPhase ~= 0 then
            laggerPhase = 0
        end
        if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
        if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
        if modeValLbl then
            modeValLbl.Text =
                laggerPhase == 2 and "Lagger Carry"
                or (State.laggerToggled and "Lagger")
                or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"))
                or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal")
        end
        State._setTPBatEnabled(cfg.tpBatEnabled == true)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(State.tpBatEnabled) end
        State.tpBatVersion = (tonumber(cfg.tpBatVersion) == 2) and 2 or 1
        State._tpBatV2HittingCooldown = false
        State._tpBatHittingCooldown = false
        if State._tpBatVersionSetVisual then State._tpBatVersionSetVisual(State.tpBatVersion == 2) end
        local autoBatV1 = cfg.autoBatToggled == true
        local autoBatV2 = cfg.autoBatV2Toggled == true
        if autoBatV1 then autoBatV2 = false end
        State.autoBatToggled = autoBatV1
        State.autoBatV2Enabled = autoBatV2
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
        if State.autoBatToggled then
            task.defer(startBatAimbot)
        elseif State.autoBatV2Enabled then
            task.defer(startBatAimbotV2)
        else
            pcall(stopBatAimbot)
            if stopBatAimbotV2 then pcall(stopBatAimbotV2) end
        end

        local function restorePosition(guiObject, data)
            if guiObject and type(data) == "table" and data.xs ~= nil then
                guiObject.Position = UDim2.new(
                    data.xs,
                    data.xo or 0,
                    data.ys or 0,
                    data.yo or 0
                )
            end
        end

        local function restoreSavedPositions()
            restorePosition(main, cfg.mainPos)
            restorePosition(mini, cfg.miniPos)
            restorePosition(MobilePanel, cfg.panelPos)
            if type(cfg.mobileButtonPositions) == "table" then
                for name, positionData in pairs(cfg.mobileButtonPositions) do
                    restorePosition(mobileButtonsByName[name], positionData)
                end
            end
            restorePosition(pbFrame, cfg.pbPos)
            restorePosition(btnBatV2, cfg.batV2Pos)
            restorePosition(btnInstaReset, cfg.instaResetPos)
            restorePosition(State.autoStealBarFrame, cfg.autoStealBarPos)
        end

        restoreSavedPositions()
        task.delay(0.7, restoreSavedPositions)
        task.delay(1.35, function()
            restoreSavedPositions()
            task.defer(function()
                if State.loadPositionBackup and not State._positionDirty then pcall(State.loadPositionBackup) end
            end)
        end)
    end)

    State._configLoading = false
    State._configLoaded = true
    State._configLoadFailed = not applyOk
    if applyOk then
        State._lastConfigJson = raw
        State._lastSaveError = nil
        State._configDirty = false
    else
        State._lastSaveError = "La configuración se leyó, pero no se pudo aplicar; no será sobrescrita"
    end

    local pendingSave = State._saveAfterLoad
    State._saveAfterLoad = false
    if applyOk and (loadedFromBackup or loadedFromLegacy or loadedFromTemp or pendingSave) then
        if loadedFromBackup or loadedFromLegacy or loadedFromTemp then State._lastConfigJson = nil end
        State.requestConfigSave()
    end
    return applyOk
end

local h,hrp,speedLbl

local function setupChar(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5)
    hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end
    local head=char:FindFirstChild("Head")
    if head then
        local oldBB=head:FindFirstChild("PHANTOMBB")
        if oldBB then oldBB:Destroy() end
        speedLbl=nil
    end
    if State.unwalkEnabled then task.wait(0.3); startUnwalk() end
    stopAntiRagdoll()
    if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end
    if State.medusaCounterEnabled or State.medusaResetEnabled then setupMedusaCounter(char) end
    if State.autoBatToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
    if Steal.AutoStealEnabled then pcall(stopAutoSteal); task.wait(0.5); pcall(startAutoSteal) end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local c=LP.Character
    if not c then return end
    local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)

RunService.RenderStepped:Connect(function()
    local _char = LP.Character
    if not _char then return end
    local _hum = _char:FindFirstChildOfClass("Humanoid")
    local _root = _char:FindFirstChild("HumanoidRootPart")
    if not _hum or not _root then return end
    h, hrp = _hum, _root
    if State._tpInProgress then State.destroySpeedVelocity(); return end
    if State.isRagdollSpeed(_hum) then State.lastMoveDir = Vector3.new(0,0,0); State.destroySpeedVelocity(); return end
    if State.autoBatToggled or State.autoLeftEnabled or State.autoRightEnabled then
        State.destroySpeedVelocity()
    else
        local linearVelocity = State._speedLinearVelocity
        if not linearVelocity or not State._speedAttachment or State._speedAttachment.Parent ~= _root then
            linearVelocity = State.setupSpeedVelocity(_root)
        end
        local md = _hum.MoveDirection
        local spd = State.getActiveMoveSpeed()
        local dir = nil
        if md.Magnitude > 0 then
            State.lastMoveDir = md
            dir = md
        elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then dir = State.lastMoveDir; break end
            end
        end
        if linearVelocity then
            if dir then
                local flat = Vector3.new(dir.X, 0, dir.Z)
                if flat.Magnitude > 0 then
                    flat = flat.Unit
                    linearVelocity.VectorVelocity = Vector3.new(flat.X * spd, 0, flat.Z * spd)
                else
                    linearVelocity.VectorVelocity = Vector3.zero
                end
            else
                linearVelocity.VectorVelocity = Vector3.zero
            end
        end
    end
    local _now = os.clock()
    if _now - (State._speedLblLast or 0) >= 0.08 then
        State._speedLblLast = _now
        if speedLbl and speedLbl.Parent then
            local v = hrp.Velocity
            speedLbl.Text = string.format("%.1f", Vector3.new(v.X, 0, v.Z).Magnitude)
        end
    end
end)

UIS.InputBegan:Connect(function(inp,gp)
    if _anyKeyListening then return end
    if gp and string.sub(inp.UserInputType.Name, 1, 7) ~= "Gamepad" then return end
    local kc=inp.KeyCode
    if kc==Enum.KeyCode.Unknown then return end
    if kbMatch(KB.Speed,kc) then
        State.laggerToggled = false
        laggerPhase = 0
        State.speedToggled = not State.speedToggled
        if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
    elseif kbMatch(KB.AutoLeft,kc) then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if State.autoLeftEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
    elseif kbMatch(KB.AutoRight,kc) then
        State.autoRightEnabled=not State.autoRightEnabled
        if State.autoRightEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
    elseif kbMatch(KB.Drop,kc) then
        if not State.dropActive then task.spawn(runDrop) end
    elseif kbMatch(KB.TPDown,kc) then
        task.spawn(doTpDown)
    elseif kbMatch(KB.Lagger,kc) then
        if laggerPhase == 1 then
            laggerPhase = 2
            State.laggerToggled = true
            State.speedToggled = false
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 2" end
        else
            laggerPhase = 1
            State.laggerToggled = true
            State.speedToggled = false
            if mobileSpeedSetActive then mobileSpeedSetActive(false) end
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 1" end
        end
    elseif kbMatch(KB.AutoBat,kc) then
        State.autoBatToggled=not State.autoBatToggled
        if State.autoBatToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            pcall(startBatAimbot)
        else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
    elseif kbMatch(KB.AutoBatV2,kc) then
        State.autoBatV2Enabled = not State.autoBatV2Enabled
        if State.autoBatV2Enabled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            if startBatAimbotV2 then startBatAimbotV2() end
        else
            if stopBatAimbotV2 then stopBatAimbotV2() end
        end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
    elseif kbMatch(KB.TPBat,kc) then
        State._setTPBatEnabled(not State.tpBatEnabled)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(State.tpBatEnabled) end
        if State.requestConfigSave then State.requestConfigSave() end
    elseif kbMatch(KB.InstaReset,kc) then
        task.spawn(normalReset)
        if btnInstaReset and btnInstaReset.Parent then
            btnInstaReset:SetAttribute("PurpleFlash", true)
            task.delay(0.35, function()
                if btnInstaReset and btnInstaReset.Parent then btnInstaReset:SetAttribute("PurpleFlash", false) end
            end)
        end
        if setInstaToggleVisual then
            setInstaToggleVisual(true)
            task.delay(0.2, function() if setInstaToggleVisual then setInstaToggleVisual(false) end end)
        end
    elseif kbMatch(KB.GuiHide,kc) then
        State.guiVisible=not State.guiVisible
        pcall(function() main.Visible=State.guiVisible end)
        pcall(function() mini.Visible=not State.guiVisible end)
    end
    if State.requestConfigSave then State.requestConfigSave() end
end)

loadPresetsFile()
task.spawn(function()
    local lastPresetName = loadLastPresetName()
    if lastPresetName and lastPresetName ~= "" then
        for _, preset in ipairs(Presets) do
            if preset.name == lastPresetName then
                pcall(function() applyPreset(preset.data) end)
                break
            end
        end
    end
    task.wait(0.2)
    local loaded = loadConfig()
    task.wait(0.5)
    if not loaded and State._allowInitialConfigCreation then pcall(saveConfig) end
end)

Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if parent == nil and State._configLoaded and not State._configLoadFailed then
        if State._configDirty then pcall(saveConfig) end
        if State._positionDirty and State.savePositionBackup then pcall(State.savePositionBackup) end
    end
end)

pcall(function()
    game:BindToClose(function()
        if State._configLoaded and not State._configLoadFailed then
            if State._configDirty then pcall(saveConfig) end
            if State._positionDirty and State.savePositionBackup then pcall(State.savePositionBackup) end
        end
    end)
end)

print("[ Phantom Duels] Loaded!")
end)()
end)()
