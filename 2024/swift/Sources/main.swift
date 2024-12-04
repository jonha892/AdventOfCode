// The Swift Programming Language
// https://docs.swift.org/swift-book



do {
    let day = try Day4(
        filename: "inputs/day4_test.txt"
        //filename: "inputs/day3.txt"
    )
    print(day.part1())
    print(day.part2())
} catch {
    print("Error initializing Day: \(error)")
}