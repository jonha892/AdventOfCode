import Foundation

class Day3: Day {

    var program: String
    
    init(filename: String) throws {
        do {
          let program = try String(contentsOfFile: filename, encoding: .utf8)
          self.program = program
        } catch {
          print("Error reading file \(error)")
          throw error
        }
    }

    func part1() -> String {
        let pattern = #/mul\((\d+),(\d+)\)/#
        var results = [(Int, Int)]()
        
        do {            
            for match in self.program.matches(of: pattern) {
               // Full match
              //print("Match: \(match.0)")
              
              // Access capture groups
              let number1 = match.1
              let number2 = match.2
              //print("Numbers: \(number1) \(number2)")
              results.append((Int(number1)!, Int(number2)!) )
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }
        let sum = results.reduce(0) { $0 + $1.0 * $1.1 }
        return "\(sum)"
    }

    enum Instruction {
      case Do
      case Dont
    }

    func part2() -> String {
      let pattern = #/(mul\((\d+),(\d+)\))|(do\(\))|(don't\(\))/#
        var results = [(Int, Int)]()
        
        var instruction = Instruction.Do
        for match in self.program.matches(of: pattern) {
            // Full match
          //print("Match: \(match.0 ?? "nil"), \(match.1 ?? "nil"), \(match.2 ?? "nil"), \(match.3 ?? "nil"), \(match.4 ?? "nil")")

          // check if do match
          if match.0.starts(with: "don't") {
            print("don't")
            instruction = .Dont
          } else if match.0.starts(with: "do") {
            print("do")
            instruction = .Do
          } else {
            //print("number and command \(instruction)")
            if instruction == .Do {
              // Access capture groups
              //print(match.2, match.3)
              if let number1 = match.2, let number2 = match.3 {
                //print("Numbers: \(number1) \(number2)")
                results.append((Int(number1)!, Int(number2)!) )
              }
            }
          }
        }
        //print(results)
        let sum = results.reduce(0) { $0 + $1.0 * $1.1 }
        return "\(sum)"
    }
}