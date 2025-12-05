return function(self, x, y, r, sx, sy, ox, oy, kx, ky)
    if not self.image or not self.visible or not self.active then return false end
    x = x or self.x
    y = y or self.y
    r = r or self.r
    sx = sx or self.sx
    sy = sy or self.sy
    ox = ox or self.ox
    oy = oy or self.oy
    kx = kx or self.kx
    ky = ky or self.ky

    local mirrored = self.mirrored or false
    local flipped = self.flipped or false

    local function draw()
        -- print(tostring(self.quad))
        if not self.quad then
            love.graphics.draw(self.image, x, y, r, sx * ((mirrored and -1) or 1), sy * ((flipped and -1) or 1), ox, oy, kx, ky)
        else
            -- print("Drawn quad")
            love.graphics.draw(self.image, self.quad, x, y, r, sx * ((mirrored and -1) or 1), sy * ((flipped and -1) or 1), ox, oy, kx, ky)
        end
        return true
    end

    if x >= 0 - self.image:getWidth() and x < love.graphics:getWidth() and
       y >= 0 - self.image:getHeight() and y < love.graphics:getHeight() then
        return draw()
    else
        return false
    end
end