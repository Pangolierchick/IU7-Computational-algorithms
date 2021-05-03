function Simpson(func, a, b, nodes)
    if a > b then
        io.stderr:write('Error, left bound is bigger than right')
        return nil
    end
    
    local step = (b - a) / (nodes - 1)
    
    local res = 0
    local x = a
    
    for i = 1, (nodes - 1) / 2 do
        res = res + func(x) + 4 * func(x + step) + func(x + 2 * step)
        x = x + 2 * step
    end


    return res * (step / 3)
end
