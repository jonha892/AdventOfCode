class Day7: Day{
    init() {
        // super.init(day: 7, test: true)
        super.init(day: 7)
    }

    override func part1() -> Int {
        do {
            var hpos = self.inputLines[0].components(separatedBy: ",").map { Int($0)! }
            print(hpos)
            hpos.sort()
            print(hpos)
            var median = -1
            if hpos.count % 2 == 1 {
                let index = (hpos.count-1) / 2
                median = hpos[index]
            } else {
                let index = (hpos.count-1) / 2
                let m1 = hpos[index]
                let m2 = hpos[index+1]
                print(m1, m2)
                median = (m1 + m2) / 2
            }
            print("median", median)
            var fuelCosts = 0
            for pos in hpos {
                fuelCosts += abs(median-pos)
            }
            return fuelCosts
        } catch {
            print(error)
        }
        return -1
    }

    override func part2() -> Int {
        var hpos = self.inputLines[0].components(separatedBy: ",").map { Int($0)! }
        let min = hpos.min()!
        let max = hpos.max()!
        var minFuel = -1
        for v in stride(from: min, through: max, by: 1) {
            let fuelCosts = hpos.reduce(0, {(res, curr) in res + (abs(curr-v) * (abs(curr-v) + 1))/2 })
            // let fuelCosts = hpos.map({(curr) in (abs(curr-v) * (abs(curr-v) + 1))/2 })
            print(v, fuelCosts)
            if minFuel == -1 || fuelCosts < minFuel {
                minFuel = fuelCosts
            }
        }
        return minFuel
    }
}