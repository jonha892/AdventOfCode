package com.aoc.d3;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class Main {

    private static long try_slope(int d_x, int d_y, List<String> content) {
        int max_y = content.size() -1;
        int max_x = content.get(0).length();
        int p_x = 0;
        int p_y = 0;
        long trees = 0;
        while (p_y <= max_y) {
            if (p_x >= max_x) {
                int p_x_new = p_x - max_x;
                //System.out.println("Wrap around! Pos(%d %d) max_x: %d new_x: %d".formatted(p_x, p_y, max_x, p_x_new));
                p_x = p_x_new;
            }
            char c = content.get(p_y).charAt(p_x);
            if (c == '#') {
                trees += 1;
            }
            p_x += d_x;
            p_y += d_y;
        }
        System.out.println(String.format("Found %d trees for slope (%d, %d)", trees, d_x, d_y));
        return trees;
    }

    public static void main(String[] args) {
        System.out.println("AOC - D3");
        List<String> content = new ArrayList<>();
        try {
            Path path = Paths.get("D:\\\\Dev\\AOC_2020\\3.txt");
            //Path path = Paths.get("D:\\\\Dev\\AOC_2020\\3_test.txt");
            content = Files.readAllLines(path);
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println(content.size());
        long s_1_1 = Main.try_slope(1, 1, content);
        long s_3_1 = Main.try_slope(3, 1, content);
        long s_5_1 = Main.try_slope(5, 1, content);
        long s_7_1 = Main.try_slope(7, 1, content);
        long s_1_2 = Main.try_slope(1, 2, content);

        long p2 = s_1_1 * s_3_1 * s_5_1 * s_7_1 * s_1_2;
        System.out.println("P2: " + p2);
    }
}
