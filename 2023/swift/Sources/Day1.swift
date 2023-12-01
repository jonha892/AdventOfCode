extension String {
  public enum Digit: String {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine

    var value: Int {
      switch self {
      case .one: return 1
      case .two: return 2
      case .three: return 3
      case .four: return 4
      case .five: return 5
      case .six: return 6
      case .seven: return 7
      case .eight: return 8
      case .nine: return 9
      }
    }
  }

  static let digits: [Digit] = [.one, .two, .three, .four, .five, .six, .seven, .eight, .nine]

  private func findAllRanges(of substring: String) -> [Range<Index>] {
    var ranges: [Range<Index>] = []
    var start = self.startIndex

    while start < self.endIndex {
      let range = self.range(of: substring, range: start..<self.endIndex)
      if let range = range {
        ranges.append(range)
        start = range.upperBound
      } else {
        break
      }
    }
    return ranges
  }

  public enum Position {
    case first
    case last
  }

  public func findDigit(which: Position) -> (Index, Int?) {
    var idx = which == .first ? self.endIndex : self.startIndex
    var value: Int? = nil

    for digit in String.digits {
      let ranges = self.findAllRanges(of: digit.rawValue)

      if !ranges.isEmpty {
        if which == .first && ranges[0].lowerBound < idx {
          value = digit.value
          idx = ranges[0].lowerBound
        } else if which == .last && ranges[ranges.endIndex - 1].lowerBound > idx {
          value = digit.value
          idx = ranges[ranges.endIndex - 1].lowerBound
        }
      }
    }
    return (idx, value)
  }
}

class Day1: Day {
  var input: String

  required init(input: String) {
    self.input = input
  }

  func partOne() -> String {
    let lines = input.split(separator: "\n")

    var calibrations: [Int] = []
    for line in lines {
      // find first number
      let first = line.firstIndex(where: { $0.isNumber })
      // find last number
      let last = line.lastIndex(where: { $0.isNumber })
      if let first = first, let last = last {
        let firstNumber = line[first].wholeNumberValue!
        let lastNumber = line[last].wholeNumberValue!
        calibrations.append(firstNumber * 10 + lastNumber)
      } else {
        print("no numbers found in line: \(line)")
        return ""
      }
    }

    return String(calibrations.reduce(0, +))
  }

  func partTwo() -> String {
    let lines = input.split(separator: "\n")

    var calibrations: [Int] = []
    for l in lines {
      print()
      let line = String(l)

      // find first number
      let firstDigitStr = line.findDigit(which: .first)
      // find last number
      let lastDigitStr = line.findDigit(which: .last)

      let firstNumber = line.firstIndex(where: { $0.isNumber })
      // find last number
      let lastNumber = line.lastIndex(where: { $0.isNumber })

      //print("line: \(line)")
      //print(
      //  "firstDigitStr: \(firstDigitStr.0.utf16Offset(in: line)) lastDigitStr: \(lastDigitStr.0.utf16Offset(in: line))"
      //)
      //print("\(firstDigitStr.1 ?? -1) \(lastDigitStr.1 ?? -1)")
      //print(
      //  "firstNumber: \(String(describing: firstNumber?.utf16Offset(in: line))) lastNumber: \(String(describing: lastNumber?.utf16Offset(in: line)))"
      //)
      //print("last number value \(line[lastNumber!].wholeNumberValue!)")
      //print("\(lastNumber! > lastDigitStr.0)")

      var first = -1
      if let firstNumber = firstNumber {
        if firstNumber < firstDigitStr.0 {
          first = line[firstNumber].wholeNumberValue!
        } else {
          first = firstDigitStr.1!
        }
      } else {
        first = firstDigitStr.1!
      }

      var last = -1
      if let lastNumber = lastNumber {
        if lastNumber > lastDigitStr.0 || lastDigitStr.1 == nil {
          last = line[lastNumber].wholeNumberValue!
        } else {
          last = lastDigitStr.1!
        }
      } else {
        last = lastDigitStr.1!
      }

      let c = first * 10 + last
      print("first \(first) last \(last) => \(c)")

      calibrations.append(c)
    }

    return String(calibrations.reduce(0, +))
  }
}
