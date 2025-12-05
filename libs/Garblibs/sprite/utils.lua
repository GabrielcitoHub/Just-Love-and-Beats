local utils = {}
local self = utils
local json
local xml

function self:setCWD(cwd)
    self.cwd = cwd
    json = require(self.cwd .. "libs.json")
    xml = require(self.cwd .. "libs.xml")
end

function self:parseJSON(raw)
    return json.decode(raw)
end

function self:parseXML(raw)
    return xml.decode(raw)
end

function self:sortQuads(raw)
    local quads = {}

    table.sort(raw, function(a, b)
        return a.num < b.num
    end)

    for i,quadobj in ipairs(raw) do
        -- print(tostring(i))
        table.insert(quads, quadobj.quad)
    end

    return quads
end

function self:parseData(data, image, type)
    local quadsraw = {}
    local subanims = {}
    local subanimsnames = {}

    if data.frames then
        for framename,framedata in pairs(data.frames) do
            local name, num, ext
            local frame
            local quadobj
            local prefix

            if type == "json" then
                name, num, ext = framename:match("^(.*)%s+(%d+)%.([^.]+)$")
                frame = framedata.frame
            elseif type == "xml" then
                frame = framedata
                name, num = framename:match("^(.-)(%d+)$")
                -- print(num)
            end
            quadobj = love.graphics.newQuad(frame.x, frame.y, frame.w, frame.h, image:getWidth(), image:getHeight())

            local quad = {
                anim = name,
                frame = frame,
                num = tonumber(num),
                quad = quadobj
            }
            subanimsnames[name] = num
            -- print(quad.num .. " " .. quad.anim)

            -- print(num .. " \"" .. framename .. "\" x: " .. frame.x .. " y: " .. frame.y .. " w: " .. frame.w .. " h: " .. frame.h)
            table.insert(quadsraw,quad)
        end

        for sub,_ in pairs(subanimsnames) do
            local frames = {}
            for i,quad in pairs(quadsraw) do
                if quad.anim == sub then
                    table.insert(frames, quad)
                end
            end
            subanims[sub] = self:sortQuads(frames)
            -- print(sub .. " frames: " .. #frames)
        end

        return subanims
    end
end

function self:pathToQuads(image, path, type)
    local quads = {}

    if type == "json" then
        local raw = love.filesystem.read(path)
        local data = self:parseJSON(raw)
        quads = self:parseData(data, image, type)
    elseif type == "xml" then
        local raw = love.filesystem.read(path)
        local data = self:parseXML(raw)
        quads = self:parseData(data, image, type)
    elseif type == "quad" or type == "quads" then
        quads = path
    end

    return quads
end

return self