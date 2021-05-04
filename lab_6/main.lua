local prettytable = require 'src.prettytable'
local derivative  = require 'src.methods' 

function main()
    local x = { 1, 2, 3, 4, 5, 6 }
    local y = { 0.571, 0.889, 1.091, 1.231, 1.333, 1.412 }

    local vals = {}

    for i = 1, #x do
        local row = {}
        row.x = x[i]
        row.y = y[i]

        table.insert(vals, row)
    end

    local methods = { derivative.left_side, derivative.center_side, derivative.runge_left, derivative.align_vars, derivative.second_diff }


    local prettyTable = prettytable.new()

    prettyTable:setColumns({'x', 'y', 'Left', 'Right', 'Runge', 'Alignment', 'Second diff'})

    for i = 1, #x do
        local row = {x[i], y[i]}
        for j = 3, 7 do
            row[j] = methods[j - 2](vals, x[2] - x[1], i)
            if row[j] == nil then
                row[j] = '---'
            end
        end

        prettyTable:addRow(row)
    end

    prettyTable:print()
end

main()
