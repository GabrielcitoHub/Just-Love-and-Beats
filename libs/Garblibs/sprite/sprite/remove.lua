return function(self, manager)
    if self.layer then
        self.layer:removeSprite(self)
    end
    local tag = self.tag
    self = nil
    manager.sprites[tag] = nil
    if not manager.sprites[tag] then
        return true
    end
    return false
end