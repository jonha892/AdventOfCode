import Foundation

class Day2: Day {

    var reports = [[Int]]()
    
    init(filename: String) {
        // read file as lines, split the line by whitespace anc onvert it to tuples, split the tuples then into two lists
        var reports = [[Int]]()

        do {
          try String(contentsOfFile: filename, encoding: .utf8).enumerateLines { line, _ in
              let report = line.split(separator: " ", omittingEmptySubsequences: true).map { Int($0)! }
              reports.append(report)
          }
        } catch {
          print("Error reading file \(error)")
        }
        self.reports = reports
    }

    enum Direction {
        case increasing
        case decreasing
    }

    private func checkReport(report: [Int]) -> Bool {
        let first = report[0]
        let second = report[1]
        var direction: Direction

        if first > second {
          direction = .decreasing
        } else if first < second {
          direction = .increasing
        } else {
          return false
        }


        var previous = report[0]
        for i in 1..<report.count {
            let current = report[i]
            let diff = abs(current - previous)
            if diff == 0 || diff > 3 {
                return false
            }

            // wrong direction
            if current > previous {
                if direction == .decreasing {
                    return false
                }
            } else if current < previous {
                if direction == .increasing {
                    return false
                }
            }
            previous = current
        }

        return true
    }

    func part1() -> String {
        let validReports = reports.filter { checkReport(report: $0) }

        return "\(validReports.count)"
    }

    func part2() -> String {
        var validReports = 0
        for report in reports {
            if checkReport(report: report) {
                validReports += 1
            } else {
                // remove one element and check again
                for i in 0..<report.count {
                    var newReport = report
                    newReport.remove(at: i)
                    if checkReport(report: newReport) {
                        validReports += 1
                        break
                    }
                }
            }
        }

        return "\(validReports)"
    }
}