//
//  AOC2022.swift
//  
//
//  Created by Dave DeLong on 1.12.22.
//

import Foundation

@_exported import AOCCore

public struct AOC2022 {
    
    public static let days: Array<any Day> = [
        Day1(),
        Day2(),
        Day3(),
        Day4(),
        Day5(),
        Day6(),
        Day7(),
        Day8(),
        Day9(),
        Day10(),
        Day11(),
        Day12(),
        Day13(),
        Day14(),
        Day15(),
        Day16(),
        Day17(),
        Day18(),
        Day19(),
        Day20(),
        Day21(),
        Day22(),
        Day23(),
        Day24(),
        Day25(),
    ]
    
    public static func day(_ number: Int) -> any Day {
        let idx = number - 1
        guard AOC2022.days.indices.contains(idx) else { return InvalidDay() }
        return AOC2022.days[idx]
    }
}

public struct InvalidDay: Day {
    public static var day: UInt8 = 0
}
