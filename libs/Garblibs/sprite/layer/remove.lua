return function(self, manager)
    local tag = self.tag
    self = nil
    manager.layers[tag] = nil
    if not manager.layers[tag] then
        return true
    end
    return false
end