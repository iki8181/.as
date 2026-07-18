-- ============================================================
-- Chat Bypasser - SIWO_BAEK Edition
-- Gabungan dari ChatSplitter & ChatBypasser
-- ============================================================

-- ========== KONFIGURASI ==========
local bypassEnabled = true
local delayBetweenWords = 0.7
local customMessage = ""

-- ========== KATA TERLARANG & PENGGANTI ==========
local keywords = {
    "ass", "cum", "cock", "fuck", "asshole", "rape", "boobs", "titties", "sex",
    "hoe", "porn", "nigga", "penis", "beaner", "thot", "xxx", "hentai", "bitch",
    "bitches", "shit", "kys", "butthole", "masturbate", "big black cock",
    "blowjob", "cock sucker", "fat ass hoe"
}

local replacements = {
    "а⁥⁥⁥⁥ѕѕ", "с⁥⁥⁥⁥um", "сосk", "fu𐌑𝖔 ͜ ͣ c𐌑ḳ", "аѕѕһоlе", "rаре",
    "Вoobs", "Тitties", "s⁥⁥⁥⁥⁥⁥ех", "һое", "рогn", "п⁥iɡ⁥ɡ⁥а",
    "реп⁥is", "bеаn⁥ег", "ТН⁥⁥⁥⁥⁥ОТ", "ΧΧΧ", "НЕΝТАӀ", "ВI⁥⁥⁥⁥⁥⁥TСН",
    "ВIT⁥⁥⁥⁥⁥⁥⁥СНEЅ", "ЅНIТ", "К⁥⁥⁥⁥⁥YЅ", "ВUТТ⁥⁥⁥⁥НOLЕ", "МАЅТURВАТЕ",
    "big black со⁥⁥⁥сk", "Вӏоwjob", "Віtеѕ уоur сосk", "сосk suсkеr",
    "f⁥аt а⁥ѕѕ һое"
}

-- ========== BUAT DICTIONARY ==========
local bypassDict = {}
for i, word in ipairs(keywords) do
    bypassDict[word:lower()] = replacements[i] or word
end

-- ========== FUNGSI BYPASS ==========
local function bypassText(text)
    local words = {}
    for word in string.gmatch(text, "%S+") do
        local lower = word:lower()
        local replaced = bypassDict[lower] or word
        table.insert(words, replaced)
    end
    return table.concat(words, " ")
end

-- ========== KIRIM PESAN ==========
local function sendMessage(text, channel)
    channel = channel or "All"
    local bypassed = bypassText(text)
    game:GetService("ReplicatedStorage")
        .DefaultChatSystemChatEvents.SayMessageRequest:FireServer(bypassed, channel)
    return bypassed
end

-- ========== SPLIT & KIRIM ==========
local function sendSplitMessage(text, delay)
    delay = delay or delayBetweenWords
    local words = {}
    for word in string.gmatch(text, "%S+") do
        table.insert(words, word)
    end
    
    for i, word in ipairs(words) do
        local bypassed = bypassText(word)
        game:GetService("ReplicatedStorage")
            .DefaultChatSystemChatEvents.SayMessageRequest:FireServer(bypassed, "All")
        if i < #words then
            wait(tonumber(delay) or 0.7)
        end
    end
end

