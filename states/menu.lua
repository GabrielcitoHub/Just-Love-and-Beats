local state = {}
state.boopleft = true

function state:load()
    state.logo = Sprite:new("logo", "assets/images/logo_animated.png")
    state.logo:setScale(3)
    state.xml = state.logo:newAnimation("xml","assets/images/logo_animated.xml", true)
    function state.xml:ended()
        state.boopleft = not state.boopleft
    end
    state.xml:play("boopleft",100)
    state.logo:center()
end



function state:keypressed(key)
    stateManager:loadState("level")
end

function state:update(dt)
    if state.boopleft then
        state.xml:play("boopleft",120)
    else
        state.xml:play("boopright",120)
    end
end

return state