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

function approx.MakeCMatrix(main_table)
    local matrix = { }

    local h = function (i)
        return main_table[i].x - main_table[i - 1].x
    end

    for i = 3, #main_table do
        local row = { 
            h(i - 1),
            2 * (h(i - 1) + h(i)),
            h(i),
            3 * (((main_table[i].y - main_table[i - 1].y) / h(i)) - ((main_table[i - 1].y - main_table[i - 2].y) / h(i))) }

        table.insert(matrix, row)
    end

    return matrix
end

local function get_e_n(main_table)
    local h = function (i)
        return main_table[i].x - main_table[i - 1].x
    end

    local f = function (i)
        return 3 * ( (main_table[i].y - main_table[i - 1].y) / h(i) - (main_table[i - 1].y - main_table[i - 2].y) / h(i - 1))
    end

    local e_table = { 0, 0 }
    local n_table = { 0, 0 }

    for i = 3, #main_table do
        local curr_e = - (h(i) / (h(i - 1) * e_table[i - 1] + 2 * (h(i - 1) + h(i))))
        local curr_n = (f(i) - h(i - 1) * n_table[i - 1]) / (h(i - 1) * e_table[i - 1] + 2 * (h(i - 1) + h(i)))

        table.insert(e_table, curr_e)
        table.insert(n_table, curr_n)
    end

    return e_table, n_table
end

function approx.SolveCMatrix(main_table)
    local e_table, n_table = get_e_n(main_table)

    local c_table = { }
    c_table[#main_table + 1] = 0

    for i = #main_table, 1, -1 do
        local curr_c = e_table[i] * c_table[i + 1] + n_table[i]

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

    for i = 1, #main_table - 1 do
        a[i] = main_table[i].y
        b[i] = (main_table[i + 1].y - main_table[i].y) / h(i) - h(i) * (c_table[i + 2] - 2 * c_table[i + 1])
    end
end

function approx.Spline(table)
    get_else_coeffs()
end

return approx
