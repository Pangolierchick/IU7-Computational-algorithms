local matrix = require 'lib.matrix'

local approx = {}

-- a + bx + cx^2 + dx^3 ...
function approx.Cubic_poly(x, ...)
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

function approx.Read_table(filename)
    local f <close> = io.open(filename, "r")

    local func_table = {}

    for line in f:lines() do
        local row = {"x", "y"}

        row.x, row.y = line:match('(%w+.%w+), (%w+.%w+)')

        table.insert(func_table, row)
   end

   return func_table
end

local function get_e_n(main_table)
    local h = function (i)
        return main_table[i].x - main_table[i - 1].x
    end

    local f = function (i)
        return 3 * ( (main_table[i].y - main_table[i - 1].y) / h(i) - (main_table[i - 1].y - main_table[i - 2].y) / h(i - 1))
    end

    local e_table = { 0 }
    local n_table = { 0 }

    local j = 2

    for i = 3, #main_table do
        local curr_e = - (h(i) / (h(i - 1) * e_table[j - 1] + 2 * (h(i - 1) + h(i))))
        local curr_n = (f(i) - h(i - 1) * n_table[j - 1]) / (h(i - 1) * e_table[j - 1] + 2 * (h(i - 1) + h(i)))

        table.insert(e_table, curr_e)
        table.insert(n_table, curr_n)

        j = j + 1
    end

    table.insert(e_table, 0)
    table.insert(n_table, 0)

    return e_table, n_table
end

function approx.SolveCMatrix(main_table)
    local e_table, n_table = get_e_n(main_table)
    
    local c_table = { }
    c_table[#main_table] = 0

    for i = #main_table - 1, 1, -1 do
        local curr_c = e_table[i + 1] * c_table[i + 1] + n_table[i + 1]
        c_table[i] = curr_c
    end

    return c_table
end

local function get_else_coeffs(main_table, c_table)
    local a = {}
    local b = {}
    local d = {}

    local h = function (i)
        return main_table[i + 1].x - main_table[i].x
    end

    local j = 1

    for i = 2, #main_table - 1 do
        a[j] = main_table[j].y
        b[j] = (main_table[j + 1].y - main_table[j].y) / h(j) - h(j) * (c_table[j + 2] - 2 * c_table[j + 1])
        d[j] = (c_table[j + 2] - c_table[j + 1]) / (3 * h(j + 1))

        j = j + 1
    end

    table.insert(a, main_table[#main_table - 1].y)
    table.insert(b, (((main_table[#main_table].y - main_table[#main_table - 1].y) / h(#main_table - 1)) - h(#main_table - 1) * 2 * c_table[#c_table - 1] / 3))
    table.insert(d, -c_table[#c_table] / (3 * h(#main_table - 1)))

    return a, b, c_table, d
end

function approx.Spline(table)
    local C = approx.SolveCMatrix(table)
    local a, b, c, d = get_else_coeffs(table, C)

    for i = 1, #a do
        print(a[i], b[i], c[i], d[i])
    end

    return a, b, c, d
end

return approx
