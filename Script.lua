local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "My First Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- Tạo 1 Tab chính
local MainTab = Window:MakeTab({
	Name = "Tính năng",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Tạo nút bấm tăng tốc độ
MainTab:AddButton({
	Name = "Tăng tốc độ chạy",
	Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
  	end    
})

OrionLib:Init()
