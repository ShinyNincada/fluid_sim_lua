local commonParticle = require 'class.particle'

local particlesPool = {}

particlesPool.__index = particlesPool

local function new(count)
    return setmetatable({
        count = count or 100,
        gravity = 50;
        collisionDamping = 0.7,
        boundsSize = Vector.new(1280, 720),
        particleSize = 16,
        pool = {},
    }, particlesPool)
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

function particlesPool:update(dt)
    for i = 1, #self.pool do
        self.pool[i]:update(dt)
    end
end

function particlesPool:draw()
    for i = 1, #self.pool do
        self.pool[i]:draw()
    end
end

return setmetatable({new = new},
{__call = function(_, ...) return new(...) end})
