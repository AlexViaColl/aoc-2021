import java.io.File

fun main(args: Array<String>) {
    for (arg in args) {
        val lines = File(arg).readLines().filter { !it.isEmpty() }
        val cords = lines
            .filter { !it.startsWith("fold along") }
            .map { it ->
                val parts = it.split(",")
                Pair(parts[0].toInt(), parts[1].toInt())
            }

        val folds = lines
            .filter { it.startsWith("fold along") }
            .map { it ->
                val text = it.split("fold along ")[1]
                val parts = text.split("=")
                Pair(parts[0], parts[1].toInt())
            }
        
        val map = cords.map { it -> it to true}.toMap()
        var mmap = map.toMutableMap()

        val min_x = 0
        val min_y = 0
        val max_x = cords.map { it.first }.maxOrNull() ?: 0
        val max_y = cords.map { it.second }.maxOrNull() ?: 0

        var width = max_x - min_x + 1
        var height = max_y - min_y + 1

        val count = fold_along(folds[0], mmap, width, height).first
        println("Part 1: $count")

        mmap = map.toMutableMap()
        for (fold in folds) {
            val res = fold_along(fold, mmap, width, height);
            width = res.second
            height = res.third
        }
        val rendered = render_map(mmap)
        val code = extract_code(rendered)

        println("Part 2: $code\n")
        println(rendered.joinToString(separator = "\n"));
    }
}

fun fold_along(
    fold: Pair<String, Int>,
    map: MutableMap<Pair<Int, Int>, Boolean>,
    width: Int,
    height: Int,
): Triple<Int, Int, Int> {
    val to_add = mutableListOf<Pair<Int, Int>>()
    for ((key, _) in map) {
        if (fold.first == "x") {
            if (key.first > fold.second) {
                map[key] = false;
                to_add.add(Pair((width - 1) - key.first, key.second))
            }
        } else {
            if (key.second > fold.second) {
                map[key] = false;
                to_add.add(Pair(key.first, (height - 1) - key.second))
            }
        }
    }

    for (cord in to_add) {
        map[cord] = true;
    }

    val to_remove = map.filter { !it.value }.map { it.key }
    map.minusAssign(to_remove)

    val new_width = if (fold.first == "x") width / 2 else width
    val new_height = if (fold.first == "y") height / 2 else height

    return Triple(map.size, new_width, new_height)
}

fun render_map(m: MutableMap<Pair<Int, Int>, Boolean>): List<String> {
    val min_x = m.map { it.key.first }.minOrNull() ?: 0
    val min_y = m.map { it.key.second }.minOrNull() ?: 0
    val max_x = m.map { it.key.first }.maxOrNull() ?: 0
    val max_y = m.map { it.key.second }.maxOrNull() ?: 0

    val board = mutableListOf<String>();
    for (y in min_y..max_y) {
        var row = "";
        for (x in min_x..max_x) {
            if (m.keys.find{ it == Pair(x, y)} != null) {
                row = row + "#";
            } else {
                row = row + ".";
            }
        }
        board.add(row);
    }
    return board
}

fun extract_code(m: List<String>): String {
    val map_to_letter = mapOf(
        listOf("###.", "#..#", "###.", "#..#", "#..#", "###.") to "B",
        listOf("####", "#...", "###.", "#...", "#...", "####") to "E",
        listOf("####", "#...", "###.", "#...", "#...", "#...") to "F",
        listOf("..##", "...#", "...#", "...#", "#..#", ".##.") to "J",
        listOf("#..#", "#.#.", "##..", "#.#.", "#.#.", "#..#") to "K",
        listOf("#...", "#...", "#...", "#...", "#...", "####") to "L",
        listOf("####", "...#", "..#.", ".#..", "#...", "####") to "Z",
    )

    var code = "";
    for (i in 0..7) {
        val start = i * 5
        val symbols = m.map {row -> row.slice(start..start+3) }
        val letter = map_to_letter[symbols]
        if (letter == null) {
            System.err.println("Could not decode:\n${symbols.joinToString(separator = "\n")}\n")
        } else {
            code = code + letter
        }
    }

    return code
}