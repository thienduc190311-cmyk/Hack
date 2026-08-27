-- 1. Tải thư viện Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. Tạo Cửa Sổ Chính (Window)
local Window = Rayfield:CreateWindow({
   Name = "My Script",
   LoadingTitle = "Đang xuất....",
   LoadingSubtitle = "by thienduc",
   ConfigurationSaving = { Enabled = false }
})

-- 3. Tạo Tab Chứa Script (Bạn có thể tạo thêm Tab nếu muốn)
local MainTab = Window:CreateTab("Tổng Hợp Script", 4483362458) -- ID Icon

------------------------------------------------------------------
-- 4. THÊM CÁC NÚT CHẠY SCRIPT VÀO ĐÂY
------------------------------------------------------------------

-- Script số 1
MainTab:CreateButton({
   Name = "aimbot mod",
   Callback = function()
       -- Dat script nay trong StarterPlayerScripts hoac StarterGui
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Biến Cấu Hình (Settings)
local Settings = {
    Enabled = false,
    TargetPart = "Head", -- "Head", "HumanoidRootPart" (Thân), "RightLowerLeg" (Chân)
    TeamCheck = true,
    WallCheck = true,
    FOV = 150,
    ShowFOV = true
}

-- 1. Tạo Vòng Tròn FOV ở Tâm Màn Hình (Drawing API)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = Settings.FOV
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 50, 50)
FOVCircle.Thickness = 1.5
FOVCircle.Visible = Settings.ShowFOV

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

-- 2. Tạo Giao Diện GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 310)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.75, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "  Aimbot Settings (Instant)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Nút Thu Gọn / Mở Rộng
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0.25, 0, 0, 30)
MinimizeBtn.Position = UDim2.new(0.75, 0, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = MainFrame

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 230, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 230, 0, 310), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        MinimizeBtn.Text = "-"
    end
end)

local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- Controls
CreateButton("Aimbot: OFF", UDim2.new(0.05, 0, 0.12, 0), function(btn)
    Settings.Enabled = not Settings.Enabled
    btn.Text = Settings.Enabled and "Aimbot: ON" or "Aimbot: OFF"
    btn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

CreateButton("Vị Trí: Đầu", UDim2.new(0.05, 0, 0.23, 0), function(btn)
    if Settings.TargetPart == "Head" then
        Settings.TargetPart = "HumanoidRootPart"
        btn.Text = "Vị Trí: Thân"
    elseif Settings.TargetPart == "HumanoidRootPart" then
        Settings.TargetPart = "RightLowerLeg"
        btn.Text = "Vị Trí: Chân"
    else
        Settings.TargetPart = "Head"
        btn.Text = "Vị Trí: Đầu"
    end
end)

CreateButton("Team Check: ON", UDim2.new(0.05, 0, 0.34, 0), function(btn)
    Settings.TeamCheck = not Settings.TeamCheck
    btn.Text = Settings.TeamCheck and "Team Check: ON" or "Team Check: OFF"
end)

CreateButton("Wall Check: ON", UDim2.new(0.05, 0, 0.45, 0), function(btn)
    Settings.WallCheck = not Settings.WallCheck
    btn.Text = Settings.WallCheck and "Wall Check: ON" or "Wall Check: OFF"
end)

CreateButton("Hiện Vòng FOV: ON", UDim2.new(0.05, 0, 0.56, 0), function(btn)
    Settings.ShowFOV = not Settings.ShowFOV
    FOVCircle.Visible = Settings.ShowFOV
    btn.Text = Settings.ShowFOV and "Hiện Vòng FOV: ON" or "Hiện Vòng FOV: OFF"
end)

-- Tùy chỉnh FOV
local FOVControlFrame = Instance.new("Frame")
FOVControlFrame.Size = UDim2.new(0.9, 0, 0, 28)
FOVControlFrame.Position = UDim2.new(0.05, 0, 0.67, 0)
FOVControlFrame.BackgroundTransparency = 1
FOVControlFrame.Parent = MainFrame

local FOVMinus = Instance.new("TextButton")
FOVMinus.Size = UDim2.new(0.2, 0, 1, 0)
FOVMinus.Position = UDim2.new(0, 0, 0, 0)
FOVMinus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVMinus.Text = "-"
FOVMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVMinus.Parent = FOVControlFrame

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(0.6, 0, 1, 0)
FOVLabel.Position = UDim2.new(0.2, 0, 0, 0)
FOVLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FOVLabel.Text = "Size FOV: " .. Settings.FOV
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.Font = Enum.Font.SourceSans
FOVLabel.TextSize = 12
FOVLabel.Parent = FOVControlFrame

local FOVPlus = Instance.new("TextButton")
FOVPlus.Size = UDim2.new(0.8, 0, 1, 0)
FOVPlus.Position = UDim2.new(0.8, 0, 0, 0)
FOVPlus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVPlus.Text = "+"
FOVPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVPlus.Parent = FOVControlFrame

FOVMinus.MouseButton1Click:Connect(function()
    if Settings.FOV > 30 then
        Settings.FOV = Settings.FOV - 20
        FOVCircle.Radius = Settings.FOV
        FOVLabel.Text = "Size FOV: " .. Settings.FOV
    end
end)

FOVPlus.MouseButton1Click:Connect(function()
    if Settings.FOV < 500 then
        Settings.FOV = Settings.FOV + 20
        FOVCircle.Radius = Settings.FOV
        FOVLabel.Text = "Size FOV: " .. Settings.FOV
    end
end)

-- 3. Wall Check (Kiểm tra vật cản)
local function IsVisible(targetPart, targetCharacter)
    if not Settings.WallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
    raycastParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

-- 4. Tìm mục tiêu trong vòng FOV
local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = Settings.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                if not Settings.TeamCheck or player.Team ~= LocalPlayer.Team then
                    local targetPart = player.Character:FindFirstChild(Settings.TargetPart)
                    if targetPart then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                            if distance < shortestDistance then
                                if IsVisible(targetPart, player.Character) then
                                    shortestDistance = distance
                                    closestPlayer = targetPart
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- 5. Vòng Lặp Aim Tức Thì (Instant Aim / Snap Aim)
RunService.RenderStepped:Connect(function()
    if Settings.Enabled then
        local target = GetClosestTarget()
        if target then
            -- Gán trực tiếp CFrame góc nhìn vào thẳng vị trí mục tiêu ngay lập tức
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)
       print("Đã bật Script 1!")
   end,
})

