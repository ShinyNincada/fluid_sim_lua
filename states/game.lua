local game = {}
local mainCam = Camera.new(0, 0)
local particlePool = Particle(100)

function game:init()
    mainCam.lookAt(self, 0, 0)
    particlePool:init()
end

-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end

function game:enter()
end

function game:update(dt)
    particlePool:update(dt)
end

function game:keypressed(key, code)
    -- if key == "=" or key == "+" then
    --     particleSize = particleSize + 1
    -- elseif key == "-" then
    --     particleSize = particleSize - 1
    -- end
end

function game:mousepressed(x, y, mbutton)

end

function game:draw()
    mainCam:attach()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", - particlePool.boundsSize.x/2, - particlePool.boundsSize.y/2, particlePool.boundsSize.x, particlePool.boundsSize.y)
        -- love.graphics.circle("fill", position.x, position.y, particleSize)
        love.graphics.setColor(0, 0, 0)
        particlePool:draw()
    mainCam:detach()
end

return game