-- ========== GUI ==========
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ChatBypasserGUI"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.Position = UDim2.new(0.3, 0, 0.1, 0)
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Title
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Font = Enum.Font.GothamBold
    title.Text = "🔓 Chat Bypasser - SIWO_BAEK"
    title.TextColor3 = Color3.fromRGB(0, 255, 200)
    title.TextSize = 16

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = mainFrame
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    closeBtn.Position = UDim2.new(0.92, 0, 0.02, 0)
    closeBtn.Size = UDim2.new(0, 30, 0, 25)
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Parent = mainFrame
    minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    minBtn.Position = UDim2.new(0.84, 0, 0.02, 0)
    minBtn.Size = UDim2.new(0, 30, 0, 25)
    minBtn.Font = Enum.Font.Gotham
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 20
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 400, 0, 30)
        else
            mainFrame.Size = UDim2.new(0, 400, 0, 300)
        end
    end)

    -- Input Box
    local inputBox = Instance.new("TextBox")
    inputBox.Parent = mainFrame
    inputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    inputBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Position = UDim2.new(0.05, 0, 0.12, 0)
    inputBox.Size = UDim2.new(0.9, 0, 0, 50)
    inputBox.Font = Enum.Font.SourceSans
    inputBox.PlaceholderText = "Ketik pesan di sini..."
    inputBox.Text = ""
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 14
    inputBox.TextWrapped = true
    inputBox.TextScaled = true

    -- Delay Input
    local delayBox = Instance.new("TextBox")
    delayBox.Parent = mainFrame
    delayBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    delayBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
    delayBox.Position = UDim2.new(0.05, 0, 0.35, 0)
    delayBox.Size = UDim2.new(0, 80, 0, 30)
    delayBox.Font = Enum.Font.SourceSans
    delayBox.PlaceholderText = "0.7"
    delayBox.Text = "0.7"
    delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    delayBox.TextSize = 14

    -- Delay Label
    local delayLabel = Instance.new("TextLabel")
    delayLabel.Parent = mainFrame
    delayLabel.BackgroundTransparency = 1
    delayLabel.Position = UDim2.new(0.28, 0, 0.35, 0)
    delayLabel.Size = UDim2.new(0, 60, 0, 30)
    delayLabel.Font = Enum.Font.SourceSans
    delayLabel.Text = "Delay (s)"
    delayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    delayLabel.TextSize = 12

    -- Toggle Bypass
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = mainFrame
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    toggleBtn.Position = UDim2.new(0.55, 0, 0.35, 0)
    toggleBtn.Size = UDim2.new(0, 100, 0, 30)
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.Text = "Bypass: ON"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    local bypassOn = true
    toggleBtn.MouseButton1Click:Connect(function()
        bypassOn = not bypassOn
        toggleBtn.Text = bypassOn and "Bypass: ON" or "Bypass: OFF"
        toggleBtn.BackgroundColor3 = bypassOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    end)

    -- Send Button (Split)
    local sendBtn = Instance.new("TextButton")
    sendBtn.Parent = mainFrame
    sendBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    sendBtn.Position = UDim2.new(0.05, 0, 0.50, 0)
    sendBtn.Size = UDim2.new(0, 170, 0, 40)
    sendBtn.Font = Enum.Font.Gotham
    sendBtn.Text = "📨 Kirim (Split)"
    sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendBtn.TextSize = 14
    sendBtn.MouseButton1Click:Connect(function()
        local msg = inputBox.Text
        if msg == "" then return end
        local delay = tonumber(delayBox.Text) or 0.7
        if bypassOn then
            sendSplitMessage(msg, delay)
        else
            game:GetService("ReplicatedStorage")
                .DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end
    end)

    -- Send Button (Normal)
    local sendNormalBtn = Instance.new("TextButton")
    sendNormalBtn.Parent = mainFrame
    sendNormalBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sendNormalBtn.Position = UDim2.new(0.55, 0, 0.50, 0)
    sendNormalBtn.Size = UDim2.new(0, 170, 0, 40)
    sendNormalBtn.Font = Enum.Font.Gotham
    sendNormalBtn.Text = "📨 Kirim (Normal)"
    sendNormalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendNormalBtn.TextSize = 14
    sendNormalBtn.MouseButton1Click:Connect(function()
        local msg = inputBox.Text
        if msg == "" then return end
        if bypassOn then
            local bypassed = bypassText(msg)
            game:GetService("ReplicatedStorage")
                .DefaultChatSystemChatEvents.SayMessageRequest:FireServer(bypassed, "All")
        else
            game:GetService("ReplicatedStorage")
                .DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end
    end)

    -- Preset Buttons (Baris 1)
    local presets = {
        {"Ass", "а⁥⁥⁥⁥ѕѕ"},
        {"Cock", "сосk"},
        {"Cum", "с⁥⁥⁥⁥um"},
        {"Bitch", "ВI⁥⁥⁥⁥⁥⁥TСН"},
    }
    for i, data in ipairs(presets) do
        local btn = Instance.new("TextButton")
        btn.Parent = mainFrame
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Position = UDim2.new(0.05 + (i-1)*0.22, 0, 0.68, 0)
        btn.Size = UDim2.new(0, 80, 0, 30)
        btn.Font = Enum.Font.Gotham
        btn.Text = data[1]
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.MouseButton1Click:Connect(function()
            local bypassed = bypassText(data[2])
            game:GetService("ReplicatedStorage")
                .DefaultChatSystemChatEvents.SayMessageRequest:FireServer(bypassed, "All")
        end)
    end

    -- Preset Buttons (Baris 2)
    local presets2 = {
        {"Boobs", "Вoobs"},
        {"Titties", "Тitties"},
        {"N-Word", "п⁥iɡ⁥ɡ⁥а"},
        {"Rape", "rаре"},
    }
    for i, data in ipairs(presets2) do
        local btn = Instance.new("TextButton")
        btn.Parent = mainFrame
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Position = UDim2.new(0.05 + (i-1)*0.22, 0, 0.82, 0)
        btn.Size = UDim2.new(0, 80, 0, 30)
        btn.Font = Enum.Font.Gotham
        btn.Text = data[1]
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.MouseButton1Click:Connect(function()
            local bypassed = bypassText(data[2])
            game:GetService("ReplicatedStorage")
                .DefaultChatSystemChatEvents.SayMessageRequest:FireServer(bypassed, "All")
        end)
    end

    -- Credits
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Parent = mainFrame
    creditLabel.BackgroundTransparency = 1
    creditLabel.Position = UDim2.new(0, 0, 0.92, 0)
    creditLabel.Size = UDim2.new(1, 0, 0, 20)
    creditLabel.Font = Enum.Font.SourceSans
    creditLabel.Text = "by SIWO_BAEK 🔥 | Forked from AZY"
    creditLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
    creditLabel.TextSize = 10
end

-- ========== LOAD ==========
print("[ChatBypasser] Loading...")
createGUI()
print("[ChatBypasser] Loaded!")
