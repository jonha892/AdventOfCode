class Day4: Day {
  var input: String

  required init(input: String) {
    self.input = input
  }

  private func parseSet(_ input: String) -> Set<Int> {
    let components = input.components(separatedBy: .whitespaces).filter { !$0.isEmpty }.map {
      Int($0)!
    }
    return Set(components)
  }

  private func power(base: Int, exponent: Int) -> Int {
    var result = 1

    for _ in 0..<exponent {
      result *= base
    }

    return result
  }

  func partOne() -> Int {
    let parsed = self.input.components(separatedBy: "\n").map {
      $0.components(separatedBy: ": ")[1]
    }.map {
      $0.components(separatedBy: " | ").map { (s: String) in parseSet(s) }
    }

    var r = 0
    for p in parsed {
      let overlap = p[0].intersection(p[1])

      if overlap.count == 0 {
        continue
      }
      let winnings = power(base: 2, exponent: overlap.count - 1)
      //print(winnings)
      r += winnings
    }
    return r
  }

  func partTwo() -> Int {
    let parsed = self.input.components(separatedBy: "\n").map {
      $0.components(separatedBy: ": ")[1]
    }.map {
      $0.components(separatedBy: " | ").map { (s: String) in parseSet(s) }
    }

    var total: [Int: Int] = [1: 1]
    for (i, game) in parsed.enumerated() {
      let gameId = i + 1
      let overlap = game[0].intersection(game[1]).count
      total[gameId] = total[gameId] ?? 1

      print("id: \(gameId), overlap: \(overlap)")
      print(total)
      if overlap == 0 {
        continue
      }

      let repititions = total[gameId]!
      for j in gameId + 1...gameId + overlap {
        total[j] = (total[j] ?? 1) + repititions
      }
    }
    print(total)
    let sum = total.values.reduce(0, +)

    return sum
  }
}
