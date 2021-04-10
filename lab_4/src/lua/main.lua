local table_io = require "table_io"
local approx = require "approximation"

local function menu(table)
    

    -- local choice = io.read("*number")

    local choice = 0

    while choice ~= 2 do
        print("\tMenu")
        print("1. Change p in table")
        print("2. Get polynomial")
        
        io.write("\nChoice: ")
        choice = io.read("n")

        if choice == 1 then
            table = table_io.Change_weights(table)
        end
    end

    return table
end

local function main()
    print("======================= Lab 04 =======================")

    local input_file = "../../data/test.csv"
    local read_table = table_io.Read_table_from_file(input_file)

    menu(read_table)

    table_io.Dump(read_table, input_file)

    io.write("Input poly degree: ")
    local power = io.read("*number")

    local result = approx.GetMiddleFunc(read_table, power)

    local fout = io.open("../../data/output.csv", "w")

    fout:write(table.concat(result, ", "))

    print("Result: " .. table.concat(result, ", "))

    fout:close()
end

main()

