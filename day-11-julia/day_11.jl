function has_flashes(levels :: Array{Array{Int64, 1}, 1}) :: Bool
    has_flashes = false
    for i in 1:length(levels)
        for j in 1:length(levels[1])
            if levels[i][j] == 10
                has_flashes = true
                break
            end
        end
    end
    return has_flashes
end

function get_adjacents(levels :: Array{Array{Int64, 1}, 1}, i :: Int64, j :: Int64) :: Array{Tuple{Int, Int}}
    up_left = Union{Nothing, Tuple{Int, Int}}
    up_right = Union{Nothing, Tuple{Int, Int}}

    down = Union{Nothing, Tuple{Int, Int}}
    down_left = Union{Nothing, Tuple{Int, Int}}
    down_right = Union{Nothing, Tuple{Int, Int}}

    left = Union{Nothing, Tuple{Int, Int}}
    right = Union{Nothing, Tuple{Int, Int}}

    if i <= 1
        up = Nothing 
    else
        up = (i - 1, j)
    end

    if i <= 1 || j <= 1
        up_left = Nothing 
    else
        up_left = (i - 1, j - 1)
    end

    if i <= 1 || j >= 10
        up_right = Nothing 
    else
        up_right = (i - 1, j + 1)
    end


    if i >= 10
        down = Nothing 
    else
        down = (i + 1, j)
    end

    if i >= 10 || j <= 1
        down_left = Nothing 
    else
        down_left = (i + 1, j - 1)
    end

    if i >= 10 || j >= 10
        down_right = Nothing 
    else
        down_right = (i + 1, j + 1)
    end


    if j <= 1
        left = Nothing
    else
        left = (i, j - 1)
    end

    if j >= 10
        right = Nothing
    else
        right = (i, j + 1)
    end

    result = [up, up_left, up_right, down, down_left, down_right, left, right]
    return filter(x -> x != Nothing, result)
end

function step(levels :: Array{Array{Int64, 1}, 1}) :: Int64
    for i in 1:length(levels)
        for j in 1:length(levels[1])
            levels[i][j] += 1
        end
    end

    while has_flashes(levels)
        for i in 1:length(levels)
            for j in 1:length(levels[1])
                if levels[i][j] == 10
                    levels[i][j] += 1
                    for adj in get_adjacents(levels, i, j)
                        if levels[adj[1]][adj[2]] < 10
                            levels[adj[1]][adj[2]] += 1
                        end
                    end
                end
            end
        end
    end

    flashes = 0
    for i in 1:length(levels)
        for j in 1:length(levels[1])
            if levels[i][j] > 9
                levels[i][j] = 0
                flashes += 1
            end
        end
    end
    
    return flashes
end

function parse_file(path :: String) :: Array{Array{Int, 1}, 1}
    levels = Array{Array{Int64, 1}, 1}()
    open(path) do file
        for line in eachline(file)
            line_numbers = Int[]
            if length(line) > 0
                for i = firstindex(line):lastindex(line)
                    push!(line_numbers, Int(line[i]) - Int('0'))
                end
                push!(levels, line_numbers)
            else
            end
        end
    end
    return levels
end

function part1(path :: String)
    levels = parse_file(path)

    total_flashes = 0
    for i in 1:100
        flashes = step(levels)
        total_flashes += flashes
    end

    println("Part 1: ", total_flashes)
end

function part2(path :: String)
    levels = parse_file(path)

    flashes = 0
    i = 0
    while flashes != 100
        flashes = step(levels)
        i += 1
    end

    println("Part 2: ", i)
end

for arg in ARGS
    part1(arg)
    part2(arg)
end