local spritemanager = {}
local self = spritemanager

-- Enable while testing main.lua
self.debug = false

self.cwd = ""
if not self.debug then
    self.cwd = (...):gsub('%.init$', '') .. "."
end
Cache = Cache or require(self.cwd .. "cache")
self.sprites = {}
self.layers = {}

function self:_new(tag, path, x, y)
    local spr = require(self.cwd .. "objects.sprite")(tag, path, x, y, {manager = self})
    spr:load()

    return spr
end

function self:_newLayer(tag, order, sprites)
    local layer = require(self.cwd .. "objects.layer")(tag, order, sprites, {manager = self})
    layer:load()

    return layer
end

-- Creates a new sprite and loads it into the module
function self:new(tag, path, x, y)
    local spr = self:_new(tag, path, x, y)
    self.sprites[tag] = spr

    return spr
end

-- Creates a new layer and loads it into the module
function self:newLayer(tag, order, sprites)
    local layer = self:_newLayer(tag, order, sprites)
    self.layers[tag] = layer
    
    return layer
end

-- Calls a function for each object
function self:forObjects(objects, func, ordered, ordervalue)
    ordered = ordered or false
    local orderedObjects = {}
    if ordered then
        for _, sprite in pairs(objects) do
            table.insert(orderedObjects, sprite)
        end

        table.sort(orderedObjects, function(a, b)
            return a[ordervalue] < b[ordervalue]
        end)

        for _, sprite in ipairs(orderedObjects) do
            func(sprite)
        end
    else
        for _, sprite in pairs(objects) do
            func(sprite)
        end
    end
end

-- Calls a function for each sprite
function self:forSprites(func, ordered)
    self:forObjects(self.sprites, func, ordered, "zorder")
end

-- Calls a function for each layer
function self:forLayers(func, ordered)
    self:forObjects(self.layers, func, ordered, "order")
end

-- Updates the sprite library
function self:update(dt)
    self:forSprites(function(sprite)
        if sprite.update and not sprite.layer then
            sprite:update(dt)
            -- print(sprite.tag .. " Updated")
        end
    end)
    self:forLayers(function(layer)
        if layer.update then
            layer:update(dt)
            -- print(layer.tag .. " Updated")
        end
    end)
end

-- Draws all sprites and layers
function self:draw()
    local drawnSprites = {}
    local drawnLayers = {}
    self:forSprites(function(sprite)
        if sprite.draw and not sprite.layer then
            if sprite:draw() then
                drawnSprites[sprite.tag] = sprite
                -- print(sprite.tag .. " Drawn")
            end
        end
    end, true)
    self:forLayers(function(layer)
        if layer.draw then
            if layer:draw() then
                drawnLayers[layer.tag] = layer
                -- print(layer.tag .. " Drawn")
            end
        end
    end, true)
    return drawnSprites, drawnLayers
end

return self