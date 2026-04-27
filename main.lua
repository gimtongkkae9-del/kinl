-- Rivals 올스킨 초초간단 버전 (Delta용 - Library 강제 찾기)

print("🔧 Rivals 올스킨 테스트 시작...")

local RS = game:GetService("ReplicatedStorage")

-- Library 찾는 여러 방법 시도
local Library = nil

pcall(function()
    Library = require(RS:WaitForChild("Library", 5))  -- 5초 기다림
end)

if not Library then
    pcall(function()
        Library = require(RS.Library)
    end)
end

if not Library then
    warn("❌ Library 찾기 실패! 아래 명령어 콘솔에 복사해서 실행해보고 결과 알려줘")
    print("ReplicatedStorage 내용:")
    for _, v in ipairs(RS:GetChildren()) do
        print(" - " .. v.Name .. " (" .. v.ClassName .. ")")
    end
    return
end

if not Library.Save or not Library.Save.Get then
    warn("❌ Library.Save.Get 함수를 찾을 수 없음")
    return
end

local old = Library.Save.Get

Library.Save.Get = function(...)
    local data = old(...)
    if typeof(data) == "table" then
        local tables = {"OwnedSkins", "OwnedWraps", "OwnedCharms", "OwnedItems", "OwnedFinishers", "OwnedCosmetics"}
        for _, t in ipairs(tables) do
            data[t] = data[t] or {}
            for k in pairs(data[t]) do
                data[t][k] = true
            end
        end
        data.Equipped = data.Equipped or {}
        data.Equipped.Skin = "Pro"
        print("✅ 올스킨 적용 완료! (클라이언트만)")
    end
    return data
end

print("✅ Save.Get 후킹 성공!")

-- GUI 잠금 해제 (간단 버전)
task.spawn(function()
    task.wait(2)
    local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    for _, v in ipairs(pg:GetDescendants()) do
        if (v:IsA("ImageLabel") or v:IsA("ImageButton")) then
            local name = v.Name:lower()
            if name:find("lock") or (v.Image and v.Image:lower():find("lock")) then
                v.Visible = false
            end
        end
        if (v:IsA("TextButton") or v:IsA("ImageButton")) then
            local name = v.Name:lower()
            if name:find("equip") or name:find("buy") or name:find("select") then
                v.Active = true
                v.Interactable = true
            end
        end
    end
    print("🎉 GUI Lock 숨김 완료")
end)

print("🚀 스크립트 실행 끝! 이제 스킨 상점이나 Loadout 열어보세요.")
