import os
import std/algorithm
import std/strutils

proc is_open(c: char): bool =
    c == '[' or c == '(' or c == '{' or c == '<'

proc get_score(c: char): int =
    case c:
        of ')':
            3
        of ']':
            57
        of '}':
            1197
        of '>':
            25137
        else:
            0

proc part1(input: string) =
    let lines = splitLines(input)
    var total = 0

    for line in lines:
        var stack: seq[char]
        var corrupted = false
        for c in line:
            if is_open(c):
                stack.add(c)
            else:
                let last = stack[stack.len() - 1]
                if (last == '(' and c == ')') or (last == '[' and c == ']') or (last == '{' and c == '}') or (last == '<' and c == '>'):
                    discard stack.pop()
                else:
                    corrupted = true
                    total += get_score(c)
                    discard stack.pop()

            if corrupted:
                break

    echo "Part 1: ", total

proc part2(input: string) =
    let lines = splitLines(input)
    var total = 0
    var scores: seq[uint64]

    for line in lines:
        var stack: seq[char]
        var corrupted = false
        for c in line:
            if is_open(c):
                stack.add(c)
            else:
                let last = stack[stack.len() - 1]
                if (last == '(' and c == ')') or (last == '[' and c == ']') or (last == '{' and c == '}') or (last == '<' and c == '>'):
                    discard stack.pop()
                else:
                    corrupted = true
                    total += get_score(c)
                    discard stack.pop()

            if corrupted:
                break

        if not corrupted:
            var score: uint64 = 0
            stack.reverse()
            for c in stack:
                let points: uint64 = case c:
                    of '(':
                        1
                    of '[':
                        2
                    of '{':
                        3
                    of '<':
                        4
                    else:
                        0
                score = score * 5 + points

            scores.add(score)

    scores.sort()
    let half = int(scores.len() / 2)
    echo "Part 2: ", scores[half]

for i in 1..paramCount():
    let filename = paramStr(i)
    let input = readFile(filename)
    part1(input)
    part2(input)