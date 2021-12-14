function read_lines(file)
    lines = {}
    for line in io.lines(file) do
        if line ~= nil and line ~= "" then
            lines[#lines + 1] = line
        end
    end
    return lines
end

function merge_maps(left, right, middle)
    local map = {}
    for k,v in pairs(left) do
        map[k] = v
    end
    for k,v in pairs(right) do
        if map[k] ~= nil then
            map[k] = map[k] + v
        else
            map[k] = v
        end
    end

    if map[middle] ~= nil then
        map[middle] = map[middle] - 1
    end

    return map
end

function get_letters(cache, pairs_, pair, depth)
    local key = pair[1] .. pair[2] .. depth
    if cache[key] ~= nil then
        return cache[key]
    else
        if depth == 0 then
            local map = {}
            map[pair[1]] = 1
            if map[pair[2]] ~= nil then
                map[pair[2]] = map[pair[2]] + 1
            else
                map[pair[2]] = 1
            end

            cache[key] = map
            return map
        else
            local adj = pair[1] .. pair[2]
            local middle = nil
            for _,p in pairs(pairs_) do
                if p[1] == adj then
                    middle = p[2]
                    break
                end
            end

            local left_map = get_letters(cache, pairs_, {pair[1], middle}, depth - 1)
            local right_map = get_letters(cache, pairs_, {middle, pair[2]}, depth - 1)

            local map = merge_maps(left_map, right_map, middle)
            cache[key] = map
            return map
        end
    end
end

function solve(template, pairs_, iterations)
    local p = string.sub(template, 1, 2)
    local a = string.sub(p, 1, 1)
    local b = string.sub(p, 2, 2)

    cache = {}
    local final_map = get_letters(cache, pairs_, {a, b}, iterations)

    for i=2,#template - 1 do
        p = string.sub(template, i, i + 1)
        a = string.sub(p, 1, 1)
        b = string.sub(p, 2, 2)

        local map1 = get_letters(cache, pairs_, {a, b}, iterations)
        final_map = merge_maps(final_map, map1, a)
    end

    local min = math.huge
    local max = 0

    for _,v in pairs(final_map) do
        if v < min then
            min = v
        end
        if v > max then
            max = v
        end
    end

    return max - min
end

for _,file in ipairs(arg) do
    local lines = read_lines(file)
    local template = table.remove(lines, 1)

    local pairs_ = {}
    for k,line in pairs(lines) do
        local matches = string.gmatch(line, "%S+")
        local a = matches()
        matches()
        local b = matches()
        local pair = {a, b}

        table.insert(pairs_, pair)
    end

    print("Part 1: " .. solve(template, pairs_, 10))
    print("Part 2: " .. solve(template, pairs_, 40))
end