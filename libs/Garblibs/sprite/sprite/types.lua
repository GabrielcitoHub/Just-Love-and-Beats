---@class Sprite
local self = {
    cwd = (...):gsub('%.init$', '') .. "."
}

-- Load
-- Sprite values
self.tag = "tag"
self.image = love.graphics.newImage("")

-- Position values
self.x = 0
self.y = 0
self.r = 0
self.sx = 1
self.sy = 1
self.ox = 0
self.oy = 0
self.kx = 0
self.ky = 0
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

-- Sprite

-- Loads the default values of the sprite
function self:load() end

---@param dt number
-- Updates the sprite
function self:update(dt) end

-- Draws the sprite
function self:draw() end

-- Removes the sprite
function self:remove() end

-- Toggleables

---@param active boolean
-- Sets whenever DT should be used or not (DT is set to 1 if disabled)
function self:disableDT(active) end

---@param active boolean
-- Enables BG Stretch (Stretches the sprite across the whole screen)
function self:enableBGStretch(active) end

-- Properties

-- Sets the sprite visible
---@param active boolean
function self:setVisible(active) end

---@param active boolean
-- Sets the sprite active
function self:setActive(active) end

-- Mirror / Flip

---@param active boolean
-- Mirrors the sprite backwards (right to left)
function self:mirror(active) end

---@param active boolean
-- Flips the sprite upwards (down to up)
function self:flip(active) end

-- Update

-- Position
---@param x number
---@param y number
-- Sets the sprite position
function self:setPosition(x, y) end

---@param centertype string|nil
-- Centers the sprite to the middle of the screen
function self:center(centertype) end

---@param mx number
---@param my number
-- Moves the sprite by mx and my across the x and y axis
function self:move(mx, my) end

---@param zorder number
-- Sets the zorder of the sprite (used to decide the drawing order)
function self:setZOrder(zorder) end

-- Size

---@param sx number
---@param sy number|nil
-- Scales the sprite
function self:setScale(sx, sy) end

---@param width number
---@param height number
-- Sets the sprite dimensions
function self:setSize(width, height) end

-- Animations

---@param tag string
---@param path string
---@param loop boolean
---@return Animation
-- Loads an animation file
function self:newAnimation(tag, path, loop)
    return require(self.cwd .. "sprite.animation")(self)
end

---@param tag string
-- Removes an animation
function self:removeAnimation(tag)
    local anim = self.animations[tag]
    anim:remove()
end

---@param path string
-- Replaces the sprite animation
function self:setImage(path)
    self.image = Cache:cacheImage(path)
end