enum TurnDirection: String {
  case left = "L"
  case right = "R"
}

typealias Location = String

struct NodeDirection: CustomStringConvertible {
  let left: Location
  let right: Location

  init(left: Location, right: Location) {
    self.left = left
    self.right = right
  }

  var description: String {
    return "(left: \(left), right: \(right))"
  }
}

class Day8: Day {
  var input: String
  var network: [Location: NodeDirection] = [:]
  let instructions: [TurnDirection]

  required init(input: String) {
    self.input = input

    let parts = input.components(separatedBy: "\n")
    self.instructions = parts[0].map { TurnDirection(rawValue: String($0))! }

    parts[2...].map { (line: String) -> (Location, NodeDirection) in
      var parts = line.components(separatedBy: " = ")
      let origin = parts[0]
      parts[1].removeAll(where: { $0 == "(" || $0 == ")" })
      let directions = parts[1].components(separatedBy: ", ")

      return (origin, NodeDirection(left: directions[0], right: directions[1]))
    }.forEach { (origin: Location, nodeDirection: NodeDirection) in
      self.network[origin] = nodeDirection
    }
  }

  func walk(from: Location, withFinish: (String) -> Bool) -> Int {
    var instructionIndex = 0
    var totalSteps = 0
    var current = from
    while true {
      instructionIndex = instructionIndex % instructions.count
      let instruction = instructions[instructionIndex]

      let nodeDirection = network[current]!
      switch instruction {
      case .left:
        current = nodeDirection.left
      case .right:
        current = nodeDirection.right
      }
      instructionIndex += 1
      totalSteps += 1

      if withFinish(current) {
        return totalSteps
      }
    }
  }

  func partOne() -> Int {
    print("instructions: \(instructions)")
    print("network: \(network)")

    return walk(from: "AAA", withFinish: { $0 == "ZZZ" })
  }

  private func lcm(_ a: Int, _ b: Int) -> Int {
    return abs(a * b) / gcd(a, b)
  }

  private func gcd(_ a: Int, _ b: Int) -> Int {
    var a = a
    var b = b
    while b != 0 {
      let temp = b
      b = a % b
      a = temp
    }
    return a
  }

  func partTwo() -> Int {
    let current: [Location] = network.keys.filter { $0.hasSuffix("A") }

    print("start \(current)")

    let minSteps = current.map { walk(from: $0, withFinish: { $0.hasSuffix("Z") }) }
    print("minSteps: \(minSteps)")

    let steps = minSteps.reduce(
      1,
      {
        (curr, next) -> Int in
        return lcm(curr, next)
      })
    return steps
  }
}
