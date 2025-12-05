return function(tag, order, sprites, extra)
    ---@type Layer
    local self = {}
    extra = extra or {}
    local manager = extra.manager
    self.cwd = manager.cwd
    
    function self:load()
        require(self.cwd .. "layer.toggleables")(self)
        require(self.cwd .. "layer.functions")(self)
        return require(self.cwd .. "layer.load")(self, tag, order, sprites)
    end

    function self:update(dt)
        if not self.deltatime then dt = 1 end
        return require(self.cwd .. "layer.update")(self, dt)
    end

    function self:draw()
        return require(self.cwd .. "layer.draw")(self, manager)
    end

    function self:remove()
        return require(self.cwd .. "layer.remove")(self, manager)
    end

    return self
end