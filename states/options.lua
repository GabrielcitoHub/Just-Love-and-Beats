local state = {}
local self = state

local function save()
    -- print("Saving settings data")

    local savedData = {}
    for _,opt in ipairs(self.options) do
        if type(opt.value) ~= "function" then
            savedData[opt.name] = opt.value
        end
    end

    local dataString = json.encode(savedData)

    love.filesystem.write("settings.json", dataString)
    if love.filesystem.getInfo("settings.json") then
        print("Settings saved succesfully")
    else
        love.system.setClipboardText(dataString)
        print("Error! Could not save  data!")
        print("Settings copied to clipboard")
    end
end

local function load()
    if love.filesystem.getInfo("settings.json") then
        -- print("Loading settings data")

        local dataString = love.filesystem.read("settings.json")
        self.loadedSettings = json.decode(dataString)

        print("Loaded settings data")
    else
        print("settings not found")
    end
end

function self:checkPersistentOptions()
    if not self.options then return end
    local dw, dh, mode = love.window.getMode()
    for _,opt in ipairs(self.options) do
        if opt.name == "Vsync" then
            if opt.value == 1 then
                mode.vsync = 0
            elseif opt.value == 2 then
                mode.vsync = 1
            else
                mode.vsync = -1
            end
        elseif opt.name == "Resizable" then
            mode.resizable = opt.value
        end
    end
    if mode ~= DefaultMode then
        love.window.setMode(dw,dh,mode)
        DefaultMode = mode
    end
end

function self:checkOptions()
    if not self.options then return end
    for _,opt in ipairs(self.options) do
        if opt.name == "Fullscreen" then
            love.window.setFullscreen(opt.value)
            --if opt.name == "Shaders" then
            --PC.options.shaders(opt.value)
        --if opt.name == "Border" then
            --love.window.borderless(opt.value)
        elseif opt.name == "Master Volume" then
            love.audio.setVolume(opt.value)
        elseif opt.name == "Antialiasing" then
            if opt.value == true then
                love.graphics.setDefaultFilter("linear","linear")
            else
                love.graphics.setDefaultFilter("nearest", "nearest")
                -- OwO
            end
        end
    end
    loadSettings(self.options)
end

function self:load()
    load()

    -- Menu options
    self.options = self.options or {
        { name = "Master Volume", value = 1.0 },
        --{ name = "FPS CAP", value = false },
        { name = "Shaders", value = true },
        { name = "Antialiasing", value = false },
        { name = "Fullscreen", value = false },
        { name = "Show FPS", value = false },
        { name = "Resizable", value = false },
        { name = "Vsync", value = 1.0 },
        { name = "Keybinds", action = function() print("Open keybinds menu") end },
        { name = "Achivements", action = function() stateManager:loadState("achivements") end },
        { name = "View Credits", action = function() stateManager:loadState("credits") end },
        
        { name = "Back", action = function() stateManager:loadState("menu") end },
    }

    if self.loadedSettings then
        for index,val in ipairs(self.options) do
            if self.loadedSettings[val.name] then
                self.options[index] = {name = val.name, value = self.loadedSettings[val.name]}
            end
        end
    end

    if not settingsLoaded then
        DefaultWidth, DefaultHeight, DefaultMode = love.window.getMode()
        self:checkPersistentOptions()
        _G.settingsLoaded = true
    end

    self:checkOptions()

    self.selected = 1
end

function self:update(dt)
    -- Nothing animated for now, but you could add sliders, etc.
end

function self:draw()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.printf("OPTIONS", 0, 60, love.graphics.getWidth(), "center")

    for i, opt in ipairs(self.options) do
        local y = 150 + (i - 1) * 40
        if i == self.selected then
            love.graphics.setColor(1, 1, 0) -- Highlight color
        else
            love.graphics.setColor(1, 1, 1)
        end

        -- Format value display
        local valueText = ""
        if opt.value ~= nil then
            if type(opt.value) == "boolean" then
                valueText = opt.value and "ON" or "OFF"
            else
                valueText = tostring(opt.value)
            end
        end

        love.graphics.printf(opt.name .. "  " .. valueText, 0, y, love.graphics.getWidth(), "center")
    end
    love.graphics.setColor(1, 1, 1)
end

function self:keypressed(key)
    if key == "escape" then
        save()
        stateManager:loadState("menu")
    elseif key == "up" then
        self.selected = self.selected - 1
        if self.selected < 1 then
            self.selected = #self.options
        end
    elseif key == "down" then
        self.selected = self.selected + 1
        if self.selected > #self.options then
            self.selected = 1
        end
    elseif key == "return" or key == "space" then
        local opt = self.options[self.selected]
        if opt.value ~= nil then
            if type(opt.value) == "boolean" then
                opt.value = not opt.value
                if opt.name == "Fullscreen" then
                    if opt.value == false then
                        love.window.setMode(DefaultWidth,DefaultHeight)
                    end
                elseif opt.name == "Resizable" then
                    self:checkPersistentOptions()
                end
                self:checkOptions()

            elseif type(opt.value) == "number" then
                if opt.name == "Master Volume" then
                    -- Example: toggle between 0.0, 0.5, 1.0
                    if opt.value == 1 then opt.value = 0
                    elseif opt.value == 0 then opt.value = 0.5
                    else opt.value = 1 end
                elseif opt.name == "Vsync" then
                    opt.value = opt.value + 1
                    if opt.value > 3 then
                        opt.value = 1
                    end
                    self:checkPersistentOptions()
                    return
                end
                self:checkOptions()

            end
            save()
        elseif opt.action then
            save()
            opt.action()
        end
    end
end

return self