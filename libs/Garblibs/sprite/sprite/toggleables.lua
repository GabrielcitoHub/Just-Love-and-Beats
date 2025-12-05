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

    -- Misc
    function self:enableBGStretch(active)
        if type(active) == "nil" then active = default end
        self.bgstreched = active
    end

    -- Mirror / Flip
    function self:mirror(active)
        if type(active) == "nil" then active = default end
        self.mirrored = active
    end

    function self:flip(active)
        if type(active) == "nil" then active = default end
        self.flipped = active
    end

    return true
end 