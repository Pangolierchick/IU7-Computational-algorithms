approx = require 'approx'

local function main()
    local table = approx.Read_table('../data/func.csv')

    local test = approx.MakeCMatrix(table)

    -- for i, v in ipairs(test) do
    --     for j, k in ipairs(v) do
    --         io.write(k .. " ")
    --     end

    --     io.write("\n")
    -- end

    local res = approx.SolveCMatrix(table)

    for index, value in ipairs(res) do
        print(value)
    end
end

main()