-- Script số 2 (Ví dụ gọi script khác qua loadstring)
MainTab:CreateButton({
   Name = "infinyty idle",
   Callback = function()
       loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

-- Script số 3
MainTab:CreateButton({
   Name = "hack esp",
   Callback = function()
       _G.FriendColor = Color3.fromRGB(0, 0, 255)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)
_G.UseTeamColor = true

--------------------------------------------------------------------
local Holder = Instance.new("Folder", game.CoreGui)
Holder.Name = "ESP"

local Box = Instance.new("BoxHandleAdornment")
Box.Name = "nilBox"
Box.Size = Vector3.new(1, 2, 1)
Box.Color3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Box.Transparency = 0.7
Box.ZIndex = 0
Box.AlwaysOnTop = false
Box.Visible = false

local NameTag = Instance.new("BillboardGui")
NameTag.Name = "nilNameTag"
NameTag.Enabled = false
NameTag.Size = UDim2.new(0, 200, 0, 50)
NameTag.AlwaysOnTop = true
NameTag.StudsOffset = Vector3.new(0, 1.8, 0)
local Tag = Instance.new("TextLabel", NameTag)
Tag.Name = "Tag"
Tag.BackgroundTransparency = 1
Tag.Position = UDim2.new(0, -50, 0, 0)
Tag.Size = UDim2.new(0, 300, 0, 20)
Tag.TextSize = 15
Tag.TextColor3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Tag.TextStrokeColor3 = Color3.new(0 / 255, 0 / 255, 0 / 255)
Tag.TextStrokeTransparency = 0.4
Tag.Text = "nil"
Tag.Font = Enum.Font.SourceSansBold
Tag.TextScaled = false

local LoadCharacter = function(v)
	repeat wait() until v.Character ~= nil
	v.Character:WaitForChild("Humanoid")
	local vHolder = Holder:FindFirstChild(v.Name)
	vHolder:ClearAllChildren()
	local b = Box:Clone()
	b.Name = v.Name .. "Box"
	b.Adornee = v.Character
	b.Parent = vHolder
	local t = NameTag:Clone()
	t.Name = v.Name .. "NameTag"
	t.Enabled = true
	t.Parent = vHolder
	t.Adornee = v.Character:WaitForChild("Head", 5)
	if not t.Adornee then
		return UnloadCharacter(v)
	end
	t.Tag.Text = v.Name
	b.Color3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
	t.Tag.TextColor3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
	local Update
	local UpdateNameTag = function()
		if not pcall(function()
			v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			local maxh = math.floor(v.Character.Humanoid.MaxHealth)
			local h = math.floor(v.Character.Humanoid.Health)
		end) then
			Update:Disconnect()
		end
	end
	UpdateNameTag()
	Update = v.Character.Humanoid.Changed:Connect(UpdateNameTag)
end

local UnloadCharacter = function(v)
	local vHolder = Holder:FindFirstChild(v.Name)
	if vHolder and (vHolder:FindFirstChild(v.Name .. "Box") ~= nil or vHolder:FindFirstChild(v.Name .. "NameTag") ~= nil) then
		vHolder:ClearAllChildren()
	end
end

local LoadPlayer = function(v)
	local vHolder = Instance.new("Folder", Holder)
	vHolder.Name = v.Name
	v.CharacterAdded:Connect(function()
		pcall(LoadCharacter, v)
	end)
	v.CharacterRemoving:Connect(function()
		pcall(UnloadCharacter, v)
	end)
	v.Changed:Connect(function(prop)
		if prop == "TeamColor" then
			UnloadCharacter(v)
			wait()
			LoadCharacter(v)
		end
	end)
	LoadCharacter(v)
end

local UnloadPlayer = function(v)
	UnloadCharacter(v)
	local vHolder = Holder:FindFirstChild(v.Name)
	if vHolder then
		vHolder:Destroy()
	end
end

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
	spawn(function() pcall(LoadPlayer, v) end)
end

game:GetService("Players").PlayerAdded:Connect(function(v)
	pcall(LoadPlayer, v)
end)

game:GetService("Players").PlayerRemoving:Connect(function(v)
	pcall(UnloadPlayer, v)
end)

game:GetService("Players").LocalPlayer.NameDisplayDistance = 0

if _G.Reantheajfdfjdgs then
    return
end

_G.Reantheajfdfjdgs = ":suifayhgvsdghfsfkajewfrhk321rk213kjrgkhj432rj34f67df"

local players = game:GetService("Players")
local plr = players.LocalPlayer

function esp(target, color)
    if target.Character then
        if not target.Character:FindFirstChild("GetReal") then
            local highlight = Instance.new("Highlight")
            highlight.RobloxLocked = true
            highlight.Name = "GetReal"
            highlight.Adornee = target.Character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = color
            highlight.Parent = target.Character
        else
            target.Character.GetReal.FillColor = color
        end
    end
end

while task.wait() do
    for i, v in pairs(players:GetPlayers()) do
        if v ~= plr then
            esp(v, _G.UseTeamColor and v.TeamColor.Color or ((plr.TeamColor == v.TeamColor) and _G.FriendColor or _G.EnemyColor))
        end
    end
end

   end,
})
TabGames:CreateButton({
   Name = "mở nhạc (gửi mp3 vào disc,copy url rồi dán vào ô 1",
   Callback = function()
       -- Delta Advanced MP3 Player Script with Playlist, Seek, Loop & Minimize
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup UI cũ
if CoreGui:FindFirstChild("AdvancedMP3Player") then
    CoreGui.AdvancedMP3Player:Destroy()
end

-- Sound Instance
local soundInstance = Instance.new("Sound")
soundInstance.Name = "CustomMusicPlayer"
soundInstance.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Biến quản lý danh sách phát (Playlist)
local playlist = {
    {name = "khatri.mp3", url = "https://cdn.discordapp.com/attachments/1542523228986015816/1542523331067121715/vidgap-com-khatri_--music.mp3"}
}
local currentPlayingFile = ""

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedMP3Player"
ScreenGui.Parent = CoreGui

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 360, 0, 420)
Frame.Position = UDim2.new(0.05, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleBar.Parent = Frame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0.03, 0, 0, 0)
Title.Text = "🎵 DELTA MP3 PLAYER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = TitleBar

-- Nút Thu Gọn / Mở Rộng (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 25)
MinBtn.Position = UDim2.new(0.88, 0, 0.15, 0)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn)

-- Nội dung chính (để ẩn đi khi thu gọn)
local ContentHolder = Instance.new("ScrollingFrame")
ContentHolder.Size = UDim2.new(1, 0, 1, -35)
ContentHolder.Position = UDim2.new(0, 0, 0, 35)
ContentHolder.BackgroundTransparency = 1
ContentHolder.CanvasSize = UDim2.new(0, 0, 1.2, 0)
ContentHolder.ScrollBarThickness = 4
ContentHolder.Parent = Frame

-- Input Link URL
local UrlBox = Instance.new("TextBox")
UrlBox.Size = UDim2.new(0.9, 0, 0, 30)
UrlBox.Position = UDim2.new(0.05, 0, 0.02, 0)
UrlBox.PlaceholderText = "Dán Direct MP3 URL..."
UrlBox.Text = ""
UrlBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UrlBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
UrlBox.Parent = ContentHolder
Instance.new("UICorner", UrlBox)

-- Input Tên File
local NameBox = Instance.new("TextBox")
NameBox.Size = UDim2.new(0.9, 0, 0, 30)
NameBox.Position = UDim2.new(0.05, 0, 0.1, 0)
NameBox.PlaceholderText = "Tên file (VD: nhac.mp3)..."
NameBox.Text = "song.mp3"
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
NameBox.Parent = ContentHolder
Instance.new("UICorner", NameBox)

-- Nút Tải Về
local DownloadBtn = Instance.new("TextButton")
DownloadBtn.Size = UDim2.new(0.9, 0, 0, 30)
DownloadBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
DownloadBtn.Text = "📥 TẢI & THÊM VÀO PLAYLIST"
DownloadBtn.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
DownloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownloadBtn.Font = Enum.Font.SourceSansBold
DownloadBtn.Parent = ContentHolder
Instance.new("UICorner", DownloadBtn)

-- Hiển thị bài đang phát
local NowPlaying = Instance.new("TextLabel")
NowPlaying.Size = UDim2.new(0.9, 0, 0, 25)
NowPlaying.Position = UDim2.new(0.05, 0, 0.26, 0)
NowPlaying.Text = "Đang chọn: Chưa có"
NowPlaying.TextColor3 = Color3.fromRGB(46, 204, 113)
NowPlaying.TextXAlignment = Enum.TextXAlignment.Left
NowPlaying.Font = Enum.Font.SourceSansItalic
NowPlaying.BackgroundTransparency = 1
NowPlaying.Parent = ContentHolder

-- Thanh Tua Nhạc (Seek Bar Container)
local SeekBarBg = Instance.new("Frame")
SeekBarBg.Size = UDim2.new(0.9, 0, 0, 12)
SeekBarBg.Position = UDim2.new(0.05, 0, 0.32, 0)
SeekBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SeekBarBg.Parent = ContentHolder
Instance.new("UICorner", SeekBarBg).CornerRadius = UDim.new(1, 0)

local SeekBarFill = Instance.new("Frame")
SeekBarFill.Size = UDim2.new(0, 0, 1, 0)
SeekBarFill.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
SeekBarFill.Parent = SeekBarBg
Instance.new("UICorner", SeekBarFill).CornerRadius = UDim.new(1, 0)

-- Text thời gian (00:00 / 03:30)
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0.9, 0, 0, 20)
TimeLabel.Position = UDim2.new(0.05, 0, 0.36, 0)
TimeLabel.Text = "00:00 / 00:00"
TimeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Font = Enum.Font.SourceSans
TimeLabel.Parent = ContentHolder

