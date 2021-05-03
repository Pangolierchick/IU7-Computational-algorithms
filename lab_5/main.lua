local s = require 'std.string'

function main()
    io.write("Input thau: ")
    local thau = io.read("n")

    io.write("Choose method for internal integral:\n")
    io.write("1. Simpson\n")
    io.write("2. Gauss\n")

    local internal_method = io.read("n")
    local external_method = 0

    if internal_method == 1 then
        external_method = 2
    elseif internal_method == 2 then
        external_method = 1
    else
        print('Unknown method given. Exitting')
        os.exit(1)
    end
end

main()
