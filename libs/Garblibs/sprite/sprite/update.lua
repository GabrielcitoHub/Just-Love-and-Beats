return function(self, dt)
    -- Movement
    local speedx = self.speedx or 0
    local speedy = self.speedy or 0

    self.x = self.x + speedx * dt
    self.y = self.y + speedy * dt

    -- BG Stretch
    if self.bgstreched then
        self.x = 0
        self.y = 0
        self.sx = love.graphics:getWidth() / self.image:getWidth()
        self.sy = love.graphics:getHeight() / self.image:getHeight()
    end

    -- Update animations
    for _,anim in pairs(self.animations) do
        anim:update(dt)
    end

    return true
end 