-- Các nút điều khiển (Play, Pause, Loop)
local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0.43, 0, 0, 35)
PlayBtn.Position = UDim2.new(0.05, 0, 0.42, 0)
PlayBtn.Text = "▶ PHÁT"
PlayBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
PlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayBtn.Font = Enum.Font.SourceSansBold
PlayBtn.Parent = ContentHolder
Instance.new("UICorner", PlayBtn)

local LoopBtn = Instance.new("TextButton")
LoopBtn.Size = UDim2.new(0.43, 0, 0, 35)
LoopBtn.Position = UDim2.new(0.52, 0, 0.42, 0)
LoopBtn.Text = "🔁 LẶP: TẮT"
LoopBtn.BackgroundColor3 = Color3.fromRGB(127, 140, 141)
LoopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoopBtn.Font = Enum.Font.SourceSansBold
LoopBtn.Parent = ContentHolder
Instance.new("UICorner", LoopBtn)

-- Danh sách phát (Playlist Scroll Frame)
local PlaylistLabel = Instance.new("TextLabel")
PlaylistLabel.Size = UDim2.new(0.9, 0, 0, 25)
PlaylistLabel.Position = UDim2.new(0.05, 0, 0.51, 0)
PlaylistLabel.Text = "📜 DANH SÁCH PHÁT (Bấm để phát):"
PlaylistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlaylistLabel.TextXAlignment = Enum.TextXAlignment.Left
PlaylistLabel.Font = Enum.Font.SourceSansBold
PlaylistLabel.BackgroundTransparency = 1
PlaylistLabel.Parent = ContentHolder

