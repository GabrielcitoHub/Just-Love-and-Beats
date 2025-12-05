return function(self, tag, order, sprites)

    -- Layer values
    self.tag = tag
    self.order = order or 1
    self.sprites = sprites or {}

    -- Properties
    self.visible = true
    self.active = true
    self.deltatime = true

    return true
end