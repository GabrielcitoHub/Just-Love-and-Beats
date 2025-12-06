local fps = {}

function fps:getFps()
    return love.timer.getFPS()
end

function fps:draw()
    local Fps = fps:getFps()
    if Fps < 10 then
        love.graphics.setColor(1, 0, 0)
    elseif fps < 20 then
        love.graphics.setColor(1, 0.5, 0.5)
    else
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.print("FPS: "..Fps, 0, 0)

    love.graphics.setColor(1, 1, 1)
end

return fps