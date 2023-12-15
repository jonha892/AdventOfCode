enum AoCError: Error {
  case DevError(String)
}

class Day12: Day {
  var input: String

  let records: [String]
  let descriptions: [[Int]]

  required init(input: String) {
    self.input = input
    let lines = input.components(separatedBy: .newlines).map {
      $0.components(separatedBy: .whitespaces)
    }
    let records = lines.map { $0[0] }
    let descriptions = lines.map { $0[1].components(separatedBy: ",").map { Int($0)! } }
    self.records = records
    self.descriptions = descriptions
  }

  func countGroups(inputString: String) -> [Int] {
    let groups = inputString.components(separatedBy: ".")
    var groupSizes = [Int]()

    for group in groups {
      let hashesCount = group.components(separatedBy: "#").count - 1
      groupSizes.append(hashesCount)
    }
    return groupSizes.filter { $0 > 0 }
  }

  func generatePossibilities(N: Int, M: Int) -> [[Int]] {

    var possibilities = [[Int]]()

    for bitset in 0..<1 << M {
      let indices = (0..<M).compactMap { (bitset & (1 << $0)) != 0 ? $0 : nil }

      if indices.count == N {
        let possibility = (0..<M).map { indices.contains($0) ? 1 : 0 }
        possibilities.append(possibility)
      }
    }

    return possibilities
  }

  func fixRecord(record: String, description: [Int]) -> [String] {
    let targetDamaged = description.reduce(0, +)
    let existingDamaged = record.filter { $0 == "#" }.count
    let missingDamaged = targetDamaged - existingDamaged

    let unknownPositions = record.indices.filter { record[$0] == "?" }.map {
      $0.utf16Offset(in: record)
    }

    let possibilities = generatePossibilities(N: missingDamaged, M: unknownPositions.count)
    var validRecord = [String]()
    for possibility in possibilities {
      var candidate = Array(record)
      for (index, replace) in zip(unknownPositions, possibility) {
        if replace == 1 {
          candidate[index] = "#"
        }
      }
      candidate.replace("?", with: ".")

      let groups = countGroups(inputString: String(candidate))
      if groups == description {
        validRecord.append(String(candidate))
      }
    }

    return validRecord
  }

  func possibleWays(cache: inout [String: Int], vents: [Character], within: Int?, remaining: [Int])
    -> Int
  {
    if vents.isEmpty {
      return switch (within, remaining.count) {
      case (nil, 0): 1
      case (let x, 1): x == remaining[0] ? 1 : 0
      default: 0
      }
    }

    if let _ = within, remaining.isEmpty {
      return 0
    }

    let key = "\(vents.count)-\(within ?? 0)-\(remaining.count)"
    if let cached = cache[key] {
      return cached
    }

    let ways =
      switch (vents.first!, within) {
      case (".", nil):
        possibleWays(cache: &cache, vents: Array(vents[1...]), within: nil, remaining: remaining)
      case (".", let x):
        if x != remaining.first! {
          0
        } else {
          possibleWays(
            cache: &cache, vents: Array(vents[1...]), within: nil, remaining: Array(remaining[1...])
          )
        }
      case ("#", nil):
        possibleWays(cache: &cache, vents: Array(vents[1...]), within: 1, remaining: remaining)
      case ("#", let x):
        possibleWays(cache: &cache, vents: Array(vents[1...]), within: x! + 1, remaining: remaining)
      case ("?", nil):
        possibleWays(cache: &cache, vents: Array(vents[1...]), within: 1, remaining: remaining)
          + possibleWays(
            cache: &cache, vents: Array(vents[1...]), within: nil, remaining: remaining)
      case ("?", let x):
        if x == remaining.first! {
          possibleWays(
            cache: &cache, vents: Array(vents[1...]), within: x! + 1, remaining: remaining)
            + possibleWays(
              cache: &cache, vents: Array(vents[1...]), within: nil,
              remaining: Array(remaining[1...])
            )
        } else {
          possibleWays(
            cache: &cache, vents: Array(vents[1...]), within: x! + 1, remaining: remaining)
        }

      default:
        fatalError("switch case")
      }

    cache[key] = ways
    return ways
  }

  func partOne() -> Int {
    return -1
    var total = 0
    for (record, description) in zip(records, descriptions) {
      print(record, description)
      let validRecords = fixRecord(record: record, description: description)
      total += validRecords.count
    }
    return total
  }

  func partTwo() -> Int {
    let records = self.records.map { (description: String) in
      String(repeating: description + String("?"), count: 5).dropLast()
    }
    let descriptions = self.descriptions.map { (description: [Int]) in
      Array(repeating: description, count: 5).flatMap { $0 }
    }

    var total = 0
    for (record, description) in zip(records, descriptions) {
        var cache = [String: Int]()
        let ways = possibleWays(cache: &cache, vents: Array(record), within: nil, remaining: description)
        total += ways
        print(ways, record, description)
    }

    return total
  }
}
