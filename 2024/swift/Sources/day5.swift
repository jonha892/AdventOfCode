import Foundation

extension Array {
  func permutations() -> [[Element]] {
    guard count > 0 else { return [[]] }
    return indices.flatMap { i -> [[Element]] in
      var rest = self
      let element = rest.remove(at: i)
      return rest.permutations().map { [element] + $0 }
    }
  }
}

class Day5: Day {

  var rules: [String: Set<String>]  // set whiche items have to be before the key
  var rulesList: [(String, String)]
  var updates: [[String]]

  init(filename: String) throws {
    do {
      let parts = try String(contentsOfFile: filename, encoding: .utf8).components(
        separatedBy: "\n\n")
      let ruleList = parts[0].components(separatedBy: .newlines).map {
        $0.components(separatedBy: "|")
      }
      //self.rulesList = ruleList.map { (Int($0[0])!, Int($0[1])!) }
      self.rulesList = ruleList.map { ($0[0], $0[1]) }

      var rules = [String: Set<String>]()
      for rule in ruleList {
        let x = rule[0]
        let y = rule[1]

        if rules[y] == nil {
          rules[y] = Set([x])
        } else {
          rules[y]!.insert(x)
        }
      }
      self.rules = rules

      let updates = parts[1].components(separatedBy: .newlines).map {
        $0.components(separatedBy: ",")
      }
      self.updates = updates

    } catch {
      print("Error reading file \(error)")
      throw error
    }
  }

  func part1() -> String {
    var sum = 0

    for update in self.updates {
      var validUpdate = true
      for idy in stride(from: update.count - 1, through: 1, by: -1) {
        let y = update[idy]
        for idx in 0..<idy {
          let x = update[idx]
          if self.rules[x] != nil && self.rules[x]!.contains(y) {
            validUpdate = false
            break
          }
        }
        if !validUpdate {
          break
        }
      }

      if validUpdate {
        let middleElement = update[update.count / 2]
        sum += Int(middleElement)!
      }
    }

    return "\(sum)"
  }

  func repair(update: [String]) -> [String] {
    var repaired = false
    var tmpUpdate = update
    while !repaired {
      var atteptedRepair = false

      for idy in stride(from: update.count - 1, through: 1, by: -1) {
        let y = update[idy]
        for idx in 0..<idy {
          let x = update[idx]
          if self.rules[x] != nil && self.rules[x]!.contains(y) {
            // swap x and y in tmpUpdate
            tmpUpdate[idx] = y
            tmpUpdate[idy] = x
            atteptedRepair = true
            break
          }
        }
        if atteptedRepair {
          break
        }
      }

      if !atteptedRepair {
        repaired = true
      }
    }
    return tmpUpdate
  }

  func repair2(update: [String]) -> [String] {
    let permutations = update.permutations()
    var p = 1
    for permutation in permutations {

      print(p, "/", permutations.count)
      p += 1
      var valid = true
      for idy in stride(from: permutation.count - 1, through: 1, by: -1) {
        let y = permutation[idy]
        for idx in 0..<idy {
          let x = permutation[idx]
          if self.rules[x] != nil && self.rules[x]!.contains(y) {
            valid = false
            break
          }
        }
        if !valid {
          break
        }
      }

      if valid {
        return permutation
      }
    }
    return []
  }

  func topologicalSort(_ rules: [(Int, Int)]) -> [Int]? {
    // Step 1: Build the adjacency list and in-degree count
    var graph = [Int: [Int]]()
    var inDegree = [Int: Int]()

    for (from, to) in rules {
      graph[from, default: []].append(to)
      inDegree[to, default: 0] += 1
      inDegree[from, default: 0]  // Ensure every node is in the inDegree map
    }

    // Step 2: Find all nodes with no incoming edges (in-degree 0)
    var zeroInDegree = inDegree.filter { $0.value == 0 }.map { $0.key }

    // Step 3: Perform Kahn's Algorithm
    var sortedOrder = [Int]()

    while !zeroInDegree.isEmpty {
      let node = zeroInDegree.removeFirst()
      sortedOrder.append(node)

      // Remove the node and decrease the in-degree of its neighbors
      if let neighbors = graph[node] {
        for neighbor in neighbors {
          inDegree[neighbor, default: 0] -= 1
          if inDegree[neighbor] == 0 {
            zeroInDegree.append(neighbor)
          }
        }
      }
    }

    // Check if we processed all nodes (cycle detection)
    return sortedOrder.count == inDegree.count ? sortedOrder : nil
  }

  func part2() -> String {
    var sum = 0

    /*var ordering = topologicalSort(self.rulesList)
    if (ordering == nil) {
        print("no topological sort")
        return ""
    }*/

    for update in self.updates {
      var validUpdate = true
      for idy in stride(from: update.count - 1, through: 1, by: -1) {
        let y = update[idy]
        for idx in 0..<idy {
          let x = update[idx]
          if self.rules[x] != nil && self.rules[x]!.contains(y) {
            validUpdate = false
            break
          }
        }
        if !validUpdate {
          break
        }
      }

      if !validUpdate {
        print("inValid update: \(update)")
        var repairedUpdate = update

        /*
        var done = false
        while (!done) {
            var repairAttepmted = false
            for i in 1..<repairedUpdate.count {
                let y = repairedUpdate[i]
                for j in 0..<i {
                    let x = repairedUpdate[j]
                    if self.rules[x] != nil && self.rules[x]!.contains(y) {
                        // move x to the right of y
                        print("repairing: \(x) \(y) at \(j) \(i) due to rule \(self.rules[x]!)")
/*
                        if i+1 == repairedUpdate.count {
                            repairedUpdate.append(x)
                        } else {
                            repairedUpdate.insert(x, at: i+1)
                        }*/
                        repairedUpdate.insert(x, at: i+1)
                        repairedUpdate.remove(at: j)
                        repairAttepmted = true
                        //return ""
                        break
                    }
                }
                if repairAttepmted {
                    break
                }
            }
            if (!repairAttepmted) {
                done = true
            }
        }
        */

        let relevantRules = self.rulesList.filter {
          repairedUpdate.contains(String($0.0)) && repairedUpdate.contains(String($0.1))
        }
        print("relevantRules: \(relevantRules)")

        let hotRulesForEnd = { (end: String) in
          return relevantRules.filter { $0.1 == end }
        }

        var done = false
        while !done {
          var repairAttepmted = false
          for i in 0..<repairedUpdate.count - 1 {
            let y = repairedUpdate[i]
            let hotRules = hotRulesForEnd(y)
            if hotRules.count > 0 {
              let beforeElements = hotRules.map { String($0.0) }
              for j in i..<repairedUpdate.count {
                let x = repairedUpdate[j]
                if beforeElements.contains(x) {
                  // move x to the right of y
                  repairedUpdate.insert(x, at: i)
                  repairedUpdate.remove(at: j + 1)
                  repairAttepmted = true
                  break
                }
              }
            }
            if repairAttepmted {
              break
            }
          }
          if !repairAttepmted {
            done = true
          }
        }

        print("repairedUpdate: \(repairedUpdate)")

        let middleElement = repairedUpdate[repairedUpdate.count / 2]
        sum += Int(middleElement)!
      }
    }

    return "\(sum)"
  }
}
