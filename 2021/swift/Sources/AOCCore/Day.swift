open class Day {
    public var inputLines: [String] = []

    public init(day: UInt8, test: Bool = false) {
        self.inputLines = loadLines(day: day, test: test)
    }

    private func loadLines(day: UInt8, test: Bool = false) -> [String] {
        var suffix = ""
        if (test) {
            suffix = String(format: "/data/day0%d_test.txt", day)
        } else {
            suffix = String(format: "/data/day0%d.txt", day)
        }
        let path = FileManager.default.currentDirectoryPath + suffix
        print("Loading input lines from: \t", path)
        let input = try! String(contentsOfFile: path)
        return input.components(separatedBy: "\n")
    }

    open func part1() -> Int {
        return -1
    }

    open func part2() -> Int {
        return -2
    }
}