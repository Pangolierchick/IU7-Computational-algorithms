local approx = require 'approx'

local function main()
    local table = approx.Read_table('../data/func.csv')

    local res = approx.SolveCMatrix(table)

    print("C coeffs:")
    for index, value in ipairs(res) do
        print(value)
    end
    print("done\n")

    local a, b, c, d = approx.Spline(table)

    local near_x <const> = 1
    local x <const> = 1.23

    local y = approx.Cubic_poly(x - near_x, a[near_x + 1], b[near_x + 1], c[near_x + 1], d[near_x + 1])

    io.write(string.format('y = %.4f\n', y))
    io.write(string.format('real y = %.4f\n', x * x))
end

main()
