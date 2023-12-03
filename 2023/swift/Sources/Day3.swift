import Foundation

class Day3: Day {
  var input: String
  var lines: [String] = []

  required init(input: String) {
    self.input = input
    self.lines = input.components(separatedBy: "\n")
  }

  func isAdjacentToSymbol(lineIdx: Int, range: Range<String.Index>) -> Bool {
    let line = self.lines[lineIdx]

    let startX = range.lowerBound.utf16Offset(in: line) - 1
    let endX = range.upperBound.utf16Offset(in: line)

    for x in startX...endX {
      if x < 0 || x >= line.count {
        continue
      }
      for y in lineIdx - 1...lineIdx + 1 {
        if y < 0 || y >= self.lines.count {
          continue
        }
        let line = self.lines[y]
        let idx = line.index(line.startIndex, offsetBy: x)
        let char = line[idx]

        //print("checking \(char) at \(x), \(y)")

        if !char.isNumber && char != "." {
          return true
        }
      }
    }
    return false
  }

  func partOne() -> String {
    var adjecent: [Int] = []

    for (i, line) in lines.enumerated() {
      let numbers = line.matches(of: ##/(\d+)/##)
      for number in numbers {
        let r = number.range
        let value = Int(number.0)!
        let isAdjacent = isAdjacentToSymbol(lineIdx: i, range: r)
        //print("\(i) \(value) \(isAdjacent)")
        if isAdjacent {
          adjecent.append(value)
        }
      }
    }
    print("adjecent = \(adjecent.count)")
    return "\(adjecent.reduce(0, +))"
  }

  private func rangeToOffset(_ range: Range<String.Index>, in line: String) -> (Int, Int) {
    let startX = range.lowerBound.utf16Offset(in: line)
    let endX = range.upperBound.utf16Offset(in: line) - 1
    return (startX, endX)
  }

  struct NumberPosition: Hashable, Equatable {
    static func == (lhs: Day3.NumberPosition, rhs: Day3.NumberPosition) -> Bool {
      return lhs.number == rhs.number && lhs.y == rhs.y && lhs.xStart == rhs.xStart
        && lhs.xEnd == rhs.xEnd
    }

    let number: Int
    let y: Int
    let xStart: Int
    let xEnd: Int
  }

  func partTwo() -> String {
    let numbers = lines.enumerated().flatMap { (y: Int, line: String) in
      line.matches(of: ##/(\d+)/##).map({
        let (startX, endX) = rangeToOffset($0.range, in: line)
        return NumberPosition(number: Int($0.0)!, y: y, xStart: startX, xEnd: endX)
      })
    }
    //print("\(numbers.count) \(numbers)")
    var ratios: [Int] = []
    for (i, line) in lines.enumerated() {
      let gearPositions = line.matches(of: ##/(\*)+/##)
      for gearPosition in gearPositions {
        let gearRange = gearPosition.range

        let startX = line.index(
          gearRange.lowerBound, offsetBy: -1, limitedBy: line.startIndex)!.utf16Offset(in: line)
        let endX = line.index(gearRange.upperBound, offsetBy: 1, limitedBy: line.endIndex)!
          .utf16Offset(in: line)

        var connected: [Day3.NumberPosition] = []
        for y in max(0, i - 1)...min(i + 1, self.lines.count) {
          let line = self.lines[y]
          for x in startX..<endX {
            if x < 0 || x >= line.count {
              continue
            }

            let connectedNumbers = numbers.filter({
              (numberPos) in
              return numberPos.y == y && x >= numberPos.xStart && x <= numberPos.xEnd
            })
            connected.append(contentsOf: connectedNumbers)
          }
        }

        let unique = Set(connected)
        if unique.count == 2 {
          //print("\(i) \(unique.count) \(unique)")
          ratios.append(unique.reduce(1, { $0 * $1.number }))
        } else if unique.count > 2 {
          print("too many unique numbers \(unique)")
        }
      }
    }
    let sum = ratios.reduce(0, +)
    return "\(sum)"
  }
}
