local Flux = loadstring(game:HttpGet("https://raw.githubusercontent.com/unn0wnn/Aurax-UI/refs/heads/main/UI.txt"))()

local UI = Flux:Window("All Mountain", "made by sin", Color3.fromRGB(0, 170, 255), Enum.KeyCode.LeftControl)
local Tab = UI:Tab("Mount Salak", "rbxassetid://6035067836")

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = game.CoreGui:WaitForChild("FluxLib"):WaitForChild("MainFrame")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.ZIndex = 999
CloseButton.AutoButtonColor = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = CloseButton

-- Hapus UI total saat tombol X ditekan
CloseButton.MouseButton1Click:Connect(function()
    game.CoreGui:FindFirstChild("FluxLib"):Destroy()
end)

-- Teleport Button
Tab:Button("Camp 1", "teleport to camp 1", function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(800.252197, 885.022644, -1058.712891)
  end)

Tab:Button("Camp 2", "teleport to camp 2", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1355.722778, 1336.950684, -1397.324097)
end)

Tab:Button("Camp 3", "teleport to camp 3", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2209.918701, 1793.022583, -1595.073486)
end)

Tab:Button("Puncak", "teleport to puncak", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2779.777100, 2180.842529, -1832.835327)
end)

Tab:Button("Tp at the starting place", "tp di tempat awal", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-305.540192, -23.424868, -349.523499)
end)

Tab:Button("Remove Credits + EndScreen", "Hapus EndScreen dan credit GUI", function()
    local player = game.Players.LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui")

if not playerGui then
    repeat wait() until player:FindFirstChild("PlayerGui")
    playerGui = player:FindFirstChild("PlayerGui")
end

-- Fungsi untuk mengembalikan kontrol pemain
local function restorePlayerControl()
    -- Kembalikan kamera ke normal
    local cam = workspace.CurrentCamera
    if cam and cam.CameraType ~= Enum.CameraType.Custom then
        cam.CameraType = Enum.CameraType.Custom
    end
    
    -- Pastikan karakter bisa bergerak
    local character = player.Character or player.CharacterAdded:Wait()
    if character then
        -- Pastikan humanoid tidak dalam status ragdoll atau terstun
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Reset semua status yang bisa mencegah pergerakan
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
            
            -- Pastikan tidak dalam freeze state
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            
            -- Coba aktifkan kontrol
            if humanoid.WalkSpeed == 0 then
                -- Restore walkspeed default jika 0
                humanoid.WalkSpeed = 16
            end
            
            if humanoid.JumpPower == 0 then
                -- Restore jumppower default jika 0
                humanoid.JumpPower = 50
            end
        end
        
        -- Periksa jika ada script yang membekukan karakter
        local playerScripts = player:FindFirstChild("PlayerScripts")
        if playerScripts then
            -- Cari script yang mungkin mengontrol status freeze
            for _, script in pairs(playerScripts:GetDescendants()) do
                if script:IsA("LocalScript") and 
                   (script.Name:lower():match("freeze") or 
                    script.Name:lower():match("control") or
                    script.Name:lower():match("disable")) then
                    -- Coba nonaktifkan script yang mencurigakan
                    if script.Enabled then
                        script.Enabled = false
                        print("Disabled potential control-blocking script:", script.Name)
                    end
                end
            end
        end
    end
    
    -- Pastikan GUI kontrol tetap terlihat
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name == "Main" or 
           gui.Name:match("Control") or 
           gui.Name:match("HUD") or
           gui.Name:match("Interface") then
            gui.Enabled = true
        end
    end
    
    print("Player controls restored")
end

-- Fungsi hapus EndScreen dan kembalikan kontrol
local function removeEndScreen()
    local endScreen = playerGui:FindFirstChild("EndScreen")
    if endScreen then
        endScreen:Destroy()
        print("EndScreen removed!")
        restorePlayerControl()
    end
end

-- Jalankan langsung jika sudah ada
removeEndScreen()

-- Pantau EndScreen muncul lagi
playerGui.ChildAdded:Connect(function(child)
    if child.Name == "EndScreen" then
        wait(0.1)
        removeEndScreen()
    end

    -- Tangani credit GUI (yang isinya 2 Frame)
    if child:IsA("ScreenGui") and #child:GetChildren() == 2 then
        -- Kita tidak hapus GUI-nya, tapi sembunyikan saja frame-nya
        for _, frame in ipairs(child:GetChildren()) do
            if frame:IsA("Frame") then
                frame.Visible = false
            end
        end
        
        -- Kembalikan kontrol pemain
        restorePlayerControl()
    end
end)

-- Bersihkan credit GUI yang sudah terlanjur muncul
for _, gui in ipairs(playerGui:GetChildren()) do
    if gui:IsA("ScreenGui") and #gui:GetChildren() == 2 then
        for _, frame in ipairs(gui:GetChildren()) do
            if frame:IsA("Frame") then
                frame.Visible = false
            end
        end
        
        -- Kembalikan kontrol pemain
        restorePlayerControl()
    end
end

-- Tambahkan trigger untuk mengembalikan kontrol
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        print("Manual control restore triggered")
        restorePlayerControl()
    end
end)

