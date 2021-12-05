class Day5: Day{
    init() {
        // super.init(day: 5, test: true)
        super.init(day: 5)
    }

    override func part1() -> Int {
        do {
            let pairs = try self.inputLines.map { try $0.components(separatedBy: " -> ").map { try Position2D(of: $0, separatedBy: ",") } }
            var findings = [Position2D: Int]()
            for pair in pairs {
                let p1 = pair[0]
                let p2 = pair[1]
                let between = p1.positionsBetweenPart1(other: p2)
                for point in between {
                    findings[point, default: 0] += 1
                }
            }
            return findings.filter{ $0.value >= 2 }.count
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return -1
    }

    override func part2() -> Int {
        do {
            let pairs = try self.inputLines.map { try $0.components(separatedBy: " -> ").map { try Position2D(of: $0, separatedBy: ",") } }
            var findings = [Position2D: Int]()
            for pair in pairs {
                let p1 = pair[0]
                let p2 = pair[1]
                let between = try p1.positionsBetween(other: p2)
                for point in between {
                    findings[point, default: 0] += 1
                }
            }
            return findings.filter{ $0.value >= 2 }.count
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return -1
    }
}