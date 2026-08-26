-- Tải thư viện OrionLib (Đã sửa lỗi thêm dấu ngoặc kép cho URL)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Tạo cửa sổ chính
local Window = OrionLib:MakeWindow({
    Name = "My First Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "OrionTest"
})

-- Tạo Tab "Tính năng"
local MainTab = Window:MakeTab({
    Name = "Tính năng",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Tạo nút bấm tăng tốc độ (Có tính năng tự động áp dụng lại khi nhân vật hồi sinh)
MainTab:AddButton({
    Name = "Tăng tốc độ chạy (Speed: 50)",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
        end
    end
})

-- Khởi tạo Menu
OrionLib:Init()
