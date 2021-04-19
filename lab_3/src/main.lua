local approx = require 'approx'

local function main()
    local ap = approx.New('../data/big.csv')
    local my_table = ap.func_table

    -- print("Read table:")

    -- for i, v in ipairs(table) do
    --     io.write(string.format('\t%5.4f\t%5.4f\n', v.x, v.y))
    -- end

    local t2_s = os.clock()

    ap:GetSplines()

    io.write(string.format("Splines calculated. Estimated time: %f\n", os.clock() - t2_s))

    local test = {}

    local t_s = os.clock()

    for i = 1, 1000, 0.25 do
        local data = {}
        local x = i
        -- local y = approx.Cubic_poly(x - near_x, a[near_x + 1], b[near_x + 1], c[near_x + 1], d[near_x + 1])
    
        local y = ap:At(x)
    
        -- io.write(string.format('y = %.4f\n', y))
        -- io.write(string.format('real y = %.4f\n', x * x))
        
        local abs = math.abs(y - x*x)
        local rel = (math.abs(y - x*x) / (x*x)) * 100

        data.x = x
        data.y = y
        data.abs = abs
        data.rel = rel
    
        table.insert(test, data)
        -- io.write(string.format('\nerrors:\n\tAbs: %f\tRel. %f%%\n', abs, rel))
    end

    local t_e = os.clock()

    io.write(string.format("Estimated time: %f\n", t_e - t_s))
end

main()
