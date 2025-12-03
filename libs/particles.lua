return function(path, x, y, w, h, extra) extra = extra or {} local self = {
        path = path,
        particles = {},
        lifespan = extra.lifespan or 2,
        rate = extra.rate or 20,
        spread = extra.spread or 0.2,
        speed = extra.speed or 80,
        randomness = extra.randomness or 20,
        randomColor = extra.randomColor or false,
        randomAlpha = extra.randomAlpha or false,
        x = x,
        y = y,
        w = w,
        h = h,
        timer = 0
    }

    local image = love.graphics.newImage(self.path)
    local imgData = love.image.newImageData(self.path)
    local iw, ih = image:getWidth(), image:getHeight()

    ----------------------------------------------------------------
    -- Get a color from the image at a random pixel
    ----------------------------------------------------------------
    local function sampleColor()
        local px = love.math.random(0, iw - 1)
        local py = love.math.random(0, ih - 1)
        local r, g, b, a = imgData:getPixel(px, py)

        if self.randomColor then
            -- random color variation
            local variance = 0.2
            r = r + love.math.random() * variance - variance/2
            g = g + love.math.random() * variance - variance/2
            b = b + love.math.random() * variance - variance/2
        end

        if self.randomAlpha then
            a = a * love.math.random()
        end

        return r, g, b, a
    end

    ----------------------------------------------------------------
    -- Spawn particles based on rate
    ----------------------------------------------------------------
    function self:emit(dt)
        self.timer = self.timer + dt
        local amount = math.floor(self.timer * self.rate)

        if amount > 0 then
            self.timer = self.timer - amount / self.rate
        end

        for i = 1, amount do
            local r, g, b, a = sampleColor()

            local angle = (math.pi * 2) * (love.math.random() * self.spread - self.spread / 2)
            local speed = self.speed + love.math.random(-self.randomness, self.randomness)

            table.insert(self.particles, {
                x = self.x + love.math.random(-self.w/2, self.w/2),
                y = self.y + love.math.random(-self.h/2, self.h/2),
                vx = math.cos(angle) * speed,
                vy = math.sin(angle) * speed,
                life = self.lifespan,
                r = r, g = g, b = b, a = a
            })
        end
    end

    ----------------------------------------------------------------
    -- Update particles
    ----------------------------------------------------------------
    function self:update(dt)
        self:emit(dt)

        for i = #self.particles, 1, -1 do
            local p = self.particles[i]
            p.life = p.life - dt

            if p.life <= 0 then
                table.remove(self.particles, i)
            else
                p.x = p.x + p.vx * dt
                p.y = p.y + p.vy * dt
            end
        end
    end

    ----------------------------------------------------------------
    -- Draw particles
    ----------------------------------------------------------------
    function self:draw()
        for _, p in ipairs(self.particles) do
            local alpha = p.a * (p.life / self.lifespan) -- fade out

            love.graphics.setColor(p.r, p.g, p.b, alpha)
            love.graphics.points(p.x, p.y)
        end

        love.graphics.setColor(1, 1, 1, 1)
    end

return self end