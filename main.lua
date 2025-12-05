local Cur_Night = 1
_G.stateManager = require("libs/stateManager")
_G.Sprite = require("libs.Garblibs.sprite")
_G.json = require("libs/json")
_G.soundManager = require("libs/soundManager")
soundManager:setFolder("sounds","assets/sounds")
soundManager:setFolder("music","assets/music")
FPS = require("libs/FPS")
Timer = require("libs/timer")
Utils = require("libs/utils")
_G.settings = {}

SHADERS = {}
SHADERS.white = "assets/shaders/white.glsl"

for key,shader in pairs(SHADERS) do
    SHADERS[key] = love.graphics.newShader(shader)
end

function _G.loadSettings(cfg)
    for _,opt in ipairs(cfg) do
        local name = opt.name
        local value = opt.value

        settings[name] = value
    end
end

local function setupStateManager(stsManager)
    if not stsManager then return end
    function stsManager:load(state)
        Sprite.sprites = {}
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    setupStateManager(stateManager)
    
    --G.audio = require("resources/libs/wave")

    -- Load setup

    -- Loads the settings
    -- stateManager:loadState("options")

    -- Loads the first state
    stateManager:loadState("menu")
end

function love.update(dt)
    Sprite:update(dt)
    Timer.update(dt)
    stateManager:update(dt)
    Utils:updateTweens(dt)
end

function love.keypressed(key)
    stateManager:keypressed(key)
end

function love.draw()
    -- Sprite:draw()
    stateManager:draw()

    if not settings["Show FPS"] then return end
    local fps = FPS:getFps()

    if fps < 10 then
        love.graphics.setColor(1, 0, 0)
    elseif fps < 20 then
        love.graphics.setColor(1, 0.5, 0.5)
    else
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.print("FPS: "..fps, 0, 0)

    love.graphics.setColor(1, 1, 1)
    -- love.graphics.print("This is a test", 300, 400)
end

function love.quit()
    -- save()
end