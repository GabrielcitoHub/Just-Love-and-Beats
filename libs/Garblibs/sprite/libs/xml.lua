local xml = {}
local self = xml

function self.decode(str)
    local atlas = {frames = {}}

    -- Get the image path
    atlas.imagePath = str:match('imagePath="(.-)"')

    -- Iterate over each SubTexture tag
    for name, x, y, width, height, frameX, frameY, frameWidth, frameHeight in str:gmatch(
        '<SubTexture%s+name="(.-)"%s+x="(.-)"%s+y="(.-)"%s+width="(.-)"%s+height="(.-)"%s*frameX="(.-)"?%s*frameY="(.-)"?%s*frameWidth="(.-)"?%s*frameHeight="(.-)"?%s*/>'
    ) do
        -- Convert to numbers where possible
        local frame = {
            x = tonumber(x),
            y = tonumber(y),
            w = tonumber(width),
            h = tonumber(height)
        }

        if frameX ~= "" then
            frame.frameX = tonumber(frameX)
            frame.frameY = tonumber(frameY)
            frame.frameWidth = tonumber(frameWidth)
            frame.frameHeight = tonumber(frameHeight)
        end

        atlas.frames[name] = frame
    end

    return atlas
end

return self