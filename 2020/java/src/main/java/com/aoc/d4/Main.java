package com.aoc.d4;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.function.Predicate;
import java.util.regex.Pattern;
import java.util.stream.Stream;

public class Main {

    private static boolean validByr(String value) {
        int byr = Integer.parseInt(value);
        return (byr >= 1920) && (byr <= 2002);
    }

    private static boolean validIyr(String value) {
        //System.out.println(value);
        int iyr = Integer.parseInt(value);
        return (iyr >= 2010) && (iyr <= 2020);
    }

    private static boolean validEyr(String value) {
        int eyr = Integer.parseInt(value);
        return (eyr >= 2020) && (eyr <= 2030);
    }

    private static boolean validHgt(String value) {
        //System.out.println("Height: " + value);
        if (!(value.length() > 2)) {
            return false;
        }
        String height_unit = value.substring(value.length() - 2);
        int height = Integer.parseInt(value.substring(0, value.length() - 2));
        if (height_unit.equals("cm")) {
            return  (height >= 150) && (height <= 193);
        } else if (height_unit.equals("in")) {
            return  (height >= 59) && (height <= 76);
        } else {
            return false;
            //throw new IllegalArgumentException("unknown height unit: " + value);
        }
    }

    private static boolean validHcl(String value) {
        if (! (value.charAt(0) == '#')) {
            return false;
        }
        if (value.length() != 7) {
            return false;
        }
        Predicate<String> filter = Pattern.compile("[0-9a-f]+").asPredicate();
        return Stream.of(value.substring(1)).allMatch(filter);
    }

    private static boolean validEcl(String value) {
        List<String> validEcls = Arrays.asList("amb", "blu", "brn", "gry", "grn", "hzl", "oth");
        return validEcls.contains(value);
    }

    private static boolean validPid(String value) {
        Predicate<String> filter = Pattern.compile("[0]*[0-9]+").asPredicate();
        return (value.length() == 9) && Stream.of(value).allMatch(filter);
    }

    private static boolean checkPassport(Map<String, String> passport, boolean with_validation) {
        boolean has_byr = passport.containsKey("byr");
        boolean has_iyr = passport.containsKey("iyr");
        boolean has_eyr = passport.containsKey("eyr");
        boolean has_hgt = passport.containsKey("hgt");
        boolean has_hcl = passport.containsKey("hcl");
        boolean has_ecl = passport.containsKey("ecl");
        boolean has_pid = passport.containsKey("pid");

        boolean valid = (has_byr && has_iyr && has_eyr && has_hgt && has_hcl && has_ecl && has_pid );
        if (!with_validation) {
            return valid;
        } else if (!valid) {
            return false;
        }

        /*
        System.out.print(valid);
        passport.keySet().stream().forEach(key -> {
            System.out.print(" " + key + ":" + passport.get(key));
        });
        System.out.println();
         */

        boolean valid_byr = Main.validByr(passport.get("byr"));
        boolean valid_iyr = Main.validIyr(passport.get("iyr"));
        boolean valid_eyr = Main.validEyr(passport.get("eyr"));
        boolean valid_hgt = Main.validHgt(passport.get("hgt"));
        boolean valid_hcl = Main.validHcl(passport.get("hcl"));
        boolean valid_ecl = Main.validEcl(passport.get("ecl"));
        boolean valid_pid = Main.validPid(passport.get("pid"));

        /*
        System.out.println("Valid fields:");
        System.out.println(valid_byr);
        System.out.println(valid_iyr);
        System.out.println(valid_eyr);
        System.out.println(valid_hgt);
        System.out.println(valid_hcl);
        System.out.println(valid_ecl);
        System.out.println(valid_pid);
        */

        return (valid_byr && valid_iyr && valid_eyr && valid_hgt && valid_hcl && valid_ecl && valid_pid);
    }


    private static void handlePassportLine(String line, Map<String, String> map) {
        //System.out.println("Line: " + line);
        Stream<String> stream = Arrays.stream(line.split(" "));
        stream.forEach(str -> {
            String[] parts = str.split(":");

            //System.out.println("Parts: " + Arrays.toString(parts));

            String key = parts[0];
            String value = parts[1];
            map.put(key, value);
        });
    }

    private static int checkPassportFile(Path path) {
        try {
            List<String> lines = Files.readAllLines(path);

            Map<String, String> currentPassport = new HashMap<>();
            int valid_passports = 0;
            for (int i=0; i<lines.size(); i++) {
                String line = lines.get(i);

                if (line.length() > 0) {
                    Main.handlePassportLine(line, currentPassport);
                }

                if ((line.length() == 0) || (i == lines.size() -1)) {
                    //System.out.println("Check passport after line: " + i);
                    boolean t = Main.checkPassport(currentPassport, true);
                    if (t) {
                        valid_passports += 1;
                    }
                    currentPassport = new HashMap<>();
                }
            }
            System.out.println("Valid Passports: " + valid_passports);

            return valid_passports;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static void main(String[] args) {
        Path path;
        path = Paths.get("D:\\\\Dev\\AOC_2020\\4.txt");
        checkPassportFile(path);
        //path = Paths.get("D:\\\\Dev\\AOC_2020\\4_test.txt");


        path = Paths.get("D:\\\\Dev\\AOC_2020\\4_1.txt");
        //checkPassportFile(path);

        path = Paths.get("D:\\\\Dev\\AOC_2020\\4_2.txt");
        checkPassportFile(path);

    }
}
