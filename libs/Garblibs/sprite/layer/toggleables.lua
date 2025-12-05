return function(self, default)
    default = default or true

    function self:disableDT(active)
        if type(active) == "nil" then active = default end
        self.deltatime = not active
    end

    -- Properties
    function self:setVisible(active)
        if type(active) == "nil" then active = default end
        self.visible = active
    end

    function self:setActive(active)
        if type(active) == "nil" then active = default end
        self.active = active
    end

    return true
end