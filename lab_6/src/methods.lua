local diff_methods = {}


function diff_methods.left_side(vals, step, ind)
    if step == 0  or ind <= 1 then
        return nil    
    end

    return (vals[ind].y - vals[ind - 1].y) / step
end

function diff_methods.right_side(vals, step, ind)
    if step == 0 or ind + 1 > #vals then
        return nil
    end

    return (vals[ind + 1].y - vals[ind].y) / step
end

function diff_methods.center_side(vals, step, ind)
    if step == 0 or ind + 1 > #vals or ind <= 1 then
        return nil
    end

    return (vals[ind + 1].y - vals[ind - 1].y) / (2 * step)
end

function diff_methods.second_diff(vals, step, ind)
    if step == 0 or ind + 1 > #vals or ind <= 1 then
        return nil
    end

    return (vals[ind + 1].y - 2 * vals[ind].y + vals[ind - 1].y) / (step ^ 2)
end


function diff_methods.runge_left(vals, step, ind)
    if ind < 3 then
        return nil
    end

    local f1 = diff_methods.left_side(vals, step, ind)
    local f2 = (vals[ind].y - vals[ind - 2].y) / 2 / step

    return f1 + f1 - f2
end

function diff_methods.align_vars(vals, step, ind)
    if ind < 1 or ind >= #vals then
        return nil
    end

    local diff = ((1 / vals[ind + 1].y) - (1 / vals[ind].y)) / 
                 ((1 / vals[ind + 1].x) - (1 / vals[ind].x))

    return (diff * (vals[ind].y ^ 2)) / (vals[ind].x ^ 2)
end

return diff_methods
