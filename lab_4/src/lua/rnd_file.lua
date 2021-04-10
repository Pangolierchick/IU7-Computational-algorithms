local function line(x)
    return x + math.random(1, 10)
end

function rnd(filename)
    print("Input number of lines: ")
    local rows_number = io.read("*number")

    local f = io.open(filename, "w")

    local step = 0.75
    local start_x = 3

    for i = 1, rows_number do
        f:write(string.format("%3f %3f %1d\n", start_x, line(start_x), math.random(1, 5)))
        start_x = start_x + step
    end

    io.close(f)
end

rnd(arg[1])
