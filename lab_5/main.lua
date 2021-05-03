local int = require 'src.integrate'
local func = require 'src.func'

local function dump(filename, left, right, step) 
    local int = int.New(2, 1, GetMainFunc(left), 17, 5)
    
    local f = io.open(filename, 'w')
    
    for i = left, right, step do
        int:setFunc(GetMainFunc(i))
        local v = int:Eval(0, math.pi / 2)

        f:write(string.format('%f, %f\n', i, v))
    end

    f:close()
end

function main()
    dump('./data/simp17_gauss5.csv', 0.05, 10, 0.1)

    os.exit(0)

    local integral = int.New(nil, nil, nil, nil, nil)

    local co = coroutine.create(function (integral)
        while true do
            io.write('input n: ')
            local n = io.read("n")
    
            io.write('input m: ')
            local m = io.read('n')
    
            io.write('Input tau: ')
            local tau = io.read("n")
    
            io.write('Choose internal method (1 -- gauss; 2 -- simpson): ')
            local internal = io.read("n")
    
            io.write('Choose external method (1 -- gauss; 2 -- simpson): ')
            local external = io.read("n")
    
            integral:setN(n)
            integral:setM(m)
            integral:setInternal(internal)
            integral:setExternal(external)
            integral:setFunc(GetMainFunc(tau))
            coroutine.yield(integral:Eval(0, math.pi / 2))
        end
    end)
    
    while true do

        local _, val = coroutine.resume(co, integral)

        io.write(string.format('Integral val: %.6f\n', val))

        io.write('Contunue? (1/0): ')

        local choose = io.read("n")
        
        if choose == 0 then
            break
        end
    end
end

main()
