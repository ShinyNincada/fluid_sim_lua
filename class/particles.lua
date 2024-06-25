local commonParticle = require 'class.particle'

local particlesPool = {}

particlesPool.__index = particlesPool
particlesPool.shader = love.graphics.newShader[[
    extern vec2 resolution;
    extern vec2 center;
    extern float radius;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec2 pos = center/resolution;
        float dist = length(pos);
        if (dist < radius) {
            return vec4(color.rgb, 1.0); // Inside the circle
        } else {
            return vec4(1.0, 1.0, 0.0, 1.0); // Outside the circle  
        }
    }

]]


local function new(count)
    local base = setmetatable({
        count = count or 100,
        gravity = 50;
        collisionDamping = 0.7,
        boundsSize = Vector.new(720, 480),
        particleSize = 16,
        influence = 10,
        pool = {},
    }, particlesPool)

     -- Set initial parameters for the shader
    base.shader:send("resolution", {love.graphics.getWidth(), love.graphics.getHeight()})
    base.shader:send("center", {love.graphics.getWidth(), love.graphics.getHeight()})
    base.shader:send("radius", 1.42) -- Circle radius as a fraction of the screen width
    return base
end

function particlesPool:init()
    local halfBoundSize = self.boundsSize / 2 - Vector.new(1, 1) * self.particleSize
    local particlesPerRow = math.floor(math.sqrt(self.count))
    local particlesPerColumn = math.ceil(self.count / particlesPerRow)
    local spacingX = (self.boundsSize.x - self.particleSize * 2) / (particlesPerRow - 1)
    local spacingY = (self.boundsSize.y - self.particleSize * 2) / (particlesPerColumn - 1)

    for i = 0, self.count - 1 do
        local row = i % particlesPerRow
        local col = math.floor(i / particlesPerRow)
        local x = -halfBoundSize.x + spacingX * row + self.particleSize
        local y = -halfBoundSize.y + spacingY * col + self.particleSize
        table.insert(self.pool, commonParticle(Vector(x, y), self.gravity, self.boundsSize, self.particleSize, self.collisionDamping))
    end
end

function particlesPool:calculationDensity(samplePoint)
    assert(Vector.isvector(samplePoint), "Add: wrong argument types (<vector> expected)")

    local density = 0
    local mass = 1
    
    for _, par in ipairs(self.pool) do
        local dst = (par.position )
        par:SmoothingKernel()
        density =  density + mass * self.influence
    end

    return density
end

function particlesPool:update(dt)
    for i = 1, #self.pool do
        self.pool[i]:update(dt)
    end
end

function particlesPool:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", - self.boundsSize.x/2, - self.boundsSize.y/2, self.boundsSize.x, self.boundsSize.y)
    -- love.graphics.circle("fill", position.x, position.y, particleSize)
    love.graphics.setShader(self.shader)
    for i = 1, #self.pool do
        self.pool[i]:draw()
    end
    love.graphics.setShader()
    love.graphics.setColor(0, 0, 0)
end

return setmetatable({new = new},
{__call = function(_, ...) return new(...) end})
