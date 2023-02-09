//
//  Day1.swift
//  AOC2022
//
//  Created by... >.>
//  jonha892 on 1.12.22.
//

class Day1: Day {
    
    static var day: UInt8 { 1 }

    func calories() -> [Int] {
        let input = Self.rawInput!
        let lines = input.components(separatedBy: .newlines)
        var sums = [Int]()
        var partial = [Int]()
        for line in lines {
            if line.isEmpty {
                sums.append(partial.reduce(0, +))
                partial.removeAll()
                continue
            }
            
            let number = Int(line)!
            partial.append(number)
        }
        if partial.count > 0 {
            sums.append(partial.reduce(0, +))
        }
        return sums
    }

    func part1() async throws -> String {
        let caloriesList = calories()

        let result = caloriesList.sorted().last!
    
        return "\(result)"
    }

    func part2() async throws -> String {
        var caloriesList = calories()

        caloriesList.sort(by: { x, y in x > y})
        let result = caloriesList[...2].reduce(0, +)
    
        return "\(result)"
    }

    func run() async throws -> (String, String) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }

}