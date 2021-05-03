local gauss = require 'src.legauss'
local simpson = require 'src.simpson'


local integrate = {
    tab = {},
    precision = 1e-3,
    internal = 0,
    external = 0,
    internal_nodes = 3,
    external_nodes = 3,
    func = nil
}

integrate.__index = integrate

METHODS = { Legauss, Simpson }

local function from2to1(x, func)
    return function (y)
        return func(x, y)
    end
end

function integrate.New(internal, external, func, int_nodes, ext_nodes)
    local new = setmetatable({}, integrate)

    new.internal = internal
    new.external = external
    new.func     = func
    new.internal_nodes = int_nodes
    new.external_nodes = ext_nodes

    return new
end

function integrate:SetPrecision(pres)
    self.precision = pres
end

function integrate:Add(x, y)
    local val = { x = x, y = y }
    table.insert(self.tab, val)
end

function integrate:Simpson(func, a, b, nodes)
    return simpson.Simpson(func, a, b, nodes)
end

function integrate:Gauss(func, a, b, nodes)
    return gauss.Legauss(func, a, b, nodes)
end

function integrate:setFunc(func)
    self.func = func
end

function integrate:setInternal(internal)
    self.internal = internal
end

function integrate:setExternal(external)
    self.external = external
end

function integrate:setN(n)
    self.external = n
end

function integrate:setM(m)
    self.internal = m
end

function integrate:Eval(a, b)
    if self.func == nil then
        io.stderr:write('Error. Func not setted\n')
        return nil
    end

    local inner = function (x)
        return METHODS[self.internal](from2to1(x, self.func), a, b, self.internal_nodes)
    end

    return METHODS[self.external](inner, a, b, self.external_nodes)
end

return integrate