local PlaylistScroll = Instance.new("ScrollingFrame")
PlaylistScroll.Size = UDim2.new(0.9, 0, 0, 140)
PlaylistScroll.Position = UDim2.new(0.05, 0, 0.58, 0)
PlaylistScroll.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
PlaylistScroll.ScrollBarThickness = 4
PlaylistScroll.Parent = ContentHolder
Instance.new("UICorner", PlaylistScroll)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = PlaylistScroll

-- Hàm định dạng thời gian giây -> mm:ss
local function formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d", mins, secs)
end

-- Hàm cập nhật giao diện danh sách phát
local function updatePlaylistUI()
    for _, child in pairs(PlaylistScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for i, item in ipairs(playlist) do
        local songBtn = Instance.new("TextButton")
        songBtn.Size = UDim2.new(1, 0, 0, 30)
        songBtn.Text = "  " .. item.name
        songBtn.TextXAlignment = Enum.TextXAlignment.Left
        songBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        songBtn.BackgroundColor3 = (currentPlayingFile == item.name) and Color3.fromRGB(41, 128, 185) or Color3.fromRGB(45, 45, 55)
        songBtn.Font = Enum.Font.SourceSans
        songBtn.Parent = PlaylistScroll
        Instance.new("UICorner", songBtn)
        
        songBtn.MouseButton1Click:Connect(function()
            if isfile and isfile(item.name) and getcustomasset then
                currentPlayingFile = item.name
                soundInstance.SoundId = getcustomasset(item.name)
                soundInstance:Play()
                PlayBtn.Text = "⏸ DỪNG"
                PlayBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
                NowPlaying.Text = "Đang phát: " .. item.name
                updatePlaylistUI()
            else
                warn("File chưa có trên máy, hãy tải trước!")
            end
        end)
    end
end

-- Xử lý Tải File
DownloadBtn.MouseButton1Click:Connect(function()
    local url = UrlBox.Text
    local fileName = NameBox.Text
    if url == "" or fileName == "" then return end
    
    DownloadBtn.Text = "⏳ ĐANG TẢI..."
    local success, response = pcall(function() return game:HttpGet(url) end)
    
    if success and writefile then
        writefile(fileName, response)
        DownloadBtn.Text = "✅ TẢI THÀNH CÔNG!"
        
        -- Thêm vào playlist nếu chưa có
        local exists = false
        for _, song in ipairs(playlist) do
            if song.name == fileName then exists = true end
        end
        if not exists then
            table.insert(playlist, {name = fileName, url = url})
        end
        updatePlaylistUI()
        
        task.wait(2)
        DownloadBtn.Text = "📥 TẢI & THÊM VÀO PLAYLIST"
    else
        DownloadBtn.Text = "❌ LỖI TẢI FILE!"
        task.wait(2)
        DownloadBtn.Text = "📥 TẢI & THÊM VÀO PLAYLIST"
    end
end)

-- Xử lý Play / Pause
PlayBtn.MouseButton1Click:Connect(function()
    if soundInstance.IsPlaying then
        soundInstance:Pause()
        PlayBtn.Text = "▶ PHÁT"
        PlayBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        if soundInstance.SoundId ~= "" then
            soundInstance:Resume()
            PlayBtn.Text = "⏸ DỪNG"
            PlayBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        end
    end
end)

-- Xử lý Lặp lại (Loop)
local isLooping = false
LoopBtn.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    soundInstance.Looped = isLooping
    if isLooping then
        LoopBtn.Text = "🔁 LẶP: BẬT"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        LoopBtn.Text = "🔁 LẶP: TẮT"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(127, 140, 141)
    end
end)

