return function(tag, path, x, y, w, h)
    x = x or 0
    y = y or 0
    w = w or 920
    h = h or 300
    local self = {
        tag = tag,
        sprite = Sprite:new(tag, path, x, y),
        x = x,
        y = y,
        w = w,
        h = h
    }

    function self:draw(x, y, w, h)
        x = x or self.x
        y = y or self.y
        w = w or self.w
        h = h or self.h
        self.sprite.x = x
        self.sprite.y = y
        self.sprite.sx = w / self.sprite.image:getWidth()
        self.sprite.sy = h / self.sprite.image:getHeight()
        self.sprite:draw(x, y, w, h)
    end
return self end