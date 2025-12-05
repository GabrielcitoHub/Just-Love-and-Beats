Sprite = require "init"
local sprites = {}
local testlayer = Sprite:newLayer("Test", 5)
local assetspath = "assets/images/"

local function newtest()
    local sprite = Sprite:new("test",assetspath .. "numbers.png", 30, 30)
    sprite:setScale(5)
    local anim = sprite:newAnimation("json",assetspath .. "numbers.json", true)
    anim:play("numbers", 120)

    local sprite2 = Sprite:new("test2",assetspath .. "numbers2.png", 200, 30)
    sprite2:setScale(5)
    local anim2 = sprite2:newAnimation("xml",assetspath .. "numbers.xml", true)
    anim2:play("green")

    local car = Sprite:new("car",assetspath .. "car.png", 200, 30)
    car:setZOrder(2)
    car:setScale(5)
    car:center()
    local anim3 = car:newAnimation("xml",assetspath .. "car.xml", true)
    anim3:play("car", 60)

    testlayer:addSprite(car)
end

local function new()
    local name = "test" .. (love.math.random(1,999999) + os.time())
    local sprite = Sprite:new(name,assetspath .. "car.png", love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()))
    local anim3 = sprite:newAnimation("xml",assetspath .. "car.xml", true)
    anim3:play("car", 60)
    sprite.speedx = 20
    sprite.speedy = 20
    sprite:disableDT(false)
    sprite:setScale(love.math.random(1,10)/10)
    sprite.mirrored = (love.math.random(1,2) == 1 and true) or false
    sprite.flipped = (love.math.random(1,2) == 1 and true) or false
    local spr = {sprite, 3}

    testlayer:addSprite(sprite)
    table.insert(sprites, spr)
end

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    new()
    newtest()
end

function love.mousemoved(_, _, dx, dy)
    for _,sprite in pairs(sprites) do
        local spr = sprite[1]
        spr.speedx = spr.speedx + dx
        spr.speedy = spr.speedy + dy
    end
end

function love.update(dt)
    -- testlayer:setVisible(false)
    -- testlayer:setActive(false)
    new()
    
    local removesprites = {}
    for i,sprite in pairs(sprites) do
        local spr = sprite[1]
        local lifetime = sprite[2]
        local scalespeed = (spr.sx / spr.sy) * 2
        spr.x = spr.x + 20 * dt
        spr.y = spr.y + 20 * dt
        spr.speedx = spr.speedx - (love.math.random(2000)/100) * (lifetime/10) * scalespeed
        spr.speedy = spr.speedy - (love.math.random(2000)/100) * (lifetime/10) * scalespeed
        if lifetime > 0 then
            lifetime = lifetime - 1 * dt
            sprite[2] = lifetime
        else
            local removed = spr:remove()
            if removed then
                table.insert(removesprites, i)
                -- print("Sprite removed!")
            end
        end
    end

    for _,i in pairs(removesprites) do
        sprites[i] = nil
    end

    Sprite:update(dt)
end

function love.draw()
    love.graphics.clear({1,1,1})
    love.graphics.setColor(1,1,1)
    local drawnSprites = {} or Sprite:draw()
    local drawnSprites = testlayer:draw()
    love.graphics.setColor(0,0,0)

    local total = 0
    for _,_ in pairs(testlayer.sprites) do
        total = total + 1
    end

    local drawn = 0
    if type(drawnSprites) == "table" then
        for _,_ in pairs(drawnSprites) do
            drawn = drawn + 1
        end
    end

    -- love.graphics.print(tostring(love.timer.getFPS()) .. " Sprites: " .. total .. " Drawn: " .. drawn)
    love.graphics.print(tostring(love.timer.getFPS()) .. " Sprites: " .. total .. " Drawn: " .. drawn)
end