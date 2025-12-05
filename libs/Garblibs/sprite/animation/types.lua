---@class Animation
local self = {
    playing = false,
    time = 0,
    speed = 1,
    current = 1,
    loop = false,
    frames = {},
    subanimations = {}
}

---@param name string
---@param speed number|nil
---@param loop boolean|nil
-- Plays a Sub-Animation by name
function self:play(name, speed, loop) end

-- Pauses the animation
function self:pause() end

-- Stops the animation
function self:stop() end

---@param frame number
-- Sets the current frame of the animation
function self:setFrame(frame) end

---@param speed number
-- Sets the animation speed
function self:setSpeed(speed) end

---@param loop boolean
-- Sets whenever the animation should loop or not
function self:setLooping(loop) end

---@param dt number
-- Updates the animation
function self:update(dt) end

-- Remove the animation
function self:remove() end