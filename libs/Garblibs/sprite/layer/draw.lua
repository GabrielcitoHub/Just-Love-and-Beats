return function(self, manager)
    if not self.sprites or not self.visible or not self.active then return false end
    local drawnSprites = {}

    manager:forObjects(self.sprites, function(sprite)
        if sprite:draw() then
            drawnSprites[sprite.tag] = sprite
        end
    end, true, "zorder")

    return drawnSprites
end