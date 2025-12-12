local self = {}
function self:new(tag, path, x, y, w, h)
    x = x or 0
    y = y or 0
    w = w or 920
    h = h or 300

    local btn = {
        tag = tag,
        text = "",
        sprite = Sprite:new(tag, path, x, y),
        x = x,
        y = y,
        w = w,
        h = h
    }

    function btn:draw(x, y, w, h)
        x = x or btn.x
        y = y or btn.y
        w = w or btn.w
        h = h or btn.h
        local sx = w / btn.sprite.image:getWidth()
        local sy = h / btn.sprite.image:getHeight()

        btn.sprite.x = x
        btn.sprite.y = y
        btn.sprite.sx = sx
        btn.sprite.sy = sy
        btn.sprite:draw(x, y, w, h)

        if btn.text then
            love.graphics.print(btn.text, x, y + (h / 6), 0, sx, sy / 2)
        end
    end
    return btn
end
return self