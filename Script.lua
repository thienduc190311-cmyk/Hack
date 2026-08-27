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
    Smoothness = 0.2 -- Độ mượt khi nhắm (0.1 -> 1)
}

-- Tạo GUI UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Aimbot Settings (Bật/Tắt: K)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Hàm tiện ích tạo nút
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- 1. Nút Bật/Tắt Aimbot
local ToggleBtn = CreateButton("Aimbot: OFF", UDim2.new(0.05, 0, 0.15, 0), function(btn)
    Settings.Enabled = not Settings.Enabled
    btn.Text = Settings.Enabled and "Aimbot: ON" or "Aimbot: OFF"
    btn.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

-- 2. Nút Chọn Vị Trí Aim (Đầu / Thân / Chân)
local PartBtn = CreateButton("Vị Trí: Đầu", UDim2.new(0.05, 0, 0.3, 0), function(btn)
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

-- 3. Nút Team Check
local TeamBtn = CreateButton("Team Check: ON", UDim2.new(0.05, 0, 0.45, 0), function(btn)
    Settings.TeamCheck = not Settings.TeamCheck
    btn.Text = Settings.TeamCheck and "Team Check: ON" or "Team Check: OFF"
end)

-- 4. Nút Wall Check (Nhận diện vật chắn)
local WallBtn = CreateButton("Wall Check: ON", UDim2.new(0.05, 0, 0.6, 0), function(btn)
    Settings.WallCheck = not Settings.WallCheck
    btn.Text = Settings.WallCheck and "Wall Check: ON" or "Wall Check: OFF"
end)

-- Phím tắt bật/tắt ẩn hiện GUI (Phím K)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Hàm kiểm tra vật chắn (Wall Check)
local function IsVisible(targetPart, targetCharacter)
    if not Settings.WallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    -- Bỏ qua bản thân và nhân vật mục tiêu để kiểm tra xem có tường/vật cản ở giữa không
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
    raycastParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, raycastParams)
    -- Nếu không chạm vào gì ở giữa -> Không bị chắn
    return result == nil
end

-- Hàm tìm mục tiêu gần tâm màn hình nhất
local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = Settings.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            -- Kiểm tra máu
            if player.Character.Humanoid.Health > 0 then
                -- Kiểm tra Team Check
                if not Settings.TeamCheck or player.Team ~= LocalPlayer.Team then
                    local targetPart = player.Character:FindFirstChild(Settings.TargetPart)
                    if targetPart then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local mousePos = UserInputService:GetMouseLocation()
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                            -- Kiểm tra khoảng cách nằm trong FOV và không bị tường chắn
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

-- Vòng lặp Aimbot (Chạy mỗi frame)
RunService.RenderStepped:Connect(function()
    if Settings.Enabled then
        local target = GetClosestTarget()
        if target then
            -- Nhắm mượt (Interpolation) vào mục tiêu
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
