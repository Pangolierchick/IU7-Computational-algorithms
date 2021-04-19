local matrix = require 'lib.matrix'

local approx = {
    func_table = nil,
    splines = {"a", "b", "c", "d"},
}

approx.__index = approx

function approx.New(filename)
    local self = setmetatable({}, approx)

    self.func_table = self:Read_table(filename)

    return self
end

-- a + bx + cx^2 + dx^3 ...
function approx:Cubic_poly(x, ...)
    local res = 0
    local arg = {...}

    for index, value in ipairs(arg) do
        if index == 1 then
            res = value
        else
            res = res + value * (x ^ (index - 1))
        end
    end

    return res
end

function approx:Read_table(filename)
    local f = io.open(filename, "r")

    local func_table = {}

    for line in f:lines() do
        local row = {"x", "y"}

        row.x, row.y = line:match('(%w+.%w+), (%w+.%w+)')

        table.insert(func_table, row)
    end

    self.func_table = func_table

    f:close()

    return func_table
end

function approx:Nearest(x)
    local x_min = math.abs(self.func_table[1].x - x)
    local ind = 1

    for i = 2, #self.func_table do
        if x_min > math.abs(self.func_table[i].x - x) then
            ind = i
            x_min = math.abs(self.func_table[i].x - x)
        end
    end

    return ind
end

function approx:GetSplines()
    local h = { 0 }

    local tmp_a = { 0 }
    local tmp_b = { 0 }
    local tmp_d = { 0 }
    local f     = { 0 }

    local y = function (i)
        return self.func_table[i].y
    end

    local xi   = { 0, 0, 0 }
    local etha = { 0, 0, 0 }

    for i = 2, #self.func_table do
        table.insert(h, self.func_table[i].x - self.func_table[i - 1].x)
        if i < 3 then
            table.insert(tmp_a, 0)
            table.insert(tmp_b, 0)
            table.insert(tmp_d, 0)
            table.insert(f, 0)
        else
            table.insert(tmp_a, h[i - 1])
            table.insert(tmp_b, -2 * (h[i - 1] + h[i]))
            table.insert(tmp_d, h[i])
            table.insert(f, -3 * ((y(i) - y(i - 1)) / h[i] - (y(i - 1) - y(i - 2)) / h[i - 1]))

            xi[i + 1]   = tmp_d[i] / (tmp_b[i] - tmp_a[i] * xi[i])
            etha[i + 1] = (tmp_a[i] * etha[i] + f[i]) / (tmp_b[i] - tmp_a[i] * xi[i])
        end

    end

    local c = {}
    c[#self.func_table + 1] = 0
    c[#self.func_table] = 0

    for i = #self.func_table - 1, 1, -1 do
        c[i] = xi[i + 1] * c[i + 1] + etha[i + 1]
    end

    local a = { 0 }
    local b = { 0 }
    local d = { 0 }

    for i = 2, #self.func_table do
        table.insert(a, y(i - 1))
        table.insert(b, (y(i) - y(i - 1)) / h[i] - h[i] / 3 * (c[i + 1] + 2 * c[i]))
        table.insert(d, (c[i + 1] - c[i]) / (3 * h[i]))
    end

    self.splines.a = a
    self.splines.b = b
    self.splines.c = c
    self.splines.d = d

    return a, b, c, d
end

function approx:At(x)
    assert(self.splines.a ~= nil, 'splines havent been setted yet')

    local near_i = self:Nearest(x)

    local x_near_i = math.max(near_i - 1, 1)

    return self:Cubic_poly(x - self.func_table[x_near_i].x,   self.splines.a[near_i],
                                                              self.splines.b[near_i],
                                                              self.splines.c[near_i],
                                                              self.splines.d[near_i])
end

return approx
