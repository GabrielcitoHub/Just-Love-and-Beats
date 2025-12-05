return function(tag, path, x, y, extra)
    ---@type Sprite
    local self = {}
    extra = extra or {}
    local manager = extra.manager
    self.cwd = manager.cwd

    function self:load()
        require(self.cwd .. "sprite.toggleables")(self)
        require(self.cwd .. "sprite.functions")(self)
        return require(self.cwd .. "sprite.load")(self, tag, path, x, y)
    end

    function self:update(dt)
        if not self.deltatime then dt = 1 end
        return require(self.cwd .. "sprite.update")(self, dt)
    end

    function self:draw()
        return require(self.cwd .. "sprite.draw")(self)
    end

    function self:remove()
        return require(self.cwd .. "sprite.remove")(self, manager)
    end

    return self
end