class Day12: Day {
  var input: String
  let mirrors: [[String]]

  required init(input: String) {
    self.input = input

    self.mirrors = input.components(separatedBy: "\n\n").map { $0.components(separatedBy: "\n") }
    print(mirrors)
  }

  func missorsHorizontal(mirror: [String]) -> (Bool, Int?) {
    for y in 0..<mirror.count - 1 {
      var offset = 0
      var isMirrored = true
      while isMirrored && y - offset >= 0 && y + offset + 1 < mirror.count {
        let rowUp = y - offset
        let rowDown = y + offset + 1

        let upper = mirror[rowUp]
        let lower = mirror[rowDown]

        isMirrored = upper == lower
        offset += 1
      }

      if isMirrored {
        return (true, y + 1)
      }
    }
    return (false, nil)
  }

  func mirrorsVertically(mirror: [String]) -> (Bool, Int?) {
    for x in 0..<mirror[0].count - 1 {
      var offset = 0
      var isMirrored = true
      while isMirrored && x - offset >= 0 && x + offset + 1 < mirror[0].count {
        let colLeft = x - offset
        let colRight = x + offset + 1

        let left = mirror.map { Array($0)[colLeft] }
        let right = mirror.map { Array($0)[colRight] }

        isMirrored = left == right

        offset += 1
      }

      if isMirrored {
        return (true, x + 1)
      }
    }
    return (false, nil)
  }

  func isMirrored(mirror: [String]) -> (Bool, Int) {
    let (isMirroredVertically, x) = mirrorsVertically(mirror: mirror)

    print("isMirroredVertically: \(isMirroredVertically), x: \(x)")
    if let x = x {
      return (true, x)
    }

    let (isMirroredHorizontally, y) = missorsHorizontal(mirror: mirror)
    print("isMirroredHorizontally: \(isMirroredHorizontally), y: \(y)")
    if let y = y {
      return (true, y * 100)
    }

    return (false, 0)
  }

  func diff(a: String, b: String) -> [Int] {
    return zip(a, b).enumerated().compactMap {
      (i: Int, tpl: (String.Element, String.Element)) -> Int? in
      if tpl.0 != tpl.1 { return i } else { return nil }
    }
  }

  func missorsHorizontalP2(mirror: [String]) -> Int {
    for y in 0..<mirror.count - 1 {
      var offset = 0
      var smudges = 0
      while smudges <= 1 && y - offset >= 0 && y + offset + 1 < mirror.count {
        let rowUp = y - offset
        let rowDown = y + offset + 1

        let upper = mirror[rowUp]
        let lower = mirror[rowDown]

        let d = diff(a: upper, b: lower)
        smudges += d.count

        offset += 1
      }

      if smudges == 1 {
        return y + 1
      }
    }
    return 0
  }

  func mirrorsVerticallyP2(mirror: [String]) -> Int {
    for x in 0..<mirror[0].count - 1 {
      var offset = 0
      var smudges = 0
      while smudges <= 1 && x - offset >= 0 && x + offset + 1 < mirror[0].count {
        let colLeft = x - offset
        let colRight = x + offset + 1

        let left = mirror.map { Array($0)[colLeft] }
        let right = mirror.map { Array($0)[colRight] }

        smudges += diff(a: String(left), b: String(right)).count

        offset += 1
      }

      if smudges == 1 {
        return x + 1
      }
    }
    return 0
  }

  func partOne() -> Int {

    var total = 0
    for mirror in self.mirrors {
      let (isMirrored, score) = isMirrored(mirror: mirror)
      total += score
    }

    return total
  }

  func partTwo() -> Int {
    var total = 0
    for mirror in self.mirrors {
      let x = mirrorsVerticallyP2(mirror: mirror)
      let y = missorsHorizontalP2(mirror: mirror)
      total += x + y * 100
    }
    return total
  }
}
