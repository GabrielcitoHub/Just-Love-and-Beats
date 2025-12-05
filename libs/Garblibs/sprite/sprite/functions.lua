return function(self)
    local utils = require(self.cwd .. "utils")
    utils:setCWD(self.cwd)
    
    -- Position
    function self:setPosition(x, y)
        x = x or 0
        y = y or 0

        self.x = x
        self.y = y
    end

    function self:center(centertype)
        centertype = centertype or "xy"
        centertype = string.lower(centertype)

        local image = self.image
        local quad = self.quad
        local x, y
        local w, h = image:getWidth(), image:getHeight()
        local xcenter, ycenter
        if quad then
            x, y, w, h = quad:getViewport()
            xcenter = (love.graphics.getWidth() / 2) - (w / 2) - (self.w / 2)
            ycenter = (love.graphics.getHeight() / 2) - (h / 2) - (self.h / 2)
        else
            xcenter = (love.graphics.getWidth() / 2) - (w / 2)
            ycenter = (love.graphics.getHeight() / 2) - (h / 2)
        end

        if centertype == "x" then
            self.x = xcenter
        elseif centertype == "y" then
            self.y = ycenter
        elseif centertype == "xy" then
            self.x = xcenter
            self.y = ycenter
        else
            -- Umh... invalid... input?
        end
    end

    function self:move(mx, my)
        mx = mx or 0
        my = my or 0

        self.x = self.x + mx
        self.y = self.y + my
    end

    function self:setZOrder(zorder)
        self.zorder = zorder or 1
    end

    -- Size
    function self:setScale(sx, sy)
        sx = sx or 1
        sy = sy or sx

        self.sx = sx
        self.sy = sy
    end

    function self:setSize(width, height)
        width = width or 1
        height = height or 1

        self.sx = (self.sx / self.image:getWidth()) * width
        self.sy = (self.sy / self.image:getHeight()) * height
    end

    -- Animations
    function self:newAnimation(tag, path, loop)
        local filename, type = path:match("^(.*)%.([^%.]+)$")
        type = string.lower(type)
        -- print(type)
        local data = utils:pathToQuads(self.image, path, type)

        return require(self.cwd .. "sprite.animation")(self, tag, data, loop)
    end

    function self:removeAnimation(tag)
        local anim = self.animations[tag]
        anim:remove()
    end

    function self:setImage(path)
        self.image = Cache:cacheImage(path)
    end
end