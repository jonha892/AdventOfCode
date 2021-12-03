package com.aoc.d6;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Main {

    public static int p1(List<String> lines) {
        Set<Character> current_answers = new HashSet<>();
        List<Set<Character>> result_list = new ArrayList<>();
        for(int i=0; i < lines.size(); i++) {
            String line = lines.get(i).strip();
            if (line.length() > 0) {

                Set<Character> lineSet = line.chars().distinct().mapToObj(c -> (char) c).collect(Collectors.toSet());
                current_answers.addAll(lineSet);
            }
            if ((line.length() == 0) || (i == lines.size() -1)) {
                //current_answers.stream().forEach(System.out::print);
                //System.out.println();
                result_list.add(current_answers);
                current_answers = new HashSet<>();
            }
        }
        int res = result_list.stream().map(s -> s.size()).reduce(0, Integer::sum);
        return res;
    }

    public static int p2(List<String> lines) {
        Set<Character> current_answers = new HashSet<>();
        List<Set<Character>> result_list = new ArrayList<>();
        boolean group_initialized = false;
        for(int i=0; i < lines.size(); i++) {
            String line = lines.get(i).strip();
            if (line.length() > 0) {
                Set<Character> lineSet = line.chars().distinct().mapToObj(c -> (char) c).collect(Collectors.toSet());
                if (!group_initialized) {
                    current_answers.addAll(lineSet);
                    group_initialized = true;
                } else {
                    current_answers.retainAll(lineSet);
                }
            }
            if ((line.length() == 0) || (i == lines.size() -1)) {
                //current_answers.stream().forEach(System.out::print);
                //System.out.println();
                result_list.add(current_answers);
                current_answers = new HashSet<>();
                group_initialized = false;
            }
        }
        int res = result_list.stream().map(s -> s.size()).reduce(0, Integer::sum);
        return res;
    }

    public static void main(String[] args) {
        Path path;
        path = Paths.get("D:\\\\Dev\\AOC_2020\\6.txt");
        //path = Paths.get("D:\\\\Dev\\AOC_2020\\6_test.txt");

        List<String> lines = new ArrayList<>();
        try {
            lines = Files.readAllLines(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
        int p1 = Main.p1(lines);
        System.out.println(p1);
        int p2= Main.p2(lines);
        System.out.println(p2);
    }
}
