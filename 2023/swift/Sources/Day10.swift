enum Field: Equatable {
  static func == (lhs: Field, rhs: Field) -> Bool {
    switch (lhs, rhs) {
    case (.ground, .ground):
      return true
    case (.pipe(let lhsPipe), .pipe(let rhsPipe)):
      return lhsPipe == rhsPipe
    default:
      return false
    }
  }

  case ground
  case pipe(Pipe)

  func parse(_ char: Character) -> Field {
    switch char {
    case ".":
      return .ground
    default:
      return .pipe(Pipe.parse(char))
    }
  }
}

enum Direction: Equatable {
  case north
  case east
  case south
  case west
}

enum ConnectionDirection {
  case west_east
  case north_south
}

enum Pipe: Equatable {
  case start
  case vertical
  case horizontal
  case bend(Direction, Direction)  // from to

  static func parse(_ char: Character) -> Pipe {
    switch char {
    case "S":
      return .start
    case "|":
      return .vertical
    case "-":
      return .horizontal
    case "L":
      return .bend(.north, .east)
    case "J":
      return .bend(.north, .west)
    case "7":
      return .bend(.south, .west)
    case "F":
      return .bend(.south, .east)
    default:
      fatalError("Invalid pipe character: \(char)")
    }
  }

  static func canConnect(from a: Pipe, to b: Pipe, with direction: ConnectionDirection) -> Bool {
    switch (a, b, direction) {
    case (.start, .vertical, .north_south):
      return true
    case (.start, .bend(.north, _), .north_south):
      return true
    case (.start, .horizontal, .west_east):
      return true
    case (.start, .bend(_, .west), .west_east):
      return true

    case (.vertical, .vertical, .north_south):
      return true
    case (.horizontal, .horizontal, .west_east):
      return true

    case (.vertical, .start, .north_south):
      return true
    case (.vertical, .bend(.north, _), .north_south):
      return true
    case (.bend(.south, _), .start, .north_south):
      return true
    case (.bend(.south, _), .bend(.north, _), .north_south):
      return true
    case (.bend(.south, _), .vertical, .north_south):
      return true

    case (.horizontal, .start, .west_east):
      return true
    case (.horizontal, .bend(_, .west), .west_east):
      return true
    case (.bend(_, .east), .start, .west_east):
      return true
    case (.bend(_, .east), .horizontal, .west_east):
      return true
    case (.bend(_, .east), .bend(_, .west), .west_east):
      return true

    default:
      return false
    }
  }
}

struct GridPoint: Hashable {
  let x: Int
  let y: Int
}

class Day10: Day {
  var input: String
  let grid: [[Field]]

  required init(input: String) {
    self.input = input
    self.grid = input.split(separator: "\n").map { row in
      row.map { char in
        Field.ground.parse(char)
      }
    }

    print("grid: \(self.grid)")
  }

  func neighbors(of point: GridPoint, limitX: Int, limitY: Int) -> [GridPoint] {
    let (x, y) = (point.x, point.y)
    return [
      GridPoint(x: x - 1, y: y),
      GridPoint(x: x + 1, y: y),
      GridPoint(x: x, y: y - 1),
      GridPoint(x: x, y: y + 1),
    ].filter { neighbor in
      return neighbor.x >= 0 && neighbor.x < limitX && neighbor.y >= 0 && neighbor.y < limitY
    }
  }

  func printDistance(costs: [[Int]]) {
    for row in costs {
      for cost in row {
        if cost == Int.max {
          print("  .", terminator: "")
        } else {
          print(String(format: "%3d", cost), terminator: "")
        }
      }
      print("")
    }
  }

  func isReachable(from start: GridPoint, to end: GridPoint, in grid: [[Field]]) -> Bool {
    let startField = grid[start.y][start.x]
    let endField = grid[end.y][end.x]

    var pipeStart: Pipe?
    var pipeEnd: Pipe?

    //print("checking \(start) -> \(end) with \(startField) -> \(endField)")

    switch (startField, endField) {
    case (.ground, _):
      return false
    case (_, .ground):
      return false
    case (.pipe(let start), .pipe(let end)):
      pipeStart = start
      pipeEnd = end
    default:
      fatalError("Invalid start/end combination: \(start) -> \(end)")
    }

    var directions: ConnectionDirection? = nil
    if start.x == end.x && start.y < end.y {
      directions = .north_south
    } else if start.x == end.x && start.y > end.y {
      let tmp = pipeStart
      pipeStart = pipeEnd
      pipeEnd = tmp

      directions = .north_south
    } else if start.y == end.y && start.x > end.x {
      let tmp = pipeStart
      pipeStart = pipeEnd
      pipeEnd = tmp

      directions = .west_east
    } else if start.y == end.y && start.x < end.x {
      directions = .west_east
    } else {
      fatalError("Invalid start/end combination: \(start) -> \(end)")
    }

    let connected = Pipe.canConnect(from: pipeStart!, to: pipeEnd!, with: directions!)
    //print("is connected: \(connected)")

    return connected
  }

  func walk(from start: GridPoint) -> [[Int]] {
    let width = self.grid[0].count
    let height = self.grid.count

    print("grid \(self.grid)")

    var distances = [[Int]](
      repeating: [Int](repeating: Int.max, count: self.grid[0].count), count: self.grid.count)
    distances[start.y][start.x] = 0

    var visited = Set<GridPoint>()
    var queue = [(start, 0)]

    var i = 0
    while !queue.isEmpty {
      let (currentPos, currentCost) = queue.removeFirst()
      //print("visiting \(currentPos) with cost \(currentCost)")
      visited.insert(currentPos)

      distances[currentPos.y][currentPos.x] = currentCost

      let neighbors = self.neighbors(
        of: currentPos, limitX: width, limitY: height
      )
      .filter { neighbor in
        self.grid[neighbor.y][neighbor.x] != .ground
      }
      .filter { neightbor in
        isReachable(from: currentPos, to: neightbor, in: self.grid)
      }
      .filter { neighbor in
        let knownCost = distances[neighbor.y][neighbor.x]
        return knownCost > currentCost + 1
      }
      .map { neighbor in
        (neighbor, currentCost + 1)
      }

      //print("new points to visit: \(neighbors)")
      //printDistance(costs: distances)
      if neighbors.count != 1 && i > 0 {
        print("new elements number \(neighbors.count)")
        print("neighbors of \(currentPos):")
        print("current pipe: \(self.grid[currentPos.y][currentPos.x])")
        let x = self.neighbors(of: currentPos, limitX: width, limitY: height)
        for x in x {
          print("\(x) -> \(self.grid[x.y][x.x])")
        }

        print("wanted to add...")
        for x in neighbors {
          print("\(x) -> \(self.grid[x.0.y][x.0.x])")
        }
        break
      }

      queue.append(contentsOf: neighbors)
      i += 1
    }
    print("iterations: \(i)")
    return distances
  }

  func partOne() -> Int {
    var start: GridPoint? = nil
    for (y, row) in self.grid.enumerated() {
      for (x, field) in row.enumerated() {

        if field == .pipe(.start) {
          start = GridPoint(x: x, y: y)
        }
      }
    }

    let distances = self.walk(from: start!)
    let maxDistance = distances.flatMap { $0 }
      .filter { $0 != Int.max }
      .max()!
    return maxDistance
  }

  func partTwo() -> Int {
    var start: GridPoint? = nil
    for (y, row) in self.grid.enumerated() {
      for (x, field) in row.enumerated() {

        if field == .pipe(.start) {
          start = GridPoint(x: x, y: y)
        }
      }
    }

    let distances = self.walk(from: start!)

    return -1
  }
}
