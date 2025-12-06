-- Load libraries
FPS = require("libs/FPS")
Timer = require("libs/timer")
Utils = require("libs/utils")
_G.stateManager = require("libs/stateManager")
_G.Sprite = require("libs.Garblibs.sprite")
_G.json = require("libs/json")
_G.soundManager = require("libs/soundManager")

-- Load sound paths
soundManager:setFolder("sounds","assets/sounds")
soundManager:setFolder("music","assets/music")


-- Load shaders
_G.settings = {}
SHADERS = {}
SHADERS.white = "assets/shaders/white.glsl"

for key,shader in pairs(SHADERS) do
    SHADERS[key] = love.graphics.newShader(shader)
end

-- Load settings
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

    -- Loads the options and first state
    stateManager:loadState("options")

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
    FPS:draw()
end