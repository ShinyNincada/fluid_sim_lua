local particle = {}
particle.__index = particle



local function new(position, gravity, boundsSize, particleSize, collisionDamping)
	return setmetatable({position = position, velocity = Vector(), gravity = gravity or 50, boundsSize = boundsSize or Vector.new(1280, 720), size = particleSize or 16, damp = collisionDamping or 0.7}, particle)
end

function particle:update(dt)
    self.velocity  =  self.velocity + Vector.down * self.gravity * dt
    self.position = self.position + self.velocity * dt
    self:resolveCollision()
end

function particle:resolveCollision()
    assert(Vector.isvector(self.boundsSize), "Add: wrong argument types (<vector> expected)")
    local halfBoundSize = self.boundsSize / 2 - Vector.new(1, 1) * self.size
    if(math.abs(self.position.x) > halfBoundSize.x ) then 
        self.position.x  = halfBoundSize.x * math.sign(self.position.x)
        self.velocity = self.velocity * -1 * self.damp
    end
    if(math.abs(self.position.y) > halfBoundSize.y) then
        self.position.y = halfBoundSize.y * math.sign(self.position.y);
        self.velocity = self.velocity * -1 * self.damp
    end
end

function particle:SmoothingKernel()
    local radius = self.size / 2;
    local value = math.max(0, radius - radius)
end

function particle:draw()
    -- love.graphics.setShader(self.shader)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.position.x, self.position.y, self.size)
    love.graphics.setColor(0, 0, 0)
    -- love.graphics.setShader()
end

-- the module
return setmetatable({new = new},
	{__call = function(_, ...) return new(...) end})