local matrix = require "matrix_lib/matrix"

local approx = {}

local function xkxm(table, k, m)
    local sum = 0

    for i = 1, #table do
        sum = sum + table[i].p * (table[i].x ^ (k + m))
    end

    return sum
end

local function yxk(table, k)
    local sum = 0

    for i = 1, #table do
        sum = sum + table[i].p * table[i].y * (table[i].x ^ k)
    end

    return sum
end

function approx.FormMatrix(vals, k)
    local matrix = {}
    local vec = {}

    for i = 0, k do
        local row = {}
        for j = 0, k do
            local cell = xkxm(vals, i, j)
            table.insert(row, cell)
        end

        table.insert(matrix, row)
        table.insert(vec, yxk(vals, i))
    end

    return matrix, vec
end

function approx.GetMiddleFunc(table, k)
    local matrix, vec = approx.FormMatrix(table, k)

    return approx.Cramer(matrix, vec)
end

-- https://rosettacode.org/wiki/Cramer%27s_rule#Lua
function approx.Cramer(mat, vec)
    assert(#mat == #mat[1], "Matrix is not square!")
    assert(#mat == #vec, "Vector has not the same size of the matrix!")

    local size = #mat
    local main_det = matrix.det(mat)

    local aux_mats = {}
    local dets = {}
    local result = {}

    for i = 1, size do
        aux_mats[i] = matrix.copy(mat)
        for j = 1, size do
        aux_mats[i][j][i] = vec[j]
        end

        dets[i] = matrix.det(aux_mats[i])

        result[i] = dets[i] / main_det
    end

    return result
end

return approx
