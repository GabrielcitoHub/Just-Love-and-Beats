local cache = {}
local self = cache
self.cached = {}

function self:cache(path, obj)
    local cache = self.cached[path]
    if not cache then
        cache = obj
        self.cached[path] = obj
    end

    return cache
end

function self:cacheImage(path)
    return self:cache(path, love.graphics.newImage(path))
end

function self:cacheSound(path)
    return self:cache(path, love.audio.newSource(path))
end

return self