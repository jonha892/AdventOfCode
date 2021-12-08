class Day8: Day{
    init() {
        // super.init(day: 8, test: true)
        super.init(day: 8)
    }

    override func part1() -> Int {
        let patterns = self.inputLines.map{ $0.components(separatedBy: " | ").map{ $0.components(separatedBy: " ") }}
        print(patterns[0][1].reduce(0, {(a, b) in a + 1 }))
        let uniqueLen = Set([2, 3, 4, 7])
        var totalUniques = 0
        for pattern in patterns {
            let uniqueNumbers = pattern[1].reduce(0, {res, curr in res + (uniqueLen.contains(curr.count) ? 1 : 0)})
            totalUniques += uniqueNumbers
            print(uniqueNumbers)
        }
        // let uniqueCount = self.inputLines.reduce(0, {(res, element) in res + element[1].reduce(0, {(res_, curr_) in res_ + (uniqueLen.contains(curr_.count) ? 1 : 0) }) } )
        // print(uniqueCount)
        return totalUniques
    }

    override func part2() -> Int {
        return -1
    }
}