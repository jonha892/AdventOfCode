import Foundation

class Day6: Day {
    var input: String

    required init(input: String) {
        self.input = input
    }

    func partOne() -> Int {
        let lines = input.components(separatedBy: "\n")
        let times = lines[0].components(separatedBy: ": ")[1].components(separatedBy: " ").filter { !$0.isEmpty }.map { Int($0)! }
        let records = lines[1].components(separatedBy: ": ")[1].components(separatedBy: " ").filter { !$0.isEmpty }.map { Double($0)! }

        print("times \(times)")
        print("records \(records)")

        var winnings: [Int] = []
        for (i, (time, record)) in zip(times, records).enumerated() {
            print("i: \(i), time: \(time), record: \(record)")
            let pf = Double(-1 * time)/2
            let x0 = -1 * pf + (pf * pf - record).squareRoot()
            let x1 = -1 * pf - (pf * pf - record).squareRoot()
            print("x0: \(x0), x1: \(x1)")


            let roundedX0 = x0.truncatingRemainder(dividingBy: 1.0) == 0.0 ? Int(x0 - 1) : Int(exactly: floor(x0))!
            let roundedX1 = x0.truncatingRemainder(dividingBy: 1.0) == 0.0 ? Int(x1 + 1) : Int(exactly: ceil(x1))!
            print("roundedX0: \(roundedX0), roundedX1: \(roundedX1)")

            let winning = roundedX0 - roundedX1 + 1
            winnings.append(winning)
        }

        let total = winnings.reduce(1, *)

        return total
    }

    func partTwo() -> Int {
        let lines = input.components(separatedBy: "\n")
        let timeStr = lines[0].components(separatedBy: ": ")[1].components(separatedBy: " ").filter { !$0.isEmpty }.joined()
        let recordStr = lines[1].components(separatedBy: ": ")[1].components(separatedBy: " ").filter { !$0.isEmpty }.joined()
        let time = Int(timeStr)!
        let record = Double(recordStr)!



        let pf = Double(-1 * time)/2
        let x0 = -1 * pf + (pf * pf - record).squareRoot()
        let x1 = -1 * pf - (pf * pf - record).squareRoot()
        print("x0: \(x0), x1: \(x1)")


        let roundedX0 = x0.truncatingRemainder(dividingBy: 1.0) == 0.0 ? Int(x0 - 1) : Int(exactly: floor(x0))!
        let roundedX1 = x0.truncatingRemainder(dividingBy: 1.0) == 0.0 ? Int(x1 + 1) : Int(exactly: ceil(x1))!
        print("roundedX0: \(roundedX0), roundedX1: \(roundedX1)")

        let winning = roundedX0 - roundedX1 + 1

        return winning
    }
}