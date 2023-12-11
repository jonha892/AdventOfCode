class Day11: Day {
    var input: String
    var grid: [[Character]]

    required init(input: String) {
        self.input = input
        self.grid = input.components(separatedBy: .newlines).map { Array($0) }
        extendGrid()
    }

    func extendGrid() {
        var extendRowIdx: [Int] = []
        var extendColIdx: [Int] = []

        for row in 0..<grid.count {
            if !grid[row].contains("#") {
                extendRowIdx.append(row)
            }
        }
        for r in extendRowIdx.reversed() {
            grid.insert(Array(repeating: ".", count: grid[0].count), at: r)
        }


        for col in 0..<grid[0].count {
            if !grid.map({ $0[col] }).contains("#") {
                extendColIdx.append(col)
            }
        }
        for c in extendColIdx.reversed() {
            for r in 0..<grid.count {
                grid[r].insert(".", at: c)
            }
        }
    }

    func walk(from start: Coordinate2D, to end: Coordinate2D, in grid: [[Character]]) -> Int {
        let width = grid[0].count
        let height = grid.count

        var costs: [Coordinate2D:Int] = [:]
        var visited: Set<Coordinate2D> = []
        var queue: [(Coordinate2D, Int)] = [(start, 0)]

        while !queue.isEmpty {
            let (current, cost) = queue.removeFirst()
            visited.insert(current)


            let neighbors = [
                Coordinate2D(x: current.x, y: current.y - 1),
                Coordinate2D(x: current.x, y: current.y + 1),
                Coordinate2D(x: current.x - 1, y: current.y),
                Coordinate2D(x: current.x + 1, y: current.y),
            ].filter { (neighbor) -> Bool in
                neighbor.x >= 0 && neighbor.x < width && neighbor.y >= 0 && neighbor.y < height }

            for neighbor in neighbors {
                if costs.keys.contains(neighbor) {
                    if cost + 1 < costs[neighbor]! {
                        costs[neighbor] = cost + 1
                    }
                } else {
                    costs[neighbor] = cost + 1
                }

                if !visited.contains(neighbor) && queue.filter({ $0.0 == neighbor }).isEmpty {
                    //print("que length: \(queue.count)")
                    queue.append((neighbor, cost + 1))
                }
            }
        }
        if !costs.keys.contains(end) {
            print("start: \(start) to end: \(end) is not possible, costs are: \(costs)")
            return -1
        }

        return costs[end]!
    }

    func manhattenDist(from start: Coordinate2D, to end: Coordinate2D) -> Int {
        return abs(start.x - end.x) + abs(start.y - end.y)
    }

    func partOne() -> Int {
        let galaxyPositions: [Coordinate2D] = grid.enumerated().flatMap { (rowIdx, row) -> [Coordinate2D] in
            return row.enumerated().compactMap { (colIdx, char) -> Coordinate2D? in
                if char == "#" {
                    return Coordinate2D(x: colIdx, y: rowIdx)
                }
                return nil
            }
        }

        var combinations: [(Coordinate2D, Coordinate2D)] = []
        for i in 0..<galaxyPositions.count {
            for j in i+1..<galaxyPositions.count {
                combinations.append((galaxyPositions[i], galaxyPositions[j]))
            }
        }
        print("combinations: \(combinations.count)")

        var sum = 0
        for (i, (start, end)) in combinations.enumerated() {
            //let distance = walk(from: start, to: end, in: grid)
            let distance = manhattenDist(from: start, to: end)
            print("(\(i+1) / \(combinations.count)) distance: \(distance)")
            sum += distance
        }

        return sum
    }

    func partTwo() -> Int {
        return -1
    }
}