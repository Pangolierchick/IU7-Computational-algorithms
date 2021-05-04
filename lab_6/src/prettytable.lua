LEFT_ALIGNMENT  = 1
RIGHT_ALIGNMENT = -1

local prettyTable = {
    columns = {},
    rows    = {},
    extra_space = 3,
    round_digits = 4,
    alignment = RIGHT_ALIGNMENT,
    _VERSION = '0.0.1',
}

prettyTable.__index = prettyTable

function prettyTable.round(n, d)
    local e = 10 ^ (d or 0)
    return math.floor(n * e + 0.5) / e
end

function prettyTable.pad(s, w, p)
    local p = string.rep(p or " ", math.abs (w))
    
    if w < 0 then
        return string.sub(p .. s, w)
    end

    return string.sub(s .. p, 1, w)
end

function prettyTable.trim(s, r)
    r = r or "%s+"
    return (s:gsub("^" .. r, ""):gsub(r .. "$", ""))
end

function prettyTable.new()
    local self = setmetatable({}, prettyTable)

    return self
end

function prettyTable:setColumns(columns)
    self.columns = columns
end

function prettyTable:addRow(row)
    if #row ~= #self.columns then
        error('Error. Number of columns in row not equal to number of defined columns')
    end

    for i, v in ipairs(row) do
        if type(v) == 'number' then
            row[i] = prettyTable.round(row[i], self.round_digits)
        end

        row[i] = tostring(row[i])
    end

    table.insert(self.rows, row)
end


function prettyTable:setExtraSpace(e)
    self.extra_space = e
end

function prettyTable:setRoundDigits(d)
    self.round_digits = d
end

function prettyTable:__getMaxWidth()
    if self.columns == nil then
        return nil
    end

    local max = {}

    for i, v in ipairs(self.columns) do
        max[i] = #v
    end

    for i, row in ipairs(self.rows) do
        for j, v in ipairs(row) do
            max[j] = math.max(max[j], #v)
        end 
    end

    return max
end

function prettyTable:__getWidth(max_width)
    local total_width = #self.columns + 1

    for i, v in ipairs(max_width) do
        max_width[i] = max_width[i] + self.extra_space
        total_width = total_width + max_width[i]
    end

    return total_width
end

function prettyTable:__tostring()
    local string = ''
    local width = self:__getMaxWidth()

    local total_width = self:__getWidth(width)

    -- =========== PRINTING TOP ===========

    for i = 1, total_width do
        local symb = '-'

        if i == 1 or i == total_width then
            symb = '+'
        end

        string = string .. symb
    end

    string = string .. '\n'

    for i = 1, #self.columns do
        string = string .. '|'
        string = string .. prettyTable.pad(self.columns[i], self.alignment * width[i])
    end

    string = string .. '|\n'

    for i = 1, total_width do
        local symb = '-'

        if i == 1 or i == total_width then
            symb = '+'
        end

        string = string .. symb
    end

    string = string .. '\n'

    -- =========== MAIN ROUTINE ===========

    for i = 1, #self.rows do
        for j = 1, #self.rows[i] do
            string = string .. '|'
            string = string .. prettyTable.pad(self.rows[i][j], self.alignment * width[j])
        end

        string = string .. '|\n'
    end

    -- =========== PRINTING BOTTON ===========

    for i = 1, total_width do
        local symb = '-'

        if i == 1 or i == total_width then
            symb = '+'
        end

        string = string .. symb
    end

    return string
end

function prettyTable:print()
    print(self)
end

function prettyTable:setAlingment(a)
    if a ~= 0 then
        self.alignment = math.abs(a) / a
    end 
end

return prettyTable
