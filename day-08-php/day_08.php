<?php

array_shift($argv);
foreach ($argv as $path) {
    part1($path);
    part2($path);
}

function part1($path) {
    $contents = file_get_contents($path);
    $contents = str_replace("|", "", $contents);

    $lines = explode("\n", $contents);
    $chunks = array_filter(explode(" ", implode(" ", $lines)));

    $result = 0;
    for ($i = 0; $i < count($chunks); $i += 14) {
        $chunk = array_slice($chunks, $i + 10, 4);
        $digit_len_arr = array_map(function ($digit) { return [$digit, strlen($digit)]; }, $chunk);
        $count = count(array_filter(
            $digit_len_arr,
            function ($digit_len) {
                return $digit_len[1] == 2 || $digit_len[1] == 4 || $digit_len[1] == 3 || $digit_len[1] == 7;
            })
        );
        $result += $count;
    }
    
    echo("Part 1: " . $result . "\n");
}

function part2($path) {
    $result = -1;
    echo("Part 2: " . $result . "\n");
}