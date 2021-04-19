local function x_sqr(x)
    return x * x
end


-- l - left bound
-- r - right bound
-- s - step
local function make_table(filename, l, r, s)
    local f <close> = io.open(filename, "w")

    for i = l, r, s do
        f:write(string.format("%f, %f\n", i, x_sqr(i)))
    end
end

local function main()
    if type(arg[1]) == "nil" then
        print("No filename given. \n Help: lua func_table 'filename'")
        return
    end

    print("Creating file", arg[1])

    local left  <const> = 0
    local right <const> = 1000
    local step  <const> = 1

    local s_time = os.clock()

    make_table(arg[1], left, right, step)

    local e_time = os.clock()

    print("Done")
    io.write(string.format("Estimated time: %fus\n", e_time - s_time))
end

main()
