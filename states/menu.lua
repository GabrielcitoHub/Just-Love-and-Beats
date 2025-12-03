local state = {}
local self = state
self.timer = 0
self.boops = 0
self.boopleft = true

function self:load()
    local logo = Sprite:new("logo", "assets/images/logo_animated.png")
    self.xml = logo:newAnimation("xml","assets/images/logo_animated.xml", true)
    function self.xml:ended()
        self.boops = self.boops + 1
    end
    self.xml:play("boopleft",100)
    logo:center()
end



function self:keypressed(key)
    stateManager:loadState("level")
end

function self:update(dt)
    self.timer = self.timer + 1 * dt
    if self.timer > 1 then
        self.timer = 0
        self.boopleft = not self.boopleft
    end
    if self.boopleft then
        self.xml:play("boopleft",120)
    else
        self.xml:play("boopright",120)
    end
end

return self