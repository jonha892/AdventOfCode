// The Swift Programming Language
// https://docs.swift.org/swift-book



do {
    let day = try Day6(
        //filename: "inputs/day6_test.txt"
        filename: "inputs/day6.txt"
    )
    print(day.part1())
    print(day.part2())
} catch {
    print("Error initializing Day: \(error)")
}