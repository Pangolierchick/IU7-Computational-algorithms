function e_t_func(thau, theta, phi)
    local l_r = (2 * math.cos(theta)) / (1 - (math.sin(theta) ^ 2) * (math.cos(phi) ^ 2))
    return (1 - math.exp(-thau * l_r)) * math.cos(theta)
end
