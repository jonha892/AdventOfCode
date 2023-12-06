// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

let input_path = "data/day_6.txt"
var input = parseInput(url: input_path)

let day = Day6(input: input)

print("part 1: \(day.partOne())")
print("part 2: \(day.partTwo())")
