local buttons = require "libs.button"
local state = {}
state.boopleft = true
state.authorlink = false
state.menu = 1
state.selection = 1
state.selection2 = 1
state.buttons = {}

function state:getcredits(path)
    local credits = {} -- final table to return

    -- list items inside this directory
    local items = love.filesystem.getDirectoryItems(path)

    for _, name in ipairs(items) do
        local fullpath = path .. "/" .. name
        local info = love.filesystem.getInfo(fullpath)

        if info and info.type == "directory" then
            -- recursively get credits inside this folder
            local group = state:getcredits(fullpath)

            -- group name = folder name
            credits[name] = group

        elseif info and info.type == "file" then
            -- only include .lua files
            if name:sub(-4) == ".lua" then
                -- require path must use dots, not slashes
                local requirePath = fullpath:gsub("/", "."):sub(1, -5) -- remove ".lua"

                local ok, result = pcall(require, requirePath)
                if ok then
                    if type(result.image) == "string" then
                        result.image = love.graphics.newImage(result.image)
                    end
                    table.insert(credits, result)
                else
                    print("Failed to load:", requirePath, result)
                end
            end
        end
    end

    return credits
end

function state:load(extra)
    -- Create the logo
    state.logo = Sprite:new("logo", "assets/images/menus/credits/credits_animated.png")
    state.logo:setScale(1)
    state.xml = state.logo:newAnimation("xml","assets/images/menus/credits/credits_animated.xml", true)
    function state.xml:ended()
        state.boopleft = not state.boopleft
    end
    state.xml:play("boopleft",100)
    state.xml.current = extra.xml.current
    state.logo:setPosition(love.graphics:getWidth() / 3 - love.graphics:getWidth() / 4, love.graphics:getHeight() / 2 - love.graphics:getWidth() / 8)

    if extra then
        state.prevselection = extra.selection
        state.boopleft = extra.boopleft
    end

    -- Convert the hierarchical table returned by getcredits() into a
    -- sorted numeric list.
    local raw = state:getcredits("credits")

    state.credits = {}

    -- Convert raw table (key = folder name) into numeric array
    for folderName, creditList in pairs(raw) do
        
        -- Convert creditList to a numeric array
        local items = {}
        for _, credit in pairs(creditList) do
            table.insert(items, credit)
        end

        -- Sort credits by credit.name (or tostring)
        table.sort(items, function(a, b)
            local an = a.name or tostring(a)
            local bn = b.name or tostring(b)
            return an:lower() < bn:lower()
        end)

        -- Add the section
        table.insert(state.credits, {
            name = folderName,
            items = items
        })
    end

    -- 🔥 Sort the sections by folder name (this is what you asked for)
    table.sort(state.credits, function(a, b)
        return a.name:lower() < b.name:lower()
    end)

    state:updateSelected2(state.selection2)
    state:updateSelected(state.selection)
end

function state:updateSelected(selection)
    -- I have no idea why this can be nil
    selection = selection or 1
    -- Keep inbounds
    -- print(selection .. " " .. #state.buttons)
    local credit = state.credits[state.selection2].items
    if selection > #credit then
        selection = 1
    elseif selection < 1 then
        selection = #credit
    end

    return selection
end

function state:updateSelected2(selection)
    -- I have no idea why this can be nil
    selection = selection or 1
    -- Keep inbounds
    -- print(selection .. " " .. #state.buttons)
    if selection > #state.credits then
        selection = 1
    elseif selection < 1 then
        selection = #state.credits
    end

    -- print(selection)
    return selection
end

function state:pressButton()
    local section = state.credits[state.selection2]
    local credit = section and section.items[state.selection] or nil
    if not credit then return end

    local link = credit.link
    local authorlink = credit.author.link
    

    if state.authorlink and authorlink then
        love.system.openURL(credit.author.link)
    elseif state.authorlink == false and link then
        love.system.openURL(link)
    end
end

function state:keypressed(key)
    if key == "return" then
        state:pressButton()
    elseif key == "up" then
        state.selection2 = state.selection2 - 1
    elseif key == "down" then
        state.selection2 = state.selection2 + 1
    elseif key == "left" then
        state.selection = state.selection - 1
    elseif key == "right" then
        state.selection = state.selection + 1
    elseif key == "lctrl" or key == "tab" then
        state.authorlink = not state.authorlink
    elseif key == "escape" then
        state.selection = state.prevselection
        stateManager:loadState("menu", state)
    end

    if key == "up" or key == "down" then
        state.selection2 = state:updateSelected2(state.selection2)
    end

    if key == "left" or key == "right" or key == "return" then
        soundManager:playSound("cloud_poof", "wav", {new = true})
        state.selection = state:updateSelected(state.selection)
    end
end

function state:update(dt)
    if state.boopleft then
        state.xml:play("boopleft",120)
    else
        state.xml:play("boopright",120)
    end
end

function state:draw()
    local err = "?"

    local x = love.graphics.getWidth() / 1.8
    local y = love.graphics.getHeight() / 3
    local line = 0

    local function printLine(text, offset)
        love.graphics.print(text, x, y + offset)
    end

    local section = state.credits[state.selection2]
    local sectionName = section and section.name or err

    -- SECTION TITLE ----------------------------------------
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(state.bigFont or love.graphics.getFont())
    printLine("=== " .. sectionName .. " ===", 0)

    line = line + 60

    -- CREDIT ENTRY -----------------------------------------
    local credit = section and section.items[state.selection] or {}
    local name  = credit.name  or err
    local link  = credit.link  or err
    local image = credit.image
    -- IMAGE ----------------------------------------

    if image then
        love.graphics.draw(image, x, y - love.graphics:getHeight() / 5)
    end

    love.graphics.setFont(state.mediumFont or love.graphics.getFont())

    printLine("Name:", line)
    printLine("   " .. name, line + 20)

    printLine("Link:", line + 50)
    if not state.authorlink then
        love.graphics.setColor(1,1,0)
    end

    printLine("   " .. link, line + 70)

    love.graphics.setColor(1,1,1)

    line = line + 120

    -- AUTHOR INFO ------------------------------------------
    local author = credit.author or {}
    local aname = author.name or err
    local alink = author.link or err

    printLine("Author:", line)
    printLine("   " .. aname, line + 20)

    printLine("Author Link:", line + 50)
    if state.authorlink then
        love.graphics.setColor(1,1,0)
    end

    printLine("   " .. alink, line + 70)

    love.graphics.setColor(1,1,1)

    state.logo:draw()
end

return state