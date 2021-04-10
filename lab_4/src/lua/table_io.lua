local table_io = {}

function table_io.Print_table(table)
    print("+--------------------------------------+")
    io.write(string.format("|%5s %10s %10s %10s|\n", "i", "x", "y", "p"))
    print("+--------------------------------------+")
    for i, v in ipairs(table) do
        io.write(string.format("|%5d %10f %10f %10.2f|\n", i, v.x, v.y, v.p))
    end

    print("+--------------------------------------+")
end


function table_io.Change_weights(table)
    while true do
        table_io.Print_table(table)

        io.write("Select row (to exit input -1): ")

        
        local row = io.read("*number")
        
        if (row == -1) then
            break
        end

        io.write("Input weight: ")

        local new_weight = io.read("*number")
        
        table[row].p = new_weight
    end

    print("Done.")

    return table
end


function table_io.Read_table_from_file(filename)
    local file_table = {}
    for lines in io.lines(filename) do

        local nums = {}
        for num in lines:gmatch("%S+") do
            table.insert(nums, num)
        end

        local record = {x = nums[1], y = nums[2], p = nums[3]}

        table.insert(file_table, record)
    end

    return file_table
end

function table_io.Dump(t, filename)
    local f = io.open(filename, "w")
    
    for index, value in ipairs(t) do
        f:write(string.format("%5f %5f %1d\n", value.x, value.y, value.p))
    end

    f:close()
end



return table_io
