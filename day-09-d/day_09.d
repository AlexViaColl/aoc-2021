import std.algorithm;
import std.array;
import std.file;
import std.stdio;
import std.string;
import std.typecons;
import std.utf : byChar;

void main(string[] args) {
   for (int i = 1; i < args.length; i++) {
      byte[] data = cast(byte[]) read(args[i]);
      string input = (cast(immutable(char)*)data)[0..data.length];

      part1(input);
      part2(input);
   }
}

void part1(string input) {
   auto heights = splitLines(input).map!(l => l.map!(c => c - '0').array).array;

   int result = 0;
   for (int i = 0; i < heights.length; i++) {
      for (int j = 0; j < heights[0].length; j++) {
         int current = heights[i][j];

         int up = int.max;
         int down = int.max;
         int left = int.max;
         int right = int.max;
         if (i > 0) { up = heights[i - 1][j]; }
         if (i < heights.length - 1) { down = heights[i + 1][j]; }
         if (j > 0) { left = heights[i][j - 1]; }
         if (j < heights[0].length - 1) { right = heights[i][j + 1]; }

         if (current < up && current < down && current < left && current < right) {
            result += 1 + current;
         }
      }
   }

   writefln("Part 1: %d", result);
}

void part2(string input) {
   auto heights = splitLines(input).map!(l => l.map!(c => c - '0').array).array;

   int[] basin_sizes;
   for (int i = 0; i < heights.length; i++) {
      for (int j = 0; j < heights[0].length; j++) {
         uint current = heights[i][j];

         int up = int.max;
         int down = int.max;
         int left = int.max;
         int right = int.max;
         if (i > 0) { up = heights[i - 1][j]; }
         if (i < heights.length - 1) { down = heights[i + 1][j]; }
         if (j > 0) { left = heights[i][j - 1]; }
         if (j < heights[0].length - 1) { right = heights[i][j + 1]; }

         if (current < up && current < down && current < left && current < right) {
            basin_sizes ~= get_basin_size(heights, current, i, j);
         }
      }
   }
   basin_sizes.sort!("a > b");
   writefln("Part 2: %d", basin_sizes[0] * basin_sizes[1] * basin_sizes[2]);
}

alias Adjacent = Tuple!(uint, int, int);
alias Pos = Tuple!(int, int);

int get_basin_size(uint[][] heights, uint current, int i, int j) {
   auto adjacents = get_suitable(get_adjacents(heights, i, j), current);
   Pos[] found;
   foreach (adj; adjacents) {
      if (!canFind(found, tuple(adj[1], adj[2]))) {
         found ~= tuple(adj[1], adj[2]);
      }
   }
   while (adjacents.length != 0) {
      auto first = adjacents[0];
      adjacents.popFront();
      auto inner = get_suitable(get_adjacents(heights, first[1], first[2]), first[0]);
      foreach (adj; inner) {
         if (!canFind(found, tuple(adj[1], adj[2]))) {
            found ~= tuple(adj[1], adj[2]);
         }
      }
      adjacents ~= inner;
   }

   return 1 + cast(int)found.length;
}

Adjacent[] get_adjacents(uint[][] heights, int i, int j) {
   Adjacent[] adjacents;
   if (i > 0) { adjacents ~= tuple(heights[i - 1][j], i - 1, j); }
   if (i < heights.length - 1) { adjacents ~= tuple(heights[i + 1][j], i + 1, j); }
   if (j > 0) { adjacents ~= tuple(heights[i][j - 1], i, j - 1); }
   if (j < heights[0].length - 1) { adjacents ~= tuple(heights[i][j + 1], i, j + 1); }
   return adjacents;
}

Adjacent[] get_suitable(Adjacent[] adjacents, uint current) {
   Adjacent[] suitable;
   for (int i = 0; i < adjacents.length; i++) {
      if (adjacents[i][0] > current && adjacents[i][0] < 9) {
         suitable ~= adjacents[i];
      }
   }
   return suitable;
}