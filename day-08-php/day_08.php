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
    $contents = file_get_contents($path);
    $contents = str_replace("|", "", $contents);

    $lines = explode("\n", $contents);
    $chunks = array_filter(explode(" ", implode(" ", $lines)));

    $rows = array();
    for ($i = 0; $i < count($chunks); $i += 14) {
        $chunk = array_slice($chunks, $i, 14);
        $row = array_map(function ($chunk) {
            $chars = str_split($chunk);
            sort($chars);
            return [$chars, count($chars)];
        }, $chunk);
        array_push($rows, $row);
    }

    $total = 0;
    $result = 0;
    foreach ($rows as $row) {
        $one = array_values(array_filter($row, fn($r) => $r[1] == 2))[0][0];
        $seven = array_values(array_filter($row, fn($r) => $r[1] == 3))[0][0];
        $four = array_values(array_filter($row, fn($r) => $r[1] == 4))[0][0];
        $eight = array_values(array_filter($row, fn($r) => $r[1] == 7))[0][0];

        $display_0 = array_values(array_filter($seven, fn($c) => !in_array($c, $one)))[0];
        $display_2_or_5 = array_values(array_filter($seven, fn($c) => $c != $display_0));
        $display_1_or_3 = array_values(array_filter($four, fn($c) => !in_array($c, $one)));
        $display_4_or_6 = array_values(array_filter($eight, fn($c) => !in_array($c, $four) && !in_array($c, $seven)));

        $five_segments = array_values(
            array_map(
                fn($x) => str_split($x),
                array_unique(array_map(fn($x) => implode("", $x[0]), array_filter($row, fn($r) => $r[1] == 5)))
            )
        );
        $six_segments = array_values(
            array_map(
                fn($x) => str_split($x),
                array_unique(array_map(fn($x) => implode("", $x[0]), array_filter($row, fn($r) => $r[1] == 6)))
            )
        );

        $three = array_values(array_filter($five_segments, function($segment) use ($one) {
            $all_match = true;
            foreach ($one as $c) {
                if (!in_array($c, $segment)) {
                    $all_match = false;
                    break;
                }
            }
            return $all_match;
        }))[0];

        $nine = array_values(array_filter($six_segments, function($segment) use ($four) {
            $all_match = true;
            foreach ($four as $c) {
                if (!in_array($c, $segment)) {
                    $all_match = false;
                    break;
                }
            }
            return $all_match;
        }))[0];

        $display_4 = array_values(array_filter($eight, fn($c) => !in_array($c, $nine)))[0];
        $display_6 = array_values(array_filter($display_4_or_6, fn($c) => $c != $display_4))[0];

        $two = array_values(array_filter($five_segments, function($segment) use ($display_0, $display_4, $display_6) {
            $all_match = true;
            foreach (array($display_0, $display_4, $display_6) as $c) {
                if (!in_array($c, $segment)) {
                    $all_match = false;
                    break;
                }
            }
            return $all_match;
        }))[0];

        $five = array_values(array_filter($five_segments, fn($segment) => $segment != $two && $segment != $three))[0];

        $display_2 = array_values(array_filter($eight, fn($c) => !in_array($c, $five) && $c != $display_4))[0];
        $display_5 = array_values(array_filter($display_2_or_5, fn($c) => $c != $display_2))[0];

        $zero = array_values(array_filter($six_segments, function($segment) use ($one, $nine) {
            $all_in_one = true;
            foreach ($one as $c) {
                if (!in_array($c, $segment)) {
                    $all_in_one = false;
                    break;
                }
            }
            return $segment != $nine && $all_in_one;
        }))[0];

        $six = array_values(array_filter($six_segments, fn($segment) => $segment != $zero && $segment != $nine))[0];

        $display_1 = array_values(array_filter($nine, fn($c) => !in_array($c, $three)))[0];
        $display_3 = array_values(array_filter($eight, fn($c) => !in_array($c, $zero)))[0];

        $numbers = array_map(
            function($s) {
                $chars = str_split($s);
                sort($chars);
                return implode($chars);
            },
            array(
                $display_0 . $display_1 . $display_2 . $display_4 . $display_5 . $display_6,
                $display_2 . $display_5,
                $display_0 . $display_2 . $display_3 . $display_4 . $display_6,
                $display_0 . $display_2 . $display_3 . $display_5 . $display_6,
                $display_1 . $display_2 . $display_3 . $display_5,
                $display_0 . $display_1 . $display_3 . $display_5 . $display_6,
                $display_0 . $display_1 . $display_3 . $display_4 . $display_5 . $display_6,
                $display_0 . $display_2 . $display_5,
                $display_0 . $display_1 . $display_2 . $display_3 . $display_4 . $display_5 . $display_6,
                $display_0 . $display_1 . $display_2 . $display_3 . $display_5 . $display_6,
            ),
        );

        $num_str = "";
        foreach(array_slice($row, 10, 4) as $n) {
            $num = implode($n[0]);
            $pos = array_search($num, $numbers);
            $num_str .= $pos;
        }
        $result += intval($num_str);
    }

    echo("Part 2: " . $result . "\n");
}