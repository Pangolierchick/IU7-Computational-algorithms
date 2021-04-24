local approx = require 'approx'

local function main()
    local ap = approx.New('../data/func.csv')
    local my_table = ap.func_table

    print("Read table:")

    for i, v in ipairs(my_table) do
        io.write(string.format('\t%5.4f\t%5.4f\n', v.x, v.y))
    end

    local t2_s = os.clock()

    ap:GetSplines()

    io.write(string.format("Splines calculated. Estimated time: %f\n", os.clock() - t2_s))

    io.write('\nInput x: ')
    local x = io.read('*number')

    local y = ap:At(x)

    io.write(string.format("y = %f\n", y))
    io.write(string.format("real y = %f\n", x * x))
    io.write(string.format('Rel. error = %f%%\n', 100 * (math.abs(x * x - y) / x * x)))
end

main()
