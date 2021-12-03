class Day3: Day{
    init() {
        super.init(day: 3)
    }

    override func part1() -> Int {
        var diagnosticCount = Array(repeating: 0, count: self.inputLines[0].count)
        for line in self.inputLines {
            for (index, bit) in line.enumerated() {
                if bit == "1" {
                    diagnosticCount[index] += 1
                }
            }
        }
        let threshold = self.inputLines.count / 2
        let gammaRateDiagnostic = diagnosticCount.map { $0 > threshold ? "1" : "0" }.joined()
        let gammaRate = Int(gammaRateDiagnostic, radix: 2)!
        let epsilonRateDiagnostic = diagnosticCount.map { $0 <=  threshold ? "1" : "0" }.joined()
        let epsilonRate = Int(epsilonRateDiagnostic, radix: 2)!
        let powerConsumption = gammaRate * epsilonRate
        return powerConsumption
    }

    override func part2() -> Int {
        var oxygenGeneratorRating = -1
        var co2ScrubberRating = -1
        var diagnosticLength = self.inputLines[0].count
        var oxygenRemaining = self.inputLines.map { $0.map { $0 == "1" ? true : false }}
        var co2ScrubberRemaining = oxygenRemaining

        for index in 0..<diagnosticLength {
            if oxygenRemaining.count > 1 {
                let oxygenOn = oxygenRemaining.filter{$0[index]}.count
                let oxygenOff = oxygenRemaining.count - oxygenOn
                var searchValue = false
                if oxygenOn >= oxygenOff {
                    searchValue = true
                }
                oxygenRemaining = oxygenRemaining.filter{ $0[index] == searchValue }
                oxygenGeneratorRating = Int(oxygenRemaining[0].map { $0 ? "1" : "0"}.joined(), radix: 2)!
            }
            if co2ScrubberRemaining.count > 1 {
                let co2On = co2ScrubberRemaining.filter{$0[index]}.count
                let co2Off = co2ScrubberRemaining.count - co2On
                var searchValue = false
                if co2On < co2Off {
                    searchValue = true
                }
                co2ScrubberRemaining = co2ScrubberRemaining.filter{ $0[index] == searchValue }
                co2ScrubberRating = Int(co2ScrubberRemaining[0].map { $0 ? "1" : "0"}.joined(), radix: 2)!
            }
        }
        print(oxygenGeneratorRating, oxygenRemaining)
        print(co2ScrubberRating, co2ScrubberRemaining)
        return oxygenGeneratorRating * co2ScrubberRating
    }
}