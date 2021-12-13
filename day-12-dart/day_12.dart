import "dart:io";

void main(List<String> args) {
    for (var arg in args) {
        var contents = File(arg).readAsStringSync();
        part1(contents);
        part2(contents);
    }
}

void part1(String input) {
    var segments = input.split("\n").map((line) => line.split("-")).toList();
    var paths = build_paths(segments, ["start"], "");
    print("Part 1: ${paths.length}");
}

void part2(String input) {
    var segments = input.split("\n").map((line) => line.split("-")).toList();

    var small = segments
        .expand((i) => i)
        .where((s) => s != "start" && s != "end" && s.codeUnits[0] >= 97 && s.codeUnits[0] <= 122)
        .toSet()
        .toList();

    var paths = new Set();
    for (var s in small) {
        paths.addAll(build_paths(segments, ["start"], s).map((p) => p.join(",")));
    }

    print("Part 2: ${paths.length}");
}

List<List<String>> build_paths(List<List<String>> segments, List<String> path, String repeatable) {
    var last = path[path.length - 1];
    List<List<String>> result = [];
    var valid_segments = segments
        .where((s) => s[0] == last || s[1] == last)
        .map((s) => s.firstWhere((s) => s != last))
        .where((s) => s != "start")
        .toList();

    for(var valid in valid_segments) {
        if (valid == "end") {
            result.add([...path, valid]);
        } else if (is_visitable(path, valid, repeatable)) {
            result.addAll(build_paths(segments, [...path, valid], repeatable));
        }
    }

    return result;
}

bool is_visitable(List<String> path, String location, String repeatable) {
    if (location == "start") return false;
    if (location.codeUnits[0] >= 65 && location.codeUnits[0] <= 90) return true;
    else {
        if (repeatable == "") {
            return !path.contains(location);
        } else {
            var repetitions = path.where((p) => p == repeatable).length;
            if (location == repeatable) {
                return repetitions < 2;
            } else {
                return !path.contains(location);
            }
        }
    }
}