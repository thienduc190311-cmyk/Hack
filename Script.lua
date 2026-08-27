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
    ShowFOV = true,
    Smoothness = 0.2 -- Độ mượt khi nhắm (0.1 -> 1)
}

-- 1. Tạo Vòng Tròn FOV ở Tâm Màn Hình (Sử dụng Drawing API)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = Settings.FOV
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Thickness = 1.5
FOVCircle.Visible = Settings.ShowFOV

-- Cập nhật vị trí tâm vòng tròn khi đổi kích thước màn hình
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

-- 2. Tạo GUI UI
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
Title.Text = "  Aimbot Settings"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Nút Thu Gọn / Mở Rộng GUI
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

-- Hàm tiện ích tạo nút bấm
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

-- Các nút chức năng
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

-- Nút chỉnh kích thước vòng FOV (+ / -)
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
FOVPlus.Size = UDim2.new(0.2, 0, 1, 0)
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

-- 3. Logic Kiểm Tra Vật Chắn (Wall Check)
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

-- 4. Logic Tìm Mục Tiêu
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

-- 5. Vòng Lặp Aimbot
RunService.RenderStepped:Connect(function()
    if Settings.Enabled then
        local target = GetClosestTarget()
        if target then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Smoothness)
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
