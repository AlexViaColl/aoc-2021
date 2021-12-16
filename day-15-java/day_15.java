// javac day_15.java && java Program

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

class Program {
    public static void main(String[] args) throws IOException {
        for (String arg: args) {
            System.out.println(arg);

            String input = Files.readString(Path.of(arg));

            List<List<Integer>> values = input
                .lines()
                .map(l -> l
                    .chars()
                    .mapToObj(c -> c - (int)'0')
                    .collect(Collectors.toList())
                )
                .collect(Collectors.toList());

            part1(values);
            part2(values);
        }
    }

    static void part1(List<List<Integer>> values) {
        int size = values.size();
        Program self = new Program();

        List<List<Node>> grid = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            List<Node> row = new ArrayList<>();
            for (int j = 0; j < size; j++) {
                row.add(self.new Node(i, j, values.get(i).get(j)));
            }
            grid.add(row);
        }

        System.out.println("Part 1: " + dijkstra(grid));
    }

    static void part2(List<List<Integer>> values) {
        int height = values.size();
        int width = values.get(0).size();
        for (int n = 1; n < 5; n++) {
            for (int i = 0; i < height; i++) {
                for (int j = 0; j < width; j++) {
                    values.get(i).add((values.get(i).get((n - 1) * width + j) + 1) % 10);
                    if (values.get(i).get(n * width + j) == 0) {
                        values.get(i).set(n * width + j, 1);
                    }
                }
            }
        }

        width = values.get(0).size();
        for (int n = 1; n < 5; n++) {
            for (int i = 0; i < height; i++) {
                for (int j = 0; j < width; j++) {
                    if (values.size() <= n * height + i) {
                        values.add(new ArrayList<>());
                    }
                    values.get(n * height + i).add((values.get((n - 1) * height + i).get(j) + 1) % 10);
                    if (values.get(n * height + i).get(j) == 0) {
                        values.get(n * height + i).set(j, 1);
                    }
                }
            }
        }

        int size = values.size();
        Program self = new Program();

        List<List<Node>> grid = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            List<Node> row = new ArrayList<>();
            for (int j = 0; j < size; j++) {
                row.add(self.new Node(i, j, values.get(i).get(j)));
            }
            grid.add(row);
        }

        System.out.println("Part 2: " + dijkstra(grid));
    }

    static int dijkstra(List<List<Node>> grid) {
        int size = grid.size();
        Node exit = grid.get(size - 1).get(size - 1);
        Node current = grid.get(0).get(0);
        current.risk = 0;

        Set<Node> queue = new HashSet<>();
        queue.add(current);

        while (queue.size() > 0) {
            current = get_min(queue);
            if (current.row == size - 1 && current.col == size - 1) {
                break;
            }

            List<Node> adjacents = adjacents(grid, current).stream().filter(n -> !n.visited).collect(Collectors.toList());
            for (Node adjacent : adjacents) {
                int new_risk = current.risk + adjacent.value;
                if (new_risk < adjacent.risk) {
                    adjacent.risk = new_risk;
                }

                queue.add(adjacent);
            }

            current.visited = true;
            queue.remove(current);
        }
        return exit.risk;
    }

    static Node get_min(Set<Node> queue) {
        Node min = null;
        for (Node node : queue) {
            if (min == null || node.risk < min.risk) {
                min = node;
            }
        }
        return min;
    }

    static List<Node> adjacents(List<List<Node>> grid, Node node) {
        List<Node> adjacents = new ArrayList<>();
        if (node.row > 0) {
            adjacents.add(grid.get(node.row - 1).get(node.col));
        }
        if (node.row < grid.size() - 1) {
            adjacents.add(grid.get(node.row + 1).get(node.col));
        }
        if (node.col > 0) {
            adjacents.add(grid.get(node.row).get(node.col - 1));
        }
        if (node.col < grid.size() - 1) {
            adjacents.add(grid.get(node.row).get(node.col + 1));
        }
        return adjacents;
    }

    public class Node {
        int row;
        int col;
        int value;
        int risk;
        boolean visited;

        public Node(int row, int col, int value) {
            this.row = row;
            this.col = col;
            this.value = value;
            this.risk = Integer.MAX_VALUE;
            this.visited = false;
        }
    }
}