-- Coba kembalikan kontrol setelah beberapa detik untuk antisipasi
wait(2)
restorePlayerControl()

-- Dan pantau terus status kontrol setiap beberapa detik
spawn(function()
    while wait(5) do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed == 0 then
                -- Jika walkspeed 0, coba restore kontrol
                restorePlayerControl()
            end
        end
    end
end)

print("Enhanced player control restoration system loaded!")
end)

-- ======= Toggle Auto Heal & Limit Kecepatan Jatuh =======

-- Variabel utama
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- Flag toggle
local autoHealEnabled = false
local velocityLimitEnabled = false

-- Connection references buat disconnect pas toggle dimatiin
local autoHealConn = nil
local velocityConn = nil

-- Fungsi setup character
local function setupChar(char)
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Auto Heal Logic
    if autoHealEnabled and not autoHealConn then
        autoHealConn = hum.HealthChanged:Connect(function(health)
            if health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
                warn("Auto healed fall damage")
            end
        end)
    end

    -- Velocity Limit Logic
    if velocityLimitEnabled and not velocityConn then
        velocityConn = RunService.RenderStepped:Connect(function()
            if hrp.Velocity.Y < -70 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, -5, hrp.Velocity.Z)
            end
        end)
    end
end

-- Handle karakter baru
plr.CharacterAdded:Connect(function(char)
    wait(1)
    setupChar(char)
end)

-- Init jika karakter udah ada
if plr.Character then
    setupChar(plr.Character)
end

-- 🔘 Toggle: Auto Heal
Tab:Toggle("Auto Heal Fall", "Menghindari damage jatuh pakai healing", false, function(state)
    autoHealEnabled = state

    if state then
        if plr.Character then setupChar(plr.Character) end
    else
        if autoHealConn then
            autoHealConn:Disconnect()
            autoHealConn = nil
        end
    end

    print("Auto Heal sekarang:", state)
end)

-- 🔘 Toggle: Batasi Kecepatan Jatuh
Tab:Toggle("Limit Kecepatan Jatuh", "Membatasi kecepatan jatuh agar tidak fatal", false, function(state)
    velocityLimitEnabled = state

    if state then
        if plr.Character then setupChar(plr.Character) end
    else
        if velocityConn then
            velocityConn:Disconnect()
            velocityConn = nil
        end
    end

    print("Limiter jatuh sekarang:", state)
end)

-- ======= MOUNT KERINCI TAB =======
--Mount Kerinci
local Tab = UI:Tab("Mount Kerinci", "rbxassetid://6035067836")

-- Teleport Button
Tab:Button("Camp 1", "teleport to camp 1", function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2052.907471, 1888.997925, -6651.182617)
  end)

  Tab:Button("Camp 2", "teleport to camp 2", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1798.084839, 2020.997925, -7729.108887)
  end)

  Tab:Button("Camp 3", "teleport to camp 3", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1835.022827, 2224.107910, -9526.873047)
  end)

  Tab:Button("Camp 4", "teleport to camp 4", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1577.784180, 2504.997803, -11682.790039)
  end)

  Tab:Button("Camp 5", "teleport to camp 5", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1818.136108, 3100.997803, -13903.663086)
  end)

  Tab:Button("Camp 5", "teleport to camp 6", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1269.170654, 3348.997559, -14574.696289)
  end)

  Tab:Button("Puncak", "teleport to puncak", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1039.600342, 3804.447021, -15465.732422)
  end)


  -- Mount Singgalang
  local Tab = UI:Tab("Mount Singgalang", "rbxassetid://6035067836")

  Tab:Button("Puncak", "teleport to puncak", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5563.346191, 1887.411011, 544.928162)
  end)

