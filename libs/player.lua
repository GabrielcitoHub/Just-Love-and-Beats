return function(tag, path, x, y, extra) extra = extra or {} local self = {
    tag = tag,
    sprite = Sprite:new(tag, path, x, y),
    speed = extra.speed or 240,
    dashboost = extra.dashboost or 160,
    dash = extra.dash or false,
    dashing = extra.dashing or false,
    dashtimer = extra.dashtimer or 0,
    dashcooldown = extra.dashcooldown or 0.5,
    keybinds = extra.keybinds or {
        up = "w",
        down = "s",
        left = "a",
        right = "d",
        dash = "space"
    }
}
local keybinds = self.keybinds

self.sprite.ox = self.sprite.image:getWidth() / 2
self.sprite.oy = self.sprite.image:getHeight() / 2

function self:handleRotation(key)
    if key == keybinds.up then
        self.sprite.r = 0
    elseif key == keybinds.down then
        self.sprite.r = 100
    elseif key == keybinds.left then
        self.sprite.r = 50
    elseif key == keybinds.right then
        self.sprite.r = -50
    end

    if key == keybinds.dash then
        self:trydash()
    end
end

function self:keepInScreen(dt)
    local w = self.sprite.image:getWidth()
    local h = self.sprite.image:getHeight()
    local hw = w / 2   -- half width
    local hh = h / 2   -- half height

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    -- Clamp horizontally (x is center)
    if self.sprite.x < hw then
        self.sprite.x = hw
    elseif self.sprite.x > sw - hw then
        self.sprite.x = sw - hw
    end

    -- Clamp vertically (y is center)
    if self.sprite.y < hh then
        self.sprite.y = hh
    elseif self.sprite.y > sh - hh then
        self.sprite.y = sh - hh
    end
end

function self:handleMovement(dt)
    local vx, vy = 0, 0
    local speed = self.speed

    if self.dashing then
        speed = speed * (self.dashboost/100)
    end

    if love.keyboard.isDown(keybinds.up) then
        vy = vy + speed * -1
    elseif love.keyboard.isDown(keybinds.down) then
        vy = vy + speed
    end

    if love.keyboard.isDown(keybinds.left) then
        vx = vx + speed * -1
    elseif love.keyboard.isDown(keybinds.right) then
        vx = vx + speed
    end

    -- Check if no key is pressed while dashing, in this case move left
    if not love.keyboard.isDown(keybinds.up) and not love.keyboard.isDown(keybinds.down) and not love.keyboard.isDown(keybinds.left) and not love.keyboard.isDown(keybinds.right) then
        self.sprite.r = 0
        if self.dashing then
            vx = vx + speed * -1
        end
    end
    
    self.sprite.speedx = vx
    self.sprite.speedy = vy
end

function self:handleDash(dt)
    if self.dashtimer > 0 then
        self.dashtimer = self.dashtimer - 1 * dt
        if self.particles then
            self.particles.rate = 80 * (self.dashtimer + 1)
            self.particles.spread = (12 * self.dashtimer) / 10
            self.particles.speed = 0
        end
    else
        self.dashing = false
        self.dashtimer = 0
        if self.particles then
            self.particles.rate = 20
            self.particles.spread = 0.2
            self.particles.speed = 5
            self.particles.shader = nil
        end
    end
end

function self:trydash()
    if self.dashing or self.dashtimer > 0 then return end
    self.dashing = true
    self.dashtimer = self.dashcooldown
    if self.particles then
        -- Shaders are WAY too laggy for particles
        -- self.particles.shader = SHADERS.white
    end
end

function self:keypressed(key)
    self:handleRotation(key)
end

function self:update(dt)
    self:handleDash(dt)
    self:handleMovement(dt)
    self:keepInScreen(dt)
end

function self:_draw()
    if self.particles then
        self.particles:draw()
    end
end

function self:draw()
    self:_draw()
    self.sprite:draw()
    if self.dashing then
        love.graphics.push()
        love.graphics.setColor(0,0,0,2*self.dashtimer)
        love.graphics.setShader(SHADERS.white)
        self.sprite:draw()
        love.graphics.setShader()
        love.graphics.pop()
    end
end

return self end