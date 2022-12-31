-- MortarTube.lua

---@class MortarTube : ShapeClass
---@field isActive boolean
MortarTube = class()
MortarTube.colorHighlight = sm.color.new( 0xFF8080FF )
MortarTube.colorNormal = sm.color.new( 0xFF0000FF )
MortarTube.connectionInput = sm.interactable.connectionType.logic
MortarTube.connectionOutput = sm.interactable.connectionType.none
MortarTube.maxChildCount = 0
MortarTube.maxParentCount = 1

function MortarTube:server_onCreate()
    self.isActive = false
end

function MortarTube:server_onFixedUpdate( timeStep )
    local parentActive = false
    for _, parent in ipairs( self.interactable:getParents(sm.interactable.connectionType.logic) ) do
        if parent.active then
            parentActive = true
            break
        end
    end

    if self.isActive ~= parentActive and parentActive then
        self:sv_launch()
    end

    self.isActive = parentActive
end

function MortarTube:sv_launch()
    local direction = self.shape.worldRotation * sm.vec3.new( 0, 0, 1 )
    local position = self.shape.worldPosition - sm.vec3.one() * sm.construction.constants.subdivideRatio_2 + direction * 0.75
    local velocity = direction * 40

    ---@type FireworkChargeParams
    local params = {
        stars = {
            { star = { color = sm.color.new( 0xFF0000FF ) }, count = 50 },
            { star = { color = sm.color.new( 0xFF00FFFF ) }, count = 25 },
            { star = { color = sm.color.new( 0xFF80FFFF ) }, count = 25 },
        },
        explodeAt = sm.game.getCurrentTick() + 40 * 3,
        explodeVelocity = 10,
    }

    local shape = sm.shape.createPart( obj_firework_charge, position, self.shape.worldRotation, true, true )
    shape.interactable:setParams( params )
    sm.physics.applyImpulse( shape, velocity * shape.mass, true )
end