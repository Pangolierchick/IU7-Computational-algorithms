function GetMainFunc(thau)
    local l_r = function (x, y) return (2 * math.cos(x)) / (1 - (math.sin(x) ^ 2) * (math.cos(y) ^ 2)) end
    return function(x, y) return (4 / math.pi) * (1 - math.exp(-thau * l_r(x, y))) * math.cos(x) * math.sin(x) end
end
