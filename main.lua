-- Rivals Skin Changer (내가 직접 제작한 버전 - 로드string 없음)
print("🔥 Rivals Skin Changer (직접 제작) 시작... 클라이언트만 적용됩니다.")

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Library = nil
task.wait(3)  -- 로딩 대기

-- Library 찾기 (여러 경로 시도)
pcall(function() Library = require(RS:WaitForChild("Library", 8)) end)
if not Library then pcall(function() Library = require(RS:FindFirstChild("Library", true)) end) end
if not Library then pcall(function() Library = require(RS.Library) end) end

if not Library or not Library.Save then
    warn("❌ Library를 찾지 못했습니다. 게임을 완전히 재접속 후 다시 실행해보세요.")
    return
end

print("✅ Library 찾음! Save.Get 후킹 시작...")

local OriginalGet = Library.Save.Get

-- 올스킨 + Equipped 강제 설정 (핵심)
Library.Save.Get = function(...)
    local data = OriginalGet(...)
    if typeof(data) == "table" then
        -- 모든 코스메틱 강제 보유
        local tables = {"OwnedSkins", "OwnedWraps", "OwnedCharms", "OwnedItems", "OwnedFinishers", "OwnedCosmetics", "OwnedEmotes"}
        for _, tblName in ipairs(tables) do
            if not data[tblName] then data[tblName] = {} end
            for key in pairs(data[tblName]) do
                data[tblName][key] = true
            end
        end
        
        -- 현재 착용 스킨 강제 변경
        data.Equipped = data.Equipped or {}
        data.Equipped.Skin = "Pro"   -- 기본값, GUI에서 바꿀 수 있음
        print("✅ 올스킨 적용됨 (클라이언트 측)")
    end
    return data
end

-- ==================== 커스텀 GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MySkinChanger"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
Title.Text = "Rivals Skin Changer (직접 제작)"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local SkinLabel = Instance.new("TextLabel")
SkinLabel.Size = UDim2.new(1, -20, 0, 30)
SkinLabel.Position = UDim2.new(0, 10, 0, 60)
SkinLabel.BackgroundTransparency = 1
SkinLabel.Text = "적용할 스킨 이름:"
SkinLabel.TextColor3 = Color3.new(1,1,1)
SkinLabel.TextXAlignment = Enum.TextXAlignment.Left
SkinLabel.Parent = MainFrame

local SkinInput = Instance.new("TextBox")
SkinInput.Size = UDim2.new(1, -20, 0, 45)
SkinInput.Position = UDim2.new(0, 10, 0, 95)
SkinInput.PlaceholderText = "Pro, Gold, Neon, Dragon, Galaxy..."
SkinInput.Text = "Pro"
SkinInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
SkinInput.TextColor3 = Color3.new(1,1,1)
SkinInput.Parent = MainFrame

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1, -20, 0, 60)
ApplyBtn.Position = UDim2.new(0, 10, 0, 160)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
ApplyBtn.Text = "스킨 강제 적용"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.TextScaled = true
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.Parent = MainFrame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 80)
Status.Position = UDim2.new(0, 10, 0, 230)
Status.BackgroundTransparency = 1
Status.Text = "상태: 대기 중"
Status.TextColor3 = Color3.new(1,1,1)
Status.TextScaled = true
Status.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 80, 0, 30)
CloseBtn.Position = UDim2.new(1, -90, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "닫기"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = MainFrame

-- 적용 버튼
ApplyBtn.MouseButton1Click:Connect(function()
    local skinName = SkinInput.Text
    if skinName == "" then skinName = "Pro" end
    
    -- Equipped 강제 변경
    local success, data = pcall(function() return Library.Save.Get() end)
    if success and data and data.Equipped then
        data.Equipped.Skin = skinName
    end
    
    Status.Text = "✅ " .. skinName .. " 스킨 적용 시도됨!"
    print("🎉 " .. skinName .. " 스킨을 강제 적용했습니다.")
    
    -- ViewModel 시각 효과 (무기 들고 있을 때)
    task.spawn(function()
        task.wait(0.5)
        local char = LocalPlayer.Character
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    local vm = tool:FindFirstChild("ViewModel") 
                    if vm then
                        for _, part in ipairs(vm:GetDescendants()) do
                            if part:IsA("MeshPart") or part:IsA("Part") then
                                part.Transparency = 0
                            end
                        end
                    end
                end
            end
        end
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("🎉 Skin Changer GUI 생성 완료!")
print("   스킨 이름을 입력하고 '스킨 강제 적용' 버튼을 누르세요.")
print("   무기를 들고 있으면 시각 효과도 적용됩니다.")