-- Xử lý Tua nhạc bằng cách bấm vào thanh Seek Bar
SeekBarBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if soundInstance.TimeLength > 0 then
            local pos = math.clamp((input.Position.X - SeekBarBg.AbsolutePosition.X) / SeekBarBg.AbsoluteSize.X, 0, 1)
            soundInstance.TimePosition = pos * soundInstance.TimeLength
        end
    end
end)

-- Cập nhật thanh tua và thời gian liên tục theo bài hát
RunService.RenderStepped:Connect(function()
    if soundInstance.IsPlaying and soundInstance.TimeLength > 0 then
        local progress = soundInstance.TimePosition / soundInstance.TimeLength
        SeekBarFill.Size = UDim2.new(progress, 0, 1, 0)
        TimeLabel.Text = formatTime(soundInstance.TimePosition) .. " / " .. formatTime(soundInstance.TimeLength)
    end
end)

-- Xử lý Thu gọn / Mở rộng GUI
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentHolder.Visible = false
        Frame.Size = UDim2.new(0, 360, 0, 35)
        MinBtn.Text = "+"
    else
        ContentHolder.Visible = true
        Frame.Size = UDim2.new(0, 360, 0, 420)
        MinBtn.Text = "-"
    end
end)

-- Khởi chạy danh sách mẫu ban đầu
updatePlaylistUI()
			
   end,
})
