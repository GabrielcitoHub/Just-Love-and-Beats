return function(self, manager)
    
    -- Layering
    function self:setOrder(order)
        self.order = order or 1
    end

    -- Sprite management
    function self:fixSprite(sprite)
        if type(sprite) == "string" then
            sprite = manager.sprites[sprite]
        end
        return sprite
    end

    function self:addSprite(sprite)
        self:fixSprite(sprite)
        sprite.layer = self
        self.sprites[sprite.tag] = sprite
    end

    function self:removeSprite(sprite)
        self:fixSprite(sprite)
        sprite.layer = nil
        self.sprites[sprite.tag] = nil
    end
end