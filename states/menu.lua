local buttons = require "libs.button"
local state = {}
state.boopleft = true
state.menu = 1
state.selection = 1
state.buttons = {}

function state:load(oldstate)
    -- print(tostring(oldstate))
    -- Create the logo
    state.logo = Sprite:new("logo", "assets/images/logo_animated.png")
    state.logo:setScale(3)
    state.xml = state.logo:newAnimation("xml","assets/images/logo_animated.xml", true)
    function state.xml:ended()
        state.boopleft = not state.boopleft
    end
    state.xml:play("boopleft",100)
    state.logo:center()

    -- Create the buttons
    local buttonimg = "assets/images/menus/button.png"
    local buttonxml = "assets/images/menus/button.xml"
    table.insert(state.buttons, buttons("story", buttonimg, love.graphics:getWidth() / 2))
    table.insert(state.buttons, buttons("freeplay", buttonimg, love.graphics:getWidth() / 2))
    table.insert(state.buttons, buttons("party", buttonimg, love.graphics:getWidth() / 2))
    table.insert(state.buttons, buttons("mods", buttonimg, love.graphics:getWidth() / 2))
    table.insert(state.buttons, buttons("options", buttonimg, love.graphics:getWidth() / 2))
    table.insert(state.buttons, buttons("credits", buttonimg, love.graphics:getWidth() / 2))

    -- Load animations
    for i,button in ipairs(state.buttons) do
        button.text = button.tag
        button.sprite:setScale(6)
        button.xml = button.sprite:newAnimation("xml", buttonxml, false)
        button.xml:play("idle")

        -- Space across screen
        local N = #state.buttons
        local screenH = love.graphics.getHeight()
        local h = button.h / 2
        local gap = (screenH - (N * h)) / (N + 1)
        local y = gap * i + h * (i - 1)
        -- print(y)

        button.y = y
    end

    state:updateSelectedButton(state.selection)

    if oldstate then
        state.menu = 2
        state.selection = oldstate.prevselection
        state.boopleft = oldstate.boopleft
        state.xml.current = oldstate.xml.current
        state:updateMenuSize(state.menu)
    end

    soundManager:playMusic("Strolling Mastered","wav")
end

function state:updateMenuSize(menu)
    if menu == 1 then
        state.logo:setPosition((love.graphics:getWidth() / 2) - (state.logo.image:getWidth() / 2), (love.graphics:getHeight() / 2) - (state.logo.image:getHeight() / 2))
        state.logo:setScale(3)
    elseif menu == 2 then
        state.logo:setScale(1)
        state.logo:setPosition(love.graphics:getWidth() / 3 - love.graphics:getWidth() / 4, love.graphics:getHeight() / 2 - love.graphics:getWidth() / 8)
    end
end

function state:updateKeypressMenu(menu, key)
    if menu == 1 then
        soundManager:playSound("select3", "wav", {new = true})
        state.menu = 2
    elseif menu == 2 then
        if key == "return" then
            soundManager:playSound("select3", "wav", {new = true})
            state:pressButton(state.selection)
        elseif key == "up" then
            state.selection = state.selection - 1
        elseif key == "down" then
            state.selection = state.selection + 1
        elseif key == "escape" then
            soundManager:playSound("select3", "wav", {new = true})
            state.menu = 1
        end

        if key == "up" or key == "down" then
            soundManager:playSound("cloud_poof", "wav", {new = true})
        end

        if key == "up" or key == "down" or key == "return" then
            state.selection = state:updateSelectedButton(state.selection)
        end
    end
    state:updateMenuSize(state.menu)
end

function state:updateSelectedButton(selection)
    -- I have no idea why this can be nil
    selection = selection or 1
    -- Keep inbounds
    -- print(selection .. " " .. #state.buttons)
    if selection > #state.buttons then
        selection = 1
    elseif selection < 1 then
        selection = #state.buttons
    end

    -- Update Animation
    for i,button in pairs(state.buttons) do
        if i == selection then
            button.xml.current = 1
            button.xml:play("select",100)
        else
            if button.xml.current >= #button.xml.frames then
                -- This resets all the buttons, need to implement animation names first.
                -- button.xml.current = 1
            end
            button.xml:play("deselect",100)
        end
    end

    return selection
end

function state:pressButton(index)
    -- Get button tag
    local button = state.buttons[index]
    local tag = button.tag

    -- Do an action
    if tag == "freeplay" then
        stateManager:loadState("level")
    elseif tag == "credits" then
        stateManager:loadState("credits", state)
    elseif tag == "options" then
        stateManager:loadState("options", state)
    end
end

function state:keypressed(key)
    state:updateKeypressMenu(state.menu, key)
end

function state:update(dt)
    if state.boopleft then
        state.xml:play("boopleft",120)
    else
        state.xml:play("boopright",120)
    end
end

function state:draw()
    if state.menu == 2 then
        for i,button in pairs(state.buttons) do
            love.graphics.setColor(1,1,1,0.7)
            if i == state.selection then
                love.graphics.setColor(1,1,1,1)
            end
            
            button:draw()

            love.graphics.setColor(1,1,1,1)
        end
    end
    state.logo:draw()
end

return state