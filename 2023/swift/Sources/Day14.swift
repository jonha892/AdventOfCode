enum TiltDirection {
    case north, south, east, west
}

class Day14: Day {
    let reflectorDish: [[Character]]

    required init(input: String) {
        reflectorDish = input.split(separator: "\n").map { Array($0) }
    }

    /*
    * Tilt a row of rocks
    * rocks roll to the left
    */
    func tilt(row: [Character]) -> [Character] {
        //print("input: \(row)")
        var out = [Character]()
        
        var roundRocks = 0
        var empty = 0
        for (_, c) in row.enumerated().reversed() {
            if c == "#" {
                out = ["#"] + Array(repeating: "O", count: roundRocks) + Array(repeating: ".", count: empty) + out
                roundRocks = 0
                empty = 0
            } else if c == "O" {
                roundRocks += 1
            } else {
                empty += 1
            }
        }
        //print("round rocks: \(roundRocks) empty: \(empty)")
        if roundRocks > 0 || empty > 0 {
            out = Array(repeating: "O", count: roundRocks) + Array(repeating: ".", count: empty) + out
        }
        //print("output: \(out)")
        //print()
        return out
    }

    func tiltDish(dish: [[Character]], direction: TiltDirection) -> [[Character]] {
        var out = [[Character]](repeating: Array(repeating: ".", count: dish[0].count), count: dish.count)

        if direction == .north {
            for colIdx in 0..<dish[0].count {
                let col = dish.map { $0[colIdx] }
                let tiltedCol = tilt(row: col)
                for rowIdx in 0..<tiltedCol.count {
                    out[rowIdx][colIdx] = tiltedCol[rowIdx]
                }
            }
        } else if direction == .south {
            for colIdx in 0..<dish[0].count {
                let col = dish.map { $0[colIdx] }
                let tiltedCol: [Character] = tilt(row: col.reversed()).reversed()
                for rowIdx in 0..<tiltedCol.count {
                    out[rowIdx][colIdx] = tiltedCol[rowIdx]
                }
            }
        } else if direction == .east {
            for (i, row) in dish.enumerated() {
                let tiltedRow = tilt(row: row.reversed())
                out[i] = tiltedRow.reversed()
            }
        } else if direction == .west {
            for (i, row) in dish.enumerated() {
                let tiltedRow = tilt(row: row)
                out[i] = tiltedRow
            }
        }
        return out
    }

    func printDish(dish: [[Character]]) {
        for row in dish {
            print(String(row))
        }
        print()
    }

    func tiltDishRound(dish: [[Character]]) -> [[Character]] {
        var outDish = tiltDish(dish: dish, direction: .north)
        //printDish(dish: outDish)
        outDish = tiltDish(dish: outDish, direction: .west)
        //printDish(dish: outDish)
        outDish = tiltDish(dish: outDish, direction: .south)
        //printDish(dish: outDish)
        outDish = tiltDish(dish: outDish, direction: .east)
        return outDish
    }

    func partOne() -> Int {
        let tiltedDish = tiltDish(dish: self.reflectorDish, direction: .north)


        var total = 0
        for (i, row) in tiltedDish.enumerated() {
            //print(String(row))
            let score = tiltedDish.count - i
            //print(score)
            let roundRocks = row.filter { $0 == "O" }.count
            let rowTotal = score * roundRocks
            total += rowTotal
            print(String(row), " ", i, " ", rowTotal)
        }

        return total
    }

    func partTwo() -> Int {

        var dish = self.reflectorDish

        var repititionMap = [String: Int]()
        var rounds = 0
        var cycleLength = 0
        while true {
            //let direction = directions[rounds % directions.count]
            //dish = tiltDish(dish: dish, direction: direction)

            let dishString = String(dish.flatMap { $0 })
            if let previous = repititionMap[dishString] {
                cycleLength = rounds - previous
                break
            } else {
                repititionMap[dishString] = rounds
            }
            
            dish = tiltDishRound(dish: dish)
            rounds += 1
        }

        print("repitition found in round \(rounds)")
        let remainingRounds = (1_000_000_000 - rounds) % (cycleLength)
        print("rotating for another \(remainingRounds) rounds")
        for _ in 0..<remainingRounds {
            //let direction = directions[(rounds + i) % directions.count]
            //dish = tiltDish(dish: dish, direction: direction)
            dish = tiltDishRound(dish: dish)
        }

        var total = 0
        for (i, row) in dish.enumerated() {
            //print(String(row))
            let score = dish.count - i
            //print(score)
            let roundRocks = row.filter { $0 == "O" }.count
            let rowTotal = score * roundRocks
            total += rowTotal
            print(String(row), " ", i, " ", rowTotal)
        }

        return total
    }
}