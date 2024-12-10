import Foundation

class Day6: Day {

    var labGrid: [[Character]]

    init(filename: String) throws {
        do {
            let grid = try String(contentsOfFile: filename, encoding: .utf8).components(
                separatedBy: .newlines)
            self.labGrid = grid.map { Array($0) }
        } catch {
            print("Error reading file \(error)")
            throw error
        }
    }

    enum Direction {
        case up
        case right
        case down
        case left
    }

    enum AoCError: Error {
        case invalidDirection
    }

    func printGrid() {
        for row in self.labGrid {
            print(String(row))
        }
        print("----")
    }

    func findStartPos() throws -> ((Int, Int), Direction) {
        for (idy, row) in self.labGrid.enumerated() {
            for (idx, cell) in row.enumerated() {
                switch cell {
                case "^":
                    return ((idx, idy), .up)
                case ">":
                    return ((idx, idy), .right)
                case "v":
                    return ((idx, idy), .down)
                case "<":
                    return ((idx, idy), .left)
                default:
                    continue
                }
            }
        }
        throw AoCError.invalidDirection
    }

    enum Action {
        case finished
        case cont
        case turn
    }

    func checkNext(_ pos: (Int, Int)) -> Action {
        let (x, y) = pos
        if x < 0 || y < 0 || x >= self.labGrid[0].count || y >= self.labGrid.count {
            return .finished
        }

        let cell = self.labGrid[y][x]
        if cell == "." || cell == "X" {
            return .cont
        } else {
            return .turn
        }
    }

    func part1() -> String {
        var sum = 0
        //var visited: Set<(Int, Int)> = []
        var visited: [(Int, Int)] = []
        var currentPos: (Int, Int) = (0, 0)
        var currentDir: Direction = .up

        do {
            (currentPos, currentDir) = try findStartPos()
        } catch {
            print("Error finding start position \(error)")
            return "-1"
        }
        print("startPos: \(currentPos)")

        while true {
            let (x, y) = currentPos
            //print("currentPos: \(currentPos)")

            let nextPos: (Int, Int) =
                switch currentDir {
                case .up:
                    (x, y - 1)
                case .right:
                    (x + 1, y)
                case .down:
                    (x, y + 1)
                case .left:
                    (x - 1, y)
                }
            let action = checkNext(nextPos)

            if action == .finished {
                self.labGrid[y][x] = "X"
                break
            } else if action == .cont {
                currentPos = nextPos
            } else {
                currentDir = switch currentDir {
                    case .up:
                        .right
                    case .right:
                        .down
                    case .down:
                        .left
                    case .left:
                        .up
                }
            }
            self.labGrid[y][x] = "X"
            //printGrid()
            if !visited.contains(where: { $0 == currentPos }) {
                visited.append(currentPos)
            }
        }

        for row in self.labGrid {
            sum += row.filter { $0 == "X" }.count
        }

        //sum = visited.count
        return "\(sum)"
    }

    func part2() -> String {
        var sum = 0
        let (height, width) = (self.labGrid.count, self.labGrid[0].count)
        print("height: \(height), width: \(width)")
        sum = 1

        return "\(sum)"
    }
}
