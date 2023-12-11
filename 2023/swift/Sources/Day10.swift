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

  func walk(from start: GridPoint, in grid: [[Field]]) -> ([[Int]], Set<GridPoint>) {
    let width = grid[0].count
    let height = grid.count

    print("grid \(grid)")

    var distances = [[Int]](
      repeating: [Int](repeating: Int.max, count: grid[0].count), count: grid.count)
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
        grid[neighbor.y][neighbor.x] != .ground
      }
      .filter { neightbor in
        isReachable(from: currentPos, to: neightbor, in: grid)
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
        print("current pipe: \(grid[currentPos.y][currentPos.x])")
        let x = self.neighbors(of: currentPos, limitX: width, limitY: height)
        for x in x {
          print("\(x) -> \(grid[x.y][x.x])")
        }

        print("wanted to add...")
        for x in neighbors {
          print("\(x) -> \(grid[x.0.y][x.0.x])")
        }
        break
      }

      queue.append(contentsOf: neighbors)
      i += 1
    }
    print("iterations: \(i)")
    return (distances, visited)
  }

  func compress(grid: [[Field]]) -> [[Field]]{
    var grid = grid
    var removedRows = 0
    for (i, row) in grid.enumerated() {
      let canCompressRow = row.allSatisfy { (r: Field) -> Bool in
        return r == .ground || r == .pipe(.vertical)
      }
      if canCompressRow {
        print("can compress row \(i)")
        grid.remove(at: i-removedRows)
        removedRows += 1
      }
    }

    var removeColIdxs = [Int]()
    for colIdx in 0..<grid[0].count {
      let col = grid.map { $0[colIdx] }
      let canCompressCol = col.allSatisfy({
        (f: Field) -> Bool in
        return f == .ground || f == .pipe(.horizontal)
      })
      if canCompressCol {
        removeColIdxs.append(colIdx)
      }
    }
    print("remove col idxs: \(removeColIdxs)")
    for rowIdx in grid.indices {
      for colIdx in removeColIdxs.reversed() {
        grid[rowIdx].remove(at: colIdx) 
      }
    }

    return grid
  }

  func replaceUnvisited(grid: [[Field]], visited: Set<GridPoint>) -> [[Field]] {
    var grid = grid
    for (y, row) in grid.enumerated() {
      for (x, field) in row.enumerated() {
        if field == .pipe(.start) {
          continue
        }

        let point = GridPoint(x: x, y: y)
        if !visited.contains(point) {
          grid[y][x] = .ground
        }
      }
    }

    return grid
  }

  func compactRow(row: [Field]) -> [Field] {
    var outRow = [Field]()
    
    var crossing: Field? = nil
    let ignore = [Field.ground, .pipe(.vertical), .pipe(.horizontal)]
    for field in row {
      if ignore.contains(field) {
        outRow.append(field)
        continue
      }

      if crossing == nil {
        crossing = field
        outRow.append(field)
        continue
      }
      switch (crossing!, field) {
        case (.pipe(.start), _):
          continue // wrong
        case (.pipe(.bend(.north, .east)), .pipe(.bend(.south, .west))):
          outRow.append(.pipe(.vertical))
          crossing = nil
        case (.pipe(.bend(.north, .east)), .pipe(.bend(.north, .west))):
          outRow.append(.pipe(.horizontal))
          crossing = nil
        case (.pipe(.bend(.south, .east)), .pipe(.bend(.north, .west))):
          outRow.append(.pipe(.vertical))
          crossing = nil
        case (.pipe(.bend(.south, .east)), .pipe(.bend(.south, .west))):
          outRow.append(.pipe(.horizontal))
          crossing = nil
        default:
          outRow.append(crossing!)
          outRow.append(field)
          crossing = nil
      }
    }
    
    return outRow
  }

  func fillRow(row fields: [Field]) -> [Field] {
    var outRow = [Field]()
    //print("filling row \(fields)")
    for fieldIdx in fields.startIndex+1..<fields.endIndex-1 {
      let current = fields[fieldIdx-1]
      let next = fields[fieldIdx]
      outRow.append(current)
      switch (current, next) {
        case(.ground, _):
          outRow.append(.ground)
        case(.pipe(.bend(_, .west)), _):
          outRow.append(.ground)
        case(.pipe(.vertical), _):
          outRow.append(.ground)
        default:
          outRow.append(.pipe(.horizontal))
      }
    }
    //print("out row: \(outRow)")
    outRow.append(fields[fields.endIndex-1])
    //print("after last append")
    
    return outRow
  }

  func fillGrid(grid: [[Field]]) -> [[Field]] {
    var outGrid = [[Field]]()

    for row in grid {
      let outRow = fillRow(row: row)
      outGrid.append(outRow)
    }
    return outGrid
  }

  func part2walk(from starts: [GridPoint], in grid: [[Field]]) -> Set<GridPoint> {
    let width = grid[0].count
    let height = grid.count

    var visited = Set<GridPoint>()
    var queue = starts

    while !queue.isEmpty {
      let currentPos = queue.removeFirst()

      visited.insert(currentPos)

      let neighbors = self.neighbors(
        of: currentPos, limitX: width, limitY: height
      ).filter({ neighbor in
        !visited.contains(neighbor) 
      }).filter( {neighbor in
        let field = grid[neighbor.y][neighbor.x]
        return field != .ground
      })

      queue.append(contentsOf: neighbors)
    }
    return visited
  }

  func isCrossing(field: Field) -> Bool {
    switch field {
    case .ground:
      return false
    case .pipe(.start):
      return true
    case .pipe(.horizontal):
      return false
    case .pipe(_):
      return true
    }
  }

  func pointsInside(grid: [[Field]]) -> [GridPoint] {
    var points = [GridPoint]()
    
    for (y, row) in grid.enumerated() {
      var n_crossings = 0
      var newInsidePoints = [GridPoint]()
      let row = compactRow(row: row)
      for (x, field) in row[1..<row.endIndex-1].enumerated() {
        if field == .ground {
          if n_crossings % 2 == 1 {
            let point = GridPoint(x: x, y: y)
            newInsidePoints.append(point)
          }
        } else if isCrossing(field: field) {
          n_crossings += 1
        }
      }
      print("row \(y) has \(n_crossings) crossings new points: \(newInsidePoints)")
      points.append(contentsOf: newInsidePoints)
    }

    return points
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

    let (distances, _) = self.walk(from: start!, in: self.grid)
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

    //var grid = self.compress(grid: self.grid)
    let (_, visited) = self.walk(from: start!, in: self.grid)
    print("replace unvisited")
    var grid = self.replaceUnvisited(grid: self.grid, visited: visited)

    print("fill grid")
    grid = self.fillGrid(grid: grid)

    // p1 2
    grid[1][1] = .pipe(.bend(.south, .east))
    // p11
    //grid[1][1] = .pipe(.bend(.south, .east))
    // real
    //grid[1][1] = .pipe(.bend(.south, .east))

    var starts = [GridPoint]()
    for (y, row) in grid.enumerated() {
      for (x, field) in row.enumerated() {
        switch (x, y, field) {
          case(0, _, .ground):
            starts.append(GridPoint(x: x, y: y))
          case(_, 0, .ground):
            starts.append(GridPoint(x: x, y: y))
          case(grid[0].count-1, _, .ground):
            starts.append(GridPoint(x: x, y: y))
          case(_, grid.count-1, .ground):
            starts.append(GridPoint(x: x, y: y))
          default:
            continue
        }
      }
    }

    print("walk part 2")
    let visited2 = part2walk(from: starts, in: grid)
    
    let allGroundsPoints = grid.enumerated().flatMap { (y, row) in
      row.enumerated().map { (x, field) in
        GridPoint(x: x, y: y)
      }
    }.filter { point in
      grid[point.y][point.x] == .ground
    }

    let insidePoints = allGroundsPoints.filter { point in
      !visited2.contains(point)
    }
    return insidePoints.count

    //let insidePoints = pointsInside(grid: grid)
    //return insidePoints.count
  }
}
