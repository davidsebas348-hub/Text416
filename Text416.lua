local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HIGHLIGHT_NAME = "PLAYER_RED_ESP"

if getgenv().PLAYER_ESP_VISIBLE == nil then
    getgenv().PLAYER_ESP_VISIBLE = false
end

local function applyESP(player)
    if player == LocalPlayer then
        return
    end

    local char = player.Character
    if not char then
        return
    end

    local hl = char:FindFirstChild(HIGHLIGHT_NAME)

    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = HIGHLIGHT_NAME
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = Color3.fromRGB(255, 0, 0)
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end

    hl.Enabled = getgenv().PLAYER_ESP_VISIBLE
end

local function updateAll()
    for _, player in pairs(Players:GetPlayers()) do
        applyESP(player)
    end
end

-- toggle
getgenv().PLAYER_ESP_VISIBLE = not getgenv().PLAYER_ESP_VISIBLE

updateAll()

if not getgenv().PLAYER_ESP_CONNECTIONS then
    getgenv().PLAYER_ESP_CONNECTIONS = true

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            applyESP(player)
        end)
    end)

    for _, player in pairs(Players:GetPlayers()) do
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            applyESP(player)
        end)
    end
end