-- ======= ESP Tab =======
local Tab = UI:Tab("ESP", "rbxassetid://4483345998")

-- ESP Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local espEnabled = false

-- Get Distance Function
local function getDistance(player)
    local character = player.Character
    local localCharacter = LocalPlayer.Character
    if character and localCharacter and character:FindFirstChild("HumanoidRootPart") and localCharacter:FindFirstChild("HumanoidRootPart") then
        return math.floor((character.HumanoidRootPart.Position - localCharacter.HumanoidRootPart.Position).Magnitude)
    end
    return nil
end

-- Create ESP Highlight
local function createESP(player)
    if player == LocalPlayer or not espEnabled then return end
    if player.Character and not player.Character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.new(1, 1, 1)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end

-- Remove ESP
local function removeESP(player)
    if player.Character and player.Character:FindFirstChild("ESPHighlight") then
        player.Character.ESPHighlight:Destroy()
    end
    local head = player.Character and player.Character:FindFirstChild("Head")
    if head and head:FindFirstChild("ESPNameTag") then
        head.ESPNameTag:Destroy()
    end
end

-- Name + Distance Tag
local function createNameTag(player)
    if player == LocalPlayer or not espEnabled then return end
    local head = player.Character and player.Character:FindFirstChild("Head")
    if head and not head:FindFirstChild("ESPNameTag") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPNameTag"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.SourceSansBold
        label.TextScaled = true
        label.Text = ""
        label.Parent = billboard

        RunService.RenderStepped:Connect(function()
            if espEnabled and player and player.Character and player.Character:FindFirstChild("Head") then
                local distance = getDistance(player)
                label.Text = string.format("%s [%s Studs]", player.Name, distance or "?")
            elseif not espEnabled then
                label.Text = ""
            end
        end)
    end
end

-- ESP Setup untuk setiap player
local function setupESP(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if espEnabled then
            createESP(player)
            createNameTag(player)
        end
    end)
end

-- Toggle ESP dari UI
Tab:Toggle("Aktifkan ESP", "Menampilkan highlight + nama + jarak", false, function(state)
    espEnabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
                createNameTag(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                removeESP(player)
            end
        end
    end
end)

-- Setup untuk player yang sudah ada dan yang baru join
for _, player in pairs(Players:GetPlayers()) do
    setupESP(player)
end
Players.PlayerAdded:Connect(setupESP)

-- SPEED SLIDER
local defaultWalkSpeed = 16 -- nilai default di Roblox

Tab:Slider("Speedhack", "atur speedhack", 0, 100, 50, function(val)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if val == 0 then
            humanoid.WalkSpeed = defaultWalkSpeed
        else
            humanoid.WalkSpeed = val
        end
    end
end)

-- Update otomatis jika karakter respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").WalkSpeed = defaultWalkSpeed
end)

-- FLY TOOLS
Tab:Button("Fly GUI", "buat terbang", function()
    loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)

-- ✅ Tombol Minimize (Draggable & Bisa Sentuh)
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MinimizeGui = Instance.new("ScreenGui")
MinimizeGui.Name = "MinimizeFluxUI"
MinimizeGui.ResetOnSpawn = false
MinimizeGui.Parent = PlayerGui

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 100, 0, 40)
MinimizeButton.Position = UDim2.new(0, 10, 0, 10)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
MinimizeButton.Text = "Toggle UI"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextScaled = true
MinimizeButton.Parent = MinimizeGui
MinimizeButton.Active = true
MinimizeButton.Draggable = true
MinimizeButton.AutoButtonColor = true
MinimizeButton.ZIndex = 999

local UICorner = Instance.new("UICorner", MinimizeButton)
UICorner.CornerRadius = UDim.new(0, 8)

-- Fungsi Toggle UI (hide/show FluxLib)
MinimizeButton.MouseButton1Click:Connect(function()
    local fluxMain = game.CoreGui:FindFirstChild("FluxLib")
    if fluxMain and fluxMain:FindFirstChild("MainFrame") then
        local mainUI = fluxMain.MainFrame
        mainUI.Visible = not mainUI.Visible
    end
end)
