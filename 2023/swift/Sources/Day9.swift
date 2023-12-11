typealias History = [Int]
typealias Sequence = [Int]

class Day9: Day {
  var input: String
  var histories: [History] = []

  required init(input: String) {
    self.input = input

    self.histories = input.components(separatedBy: "\n").map {
      return $0.components(separatedBy: " ").map {
        return Int($0)!
      }
    }
  }

  private func findChange(sequence: [Int]) -> [Int] {
    var changes: [Int] = []
    for i in 0..<sequence.count - 1 {
      let change = sequence[i + 1] - sequence[i]
      changes.append(change)
    }
    return changes
  }

  private func findCompleteChangeHistory(history: History) -> [[Int]] {
    var changes: [[Int]] = []

    var currentSequence = history
    repeat {
      let change = findChange(sequence: currentSequence)
      currentSequence = change
      changes.append(change)

      if change.allSatisfy({ $0 == 0 }) {
        break
      }
    } while true
    return changes
  }

  private func extrapolateHistoryForward(history: History) -> (History, changes: [[Int]]) {
    var changeHistory = findCompleteChangeHistory(history: history)
    changeHistory[changeHistory.endIndex - 1].append(0)

    for i in (0..<changeHistory.count - 1).reversed() {
      let a = changeHistory[i][changeHistory[i].endIndex - 1]
      let b = changeHistory[i + 1][changeHistory[i + 1].endIndex - 1]
      let v = a + b
      changeHistory[i].append(v)
    }
    let newMeasurement =
      changeHistory[0][changeHistory[0].endIndex - 1] + history[history.endIndex - 1]

    let newHistory = history + [newMeasurement]
    return (newHistory, changeHistory)
  }

  private func extrapolateHistoryBackward(history: History) -> (History, changes: [[Int]]) {
    var changeHistory = findCompleteChangeHistory(history: history)
    changeHistory[changeHistory.endIndex - 1].insert(0, at: 0)

    for i in (0..<changeHistory.count - 1).reversed() {
      let a = changeHistory[i][0]
      let b = changeHistory[i + 1][0]
      let v = a - b
      changeHistory[i].insert(v, at: 0)
    }
    let newMeasurement = history[0] - changeHistory[0][0]

    let newHistory = [newMeasurement] + history
    return (newHistory, changeHistory)
  }

  func partOne() -> Int {
    print("test")

    var sum = 0
    for history in histories {
      let (newHistory, _) = extrapolateHistoryForward(history: history)
      print("newHistory: \(newHistory)")
      sum += newHistory[newHistory.endIndex - 1]
    }

    return sum
  }

  func partTwo() -> Int {
    var sum = 0
    for history in histories {
      let (newHistory, _) = extrapolateHistoryBackward(history: history)
      print("newHistory: \(newHistory)")
      sum += newHistory[0]
    }
    return sum
  }
}
