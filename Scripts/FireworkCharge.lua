-- FireworkCharge.lua

dofile("parts.lua")

---@class FireworkChargeParams
---@field stars { star: FireworkStarConfiguration, count: number }[]
---@field explodeAt number
---@field explodeVelocity number

---@class FireworkCharge : ShapeClass
---@field params FireworkChargeParams
FireworkCharge = class()


local up = sm.vec3.new( 0, 0, 1 )
local radius = 1

---Create a Firework Star
---@param fireworkStarParams FireworkStarParams
function FireworkCharge:sv_createStar( fireworkStarParams )
    local center = self.shape.worldPosition + self.shape:getBoundingBox() * 0.5

    local direction = sm.noise.gunSpread( up, 360 )
    local velocity = direction * 20
    local position = center + direction * radius

    -- local body = sm.body.createBody( self.shape.worldPosition, self.shape.worldRotation, true )
    -- local shape = body:createPart( obj_firework_star, sm.vec3.zero(), up, up, true )
    local shape = sm.shape.createPart( obj_firework_star, position, self.shape.worldRotation, true, false )
    sm.physics.applyImpulse( shape, velocity * shape.mass, true )
    shape.color = fireworkStarParams.color

    shape.interactable:setParams(fireworkStarParams)
end

function FireworkCharge:sv_explode()
    for _, star in ipairs( self.params.stars ) do
        for i = 1, star.count do
            ---@type FireworkStarParams
            local starParams = {
                destroyAt = sm.game.getCurrentTick() + 40 * 5,
            }

            for k, v in pairs( star.star ) do
                starParams[k] = v
            end

            self:sv_createStar( starParams )
        end
    end
end

function FireworkCharge:server_onFixedUpdate( timeStep )
    if not self.params then
        self.shape:destroyPart(0)
        return
    end

    if sm.game.getCurrentTick() >= self.params.explodeAt then
        self:sv_explode()
        self.shape:destroyPart(0)
    end
end

---Called when the [Shape] is hit by an explosion.  
---For more information about explosions, see [sm.physics.explode].  
---@param center Vec3 The center of the explosion.
---@param destructionLevel integer The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
function FireworkCharge:server_onExplosion( center, destructionLevel )
    self:sv_explode()
end

---Called when the [Shape] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit the [Shape].
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player/Unit/Shape/Harvestable/nil The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param uuid Uuid The uuid of the projectile.
function FireworkCharge:server_onProjectile( position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid )
    self:sv_explode()
end
