import Foundation

class Day1: Day{
    init() {
        super.init(day: 1)
    }

    override func part1() -> Int {
        let inputData = self.inputLines.map { Int($0)! }

        var increases = 0
        for index in 1 ..< inputData.count {
            let prev = inputData[index-1]
            let curr = inputData[index]
            if curr > prev {
                increases += 1
            }
        }
        return increases
    }

    override func part2() -> Int {
        let inputData = self.inputLines.map { Int($0)! }

        var increases = 0
        var slidingWindowSum: [Int] = []
        for index in 2 ..< inputData.count {
            let beforePrev = inputData[index-2]
            let prev = inputData[index-1]
            let curr = inputData[index]
            slidingWindowSum.append(beforePrev + prev + curr)
        }
        for index in 1..<slidingWindowSum.count {
            let prev = slidingWindowSum[index-1]
            let curr = slidingWindowSum[index]
            if curr > prev {
                increases += 1
            }
        }
        return increases
    }
}