local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HIGHLIGHT_NAME = "PLAYER_RED_ESP"

getgenv().PLAYER_ESP_VISIBLE = not (getgenv().PLAYER_ESP_VISIBLE or false)
getgenv().PLAYER_ESP_LOOP = getgenv().PLAYER_ESP_LOOP or nil

local function hasTool(character)
    for _, obj in ipairs(character:GetChildren()) do
        if obj:IsA("Tool") then
            return true
        end
    end
    return false
end

local function removeESP(player)
    local char = player.Character
    if not char then return end

    local hl = char:FindFirstChild(HIGHLIGHT_NAME)
    if hl then
        hl:Destroy()
    end
end

local function applyESP(player)
    if player == LocalPlayer then
        return
    end

    local char = player.Character
    if not char then
        return
    end

    if not hasTool(char) then
        removeESP(player)
        return
    end

    local hl = char:FindFirstChild(HIGHLIGHT_NAME)

    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = HIGHLIGHT_NAME

        local savedColor = getgenv().CURRENT_ESP_COLOR or Color3.fromRGB(255, 0, 0)

        hl.FillColor = savedColor
        hl.OutlineColor = savedColor
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end

    hl.Enabled = true
end

local function updateAll()
    for _, player in ipairs(Players:GetPlayers()) do
        applyESP(player)
    end
end

-- APAGAR
if not getgenv().PLAYER_ESP_VISIBLE then
    if getgenv().PLAYER_ESP_LOOP then
        task.cancel(getgenv().PLAYER_ESP_LOOP)
        getgenv().PLAYER_ESP_LOOP = nil
    end

    for _, player in ipairs(Players:GetPlayers()) do
        removeESP(player)
    end

    return
end

-- ENCENDER
updateAll()

getgenv().PLAYER_ESP_LOOP = task.spawn(function()
    while getgenv().PLAYER_ESP_VISIBLE do
        updateAll()
        task.wait(0.3)
    end
end)

if not getgenv().PLAYER_ESP_CONNECTIONS then
    getgenv().PLAYER_ESP_CONNECTIONS = true

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if getgenv().PLAYER_ESP_VISIBLE then
                applyESP(player)
            end
        end)
    end)
end
