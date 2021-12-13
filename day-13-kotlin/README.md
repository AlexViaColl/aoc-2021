# [Day 13](https://adventofcode.com/2021/day/13) - [Kotlin](https://kotlinlang.org/)

## Quickstart
* Install the [Kotlin compiler](https://kotlinlang.org/docs/command-line.html) and make sure kotlinc is available in $PATH
* Compile into a jar: `$ kotlinc day_13.kt -include-runtime -d day_13.jar`
* Run: `$ java -jar day_13.jar input.txt`

## Results
```console
$ kotlinc day_13.kt -include-runtime -d day_13.jar && java -jar day_13.jar input.txt
Part 1: 664
Part 2: EFJKZLBL

####.####...##.#..#.####.#....###..#...
#....#.......#.#.#.....#.#....#..#.#...
###..###.....#.##.....#..#....###..#...
#....#.......#.#.#...#...#....#..#.#...
#....#....#..#.#.#..#....#....#..#.#...
####.#.....##..#..#.####.####.###..####
```

## Tested on
```console
$ kotlinc -version
info: kotlinc-jvm 1.6.0 (JRE 17.0.1+12)

$ java -version
openjdk version "17.0.1" 2021-10-19
OpenJDK Runtime Environment (build 17.0.1+12)
OpenJDK 64-Bit Server VM (build 17.0.1+12, mixed mode)
```