local state = {}
local self = state
self.players = {}
local lobby = require "libs.player"
local particles = require "libs.particles"

function self:newPlayer(player, path)
    player.particles = particles(path, player.sprite.x, player.sprite.y, 20, 20)
    table.insert(self.players, player)
end

function self:load()
    local plr1path = "assets/images/shapes/heart.png"
    self:newPlayer(lobby("plr1", plr1path, 50, 50), plr1path)
    local plr2keys = {
        up = "up",
        down = "down",
        left = "left",
        right = "right",
        dash = "return"
    }
    local plr2path = "assets/images/shapes/bun.png"
    self:newPlayer(lobby("plr2", plr2path, 50, 50, {keybinds = plr2keys}), plr2path)
end

function self:keypressed(key)
    for _,plr in pairs(self.players) do
        plr:keypressed(key)
    end
end

function self:update(dt)
    for _,plr in pairs(self.players) do
        plr:update(dt)
        if plr.particles then
            plr.particles.x = plr.sprite.x
            plr.particles.y = plr.sprite.y
            plr.particles:update(dt)
        end
    end
end

function self:draw()
    for _,plr in ipairs(self.players) do
        plr:draw()
    end
end

return self