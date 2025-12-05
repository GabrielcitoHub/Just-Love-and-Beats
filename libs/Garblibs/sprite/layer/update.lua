return function(self, dt)
    if not self.sprites then return end
    for _,sprite in pairs(self.sprites) do
        sprite:update(dt)
    end
    return true
end 