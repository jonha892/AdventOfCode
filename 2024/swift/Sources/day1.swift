import Foundation

class Day1: Day {

    var firstList = [Int]()
    var secondList = [Int]()
    
    init(filename: String) {
        // read file as lines, split the line by whitespace anc onvert it to tuples, split the tuples then into two lists
        var firstList = [Int]()
        var secondList = [Int]()

        do {
          try String(contentsOfFile: filename, encoding: .utf8).enumerateLines { line, _ in
              let components = line.split(separator: " ", omittingEmptySubsequences: true)
              let first = Int(components[0])!
              let second = Int(components[1])!
              firstList.append(first)
              secondList.append(second)
          }
        } catch {
          print("Error reading file \(error)")
        }

        self.firstList = firstList
        self.secondList = secondList
    }

    func part1() -> String {
        // sort lists
        let sortedFirstList = firstList.sorted()
        let sortedSecondList = secondList.sorted()

        let sum = zip(sortedFirstList, sortedSecondList)
            .map { abs($0 - $1) }
            .reduce(0, +)

        return "\(sum)"
    }

    func part2() -> String {

        let sum = firstList.reduce(0) { result, first in
            result + first * secondList.filter { $0 == first }.count
        }

        return "\(sum)"
    }
}