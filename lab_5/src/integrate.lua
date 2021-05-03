local integrate = {
    tab = {},
    precision = 1e-3
}

integrate.__index = integrate

function integrate:New()
    local self = setmetatable({}, integrate)

    return self
end

function integrate:SetPrecision(pres)
    self.precision = pres
end

function integrate:Add(x, y)
    local val = { x = x, y = y }
    table.insert(self.tab, val)
end

function integrate:Simpson()
    
end

function integrate:Gauss()

end

return integrate
