import scala.io._

object Main {
    def check_boards(boards: List[List[List[(Int, Boolean)]]]): Int = {
        boards.map(board => check_board(board)).indexWhere(r => r == true)
    }

    def check_board(board: List[List[(Int, Boolean)]]): Boolean = {
        for (
            i <- 0 until 5
            if board.map(l => l(i)._2).filter(checked => checked == true).length == 5 ||
               board(i).map(e => e._2).filter(checked => checked == true).length == 5
        ) {
            return true
        }
        false
    }

    def update_boards(boards: List[List[List[(Int, Boolean)]]], number: Int) = {
        boards.map(board => board.map(l => l.map(num => num match {
            case (n, checked) => if (n == number) (n, true) else (n, checked)
        })))
    }

    def part1_check(boards: List[List[List[(Int, Boolean)]]], numbers: List[Int]): Int = {
        numbers match {
            case Nil => -1
            case head :: tail =>
                val updated_boards = update_boards(boards, head)
                check_boards(updated_boards) match {
                    case -1 => part1_check(updated_boards, tail)
                    case board_index =>
                        updated_boards(board_index).map(l => l.filter(e => e._2 == false).map(e => e._1)).flatten.sum * head
                }
        }
    }

    def part2_check(boards: List[List[List[(Int, Boolean)]]], numbers: List[Int], prev: Int): Int = {
        (boards.length, numbers) match {
            case (1, head :: tail) =>
                check_boards(boards) match {
                    case -1 =>
                        part2_check(update_boards(boards, head), tail, head)
                    case board_index =>
                        boards(0).map(l => l.filter(e => e._2 == false).map(e => e._1)).flatten.sum * prev
                }
            case (board_count, head :: tail) =>
                val updated_boards = update_boards(boards, head)
                check_boards(updated_boards) match {
                    case -1 => part2_check(updated_boards, tail, head)
                    case board_index => 
                        part2_check(updated_boards.take(board_index) ++ updated_boards.drop(board_index + 1), head :: tail, prev)
                }
            case (_) => -1
        }
    }

    def part1(path: String) = {
        def lines = Source
            .fromFile(path)
            .getLines()
            .toList

        def numbers = lines.head.split(",").map(n => n.toInt).toList
        def remaining_lines = lines.slice(1, lines.length)
        def boards = remaining_lines
            .sliding(6, 6)
            .map(lines => lines.tail.map(line =>
                line.split(" ").map(n => n.trim).filter(n => n.length > 0).map(n => (Integer.parseInt(n), false)).toList
            ))
            .toList
        
        println("Part 1: " + part1_check(boards, numbers))
    }

    def part2(path: String) = {
        def lines = Source
            .fromFile(path)
            .getLines()
            .toList

        def numbers = lines.head.split(",").map(n => n.toInt).toList
        def remaining_lines = lines.slice(1, lines.length)
        def boards = remaining_lines
            .sliding(6, 6)
            .map(lines => lines.tail.map(line =>
                line.split(" ").map(n => n.trim).filter(n => n.length > 0).map(n => (Integer.parseInt(n), false)).toList
            ))
            .toList
        
        println("Part 2: " + part2_check(boards, numbers, -1))
    }

    def main(args: Array[String]) = {
        for(path <- args) {
            part1(path)
            part2(path)
        }
    }
}