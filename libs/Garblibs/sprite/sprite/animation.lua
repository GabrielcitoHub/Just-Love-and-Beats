return function(self, tag, subanimations, loop)
    local manager = self
    loop = loop or false
    local anim = {
        playing = false,
        time = 0,
        speed = 1,
        current = 1,
        loop = loop,
        frames = {},
        subanimations = subanimations or {}
    }

    function anim:play(name, speed, loop)
        anim.frames = anim.subanimations[name]
        anim.playing = true
        if speed then
            anim:setSpeed(speed)
        end
        if type(loop) ~= nil then
            anim:setLooping(loop)
        end
        if anim.started then
            anim.started()
        end
    end

    function anim:pause()
        anim.playing = false
        if anim.paused then
            anim.paused()
        end
    end

    function anim:stop()
        anim.current = 1
        anim.playing = false
        if anim.stopped then
            anim.stopped()
        end
    end

    function anim:setFrame(frame)
        anim.current = frame
    end

    function anim:setSpeed(speed)
        anim.speed = speed / 10
    end

    function anim:setLooping(loop)
        anim.looping = loop
    end

    function anim:update(dt)
        if not anim.playing or not anim.frames then return end
        if anim.current <= #anim.frames then
            anim.time = anim.time + self.speed * dt
            
            if anim.time > 1 then
                anim.time = 0
                if anim.current < #anim.frames then
                    anim.current = anim.current + 1
                else
                    if anim.ended then
                        anim.ended()
                    end
                    if anim.loop then
                        if anim.looped then
                            anim.looped()
                        end
                        anim.current = 1
                    end
                end
            end
        end
        
        manager.quad = anim.frames[anim.current] or nil
        -- print(tostring(self.quad))
    end

    function anim:remove()
        if anim.removed then
            anim.removed()
        end
        self.animations[anim.tag] = nil
    end

    self.animations[tag] = anim
    if anim.created then
        anim.created()
    end

    return anim
end