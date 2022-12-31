-- FireworkStar.lua

---@class FireworkStar : ShapeClass
---@field effects Effect[]
FireworkStar = class()



function FireworkStar:cl_onInit()
    self.effects = {}

    do
        local effect = sm.effect.createEffect("Firework Star - Sparks", self.shape.interactable)
        effect:setParameter("Color", sm.color.new(0xFF0000FF))
        effect:start()
        table.insert(self.effects, effect)
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
