---@class Layer
local self = {
    cwd = ""
}

-- Layer values
self.tag = "tag"
self.order = 1
self.sprites = {}

-- Properties
self.visible = true
self.active = true
self.deltatime = true
    
-- Loads the default values of the sprite
function self:load() end

---@param dt number
-- Updates the layer
function self:update(dt) end

-- Draws the layer
function self:draw() end

-- Removes the layer
function self:remove() end

---@param active boolean
-- Sets whenever DT should be used or not (DT is set to 1 if disabled)
function self:disableDT(active) end

-- Sets the layer visible
---@param active boolean
function self:setVisible(active) end

---@param active boolean
-- Sets the layer active
function self:setActive(active) end

-- Layering

---@param order number
-- Sets the order of the layer (used to decide the drawing order)
function self:setOrder(order) end

-- Sprite management

---@param sprite Sprite|string
-- Adds a sprite to this layer
function self:addSprite(sprite) end

---@param sprite Sprite|string
-- Removes a sprite from this layer
function self:removeSprite(sprite) end