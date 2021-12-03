package com.aoc.d5;

import com.aoc.d5.util.SeatPosition;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Main {

    private static SeatPosition parseTicket(String ticket) {
        if (ticket.length() != 10) {
            throw new IllegalArgumentException("invalid Ticket? " + ticket);
        }
        int min_row = 0;
        int max_row = 127;
        for (int i=0; i < 7; i++) {
            char c = ticket.charAt(i);
            if (c == 'F') {
                max_row = (int) min_row + (max_row-min_row)/2;
                //System.out.println("New max_row: " + max_row);
            } else if (c == 'B') {
                min_row = min_row + (int) Math.ceil((max_row- (double) min_row) / 2);
                //System.out.println("New min_row: " + min_row);
            } else {
                throw new IllegalArgumentException("Unknown row qulifier: " + c);
            }
        }
        //System.out.println("Row: " + min_row + " " + max_row);

        int min_column = 0;
        int max_column = 7;

        for (int i = 7; i < 10; i++) {
            char c = ticket.charAt(i);
            if (c == 'R') {
                min_column = min_column + (int) Math.ceil((max_column- (double) min_column) / 2);
                //System.out.println("New max_column: " + min_column);
            } else if (c == 'L') {
                max_column = min_column + (int) Math.ceil((max_column-min_column) / 2);
                //System.out.println("New min_column: " + max_column);
            } else {
                throw new IllegalArgumentException("Unknown row qulifier: " + c);
            }
        }
        if ((min_row != max_row) || (min_column != max_column)) {
            throw new IllegalArgumentException("Illigal state: "
                    + String.format("[%d %d] - [%d %d]", min_row, max_row, min_column, max_column));
        }
        //System.out.println("Column: " + min_column + " " + max_column);
        SeatPosition res = new SeatPosition(min_row, min_column);
        return res;
    }

    public static int p1(List<String> list) {
        int max = -1;
        for (String s: list) {
            int tmp_score = parseTicket(s).id();
            if (tmp_score > max) {
                max = tmp_score;
            }
        }
        return max;
    }

    public static List<Integer> p2 (List<String> list) {
        List<Integer> res = new ArrayList<>();
        for (String s: list) {
            int tmp_score = parseTicket(s).id();
            res.add(tmp_score);
        }
        res.sort(Comparator.comparing(Integer::valueOf));
        return res;
    }

    public static void main(String[] args) {
        System.out.println("Day 5");
        SeatPosition pos;
        pos = parseTicket("BFFFBBFRRR");
        System.out.println(pos + " " + pos.id());
        pos = parseTicket("FFFBBBFRRR");
        System.out.println(pos + " " + pos.id());
        pos = parseTicket("BBFFBBFRLL");
        System.out.println(pos + " " + pos.id());

        Path path = Paths.get("D:\\\\Dev\\AOC_2020\\5.txt");
        List<String> lines = new ArrayList<>();
        try {
            lines = Files.readAllLines(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
        //Consumer<String> formatter = (String x) ->
        lines.forEach((String pass) -> pass.strip());
        int p1 = p1(lines);
        System.out.println(p1);
        List<Integer> p2 = p2(lines);
        for (int i = 88; i < 889; i++) {
            if (!p2.contains(i)) {
                System.out.println("Candidate: " + i);
            }
        }
    }
}
