-- FireworkStar.lua

---@class FireworkStarParams
---@field destroyAt number The tick at which the Firework Star should be destroyed

---@class FireworkStar : ShapeClass
---@field effects Effect[]
---@field params? FireworkStarParams
FireworkStar = class()



function FireworkStar:cl_onInit()
    self.effects = {}

    do
        local effect = sm.effect.createEffect("Firework Star - Sparks", self.shape.interactable)
        effect:setParameter("Color", self.shape.color)
        effect:start()
        table.insert(self.effects, effect)
    end
end

function FireworkStar:server_onFixedUpdate( timeStep )
    if not self.params then return end

    if sm.game.getCurrentTick() >= self.params.destroyAt then
        self.shape:destroyPart(0)
    end
end

function FireworkStar:cl_onDestroy()
    for _, effect in pairs(self.effects) do
        effect:destroy()
    end
    self.effects = {}
end



function FireworkStar:client_onCreate()
    self:cl_onInit()
end

function FireworkStar:client_onRefresh()
    self:cl_onInit()
end

function FireworkStar:client_onDestroy()
    self:cl_onDestroy()
end
