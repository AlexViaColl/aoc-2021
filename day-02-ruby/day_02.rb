#!/usr/bin/ruby

def part_1(input)
    horizontal = 0
    depth = 0
    input.split(/\n/).each {|line|
        parts = line.split(/\s/)
        if parts[0] == "forward"
            horizontal += parts[1].to_i
        elsif parts[0] == "down"
            depth += parts[1].to_i
        elsif parts[0] == "up"
            depth -= parts[1].to_i
        end
    }
    return horizontal * depth
end

def part_2(input)
    horizontal = 0
    depth = 0
    aim = 0
    input.split(/\n/).each {|line|
        parts = line.split(/\s/)
        if parts[0] == "forward"
            horizontal += parts[1].to_i
            depth += aim * parts[1].to_i;
        elsif parts[0] == "down"
            aim += parts[1].to_i
        elsif parts[0] == "up"
            aim -= parts[1].to_i
        end
    }
    return horizontal * depth
end

input = $stdin.read
puts "Part 1: "  + part_1(input).to_s
puts "Part 2: "  + part_2(input).to_s