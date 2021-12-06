#!/usr/bin/perl

use warnings;
use strict;

sub count_fish {
    my ($input, $days) = @_;

    my @state = split ",", $input;
    my @internal_timers = (0, 0, 0, 0, 0, 0, 0, 0, 0);
    foreach (@state) {
        $internal_timers[$_] += 1;
    }

    for (my $i = 0; $i < $days; $i++) {
        my $zero_count = $internal_timers[0];
        for (my $index = 1; $index <= 8; $index++) {
            $internal_timers[$index -1] = $internal_timers[$index];
        }
        $internal_timers[6] += $zero_count;
        $internal_timers[8] = $zero_count;
	}

    my $sum = 0;
    foreach (@internal_timers) {
        $sum += $_;
    }
    return $sum;
}

my $input = join("", <STDIN>);
print "Part 1: ", count_fish($input, 80), "\n";
print "Part 2: ", count_fish($input, 256), "\n";