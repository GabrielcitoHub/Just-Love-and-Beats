return function(self, tag, path, x, y, r, sx, sy, ox, oy, kx, ky)
    
    -- Sprite values
    local image = Cache:cacheImage(path)
    self.tag = tag
    self.image = image

    -- Position values
    self.x = x or 0
    self.y = y or 0
    self.r = r or 0
    self.sx = sx or 1
    self.sy = sy or 1
    self.ox = ox or 0
    self.oy = oy or 0
    self.kx = kx or 0
    self.ky = ky or 0
    self.zorder = 1

    -- Movement values
    self.speedx = 0
    self.speedy = 0

    -- Properties
    self.visible = true
    self.active = true
    self.deltatime = true
    self.mirrored = false
    self.flipped = false
    self.bgstreched = false

    -- Tables
    self.animations = {}

    return true
end