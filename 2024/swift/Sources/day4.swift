import Foundation

class Day4: Day {

  var puzzle: [String]

  init(filename: String) throws {
    do {
      let puzzle = try String(contentsOfFile: filename, encoding: .utf8).components(
        separatedBy: .newlines)
      self.puzzle = puzzle
    } catch {
      print("Error reading file \(error)")
      throw error
    }
  }

  func handle_offsets(start: (Int, Int), offsets: ((Int, Int), (Int, Int), (Int, Int), (Int, Int))) -> Bool {
    var part: [Character] = []
    for offset in [offsets.0, offsets.1, offsets.2, offsets.3] {
      let x = start.0 + offset.0
      let y = start.1 + offset.1
      if x < 0 || x >= self.puzzle[0].count || y < 0 || y >= self.puzzle.count {
        return false
      }
      let line = self.puzzle[y]
      let index = line.index(line.startIndex, offsetBy: x)
      part.append(line[index])
    }
    let part_str = String(part)
    print(part_str)
    if part_str == "XMAS" || part_str == "SAMX" {
      return true
    }
    return false
  }

  func part1() -> String {
    var sum = 0

    // horizontal
    /*
    for line in self.puzzle {
      for x in 0..<line.count - 3 {
        let start = line.index(line.startIndex, offsetBy: x)
        let end = line.index(line.startIndex, offsetBy: x + 3)
        let part = line[start..<end]
        if part == "XMAS" || part == "SAMX" {
          sum += 1
        }
      }
    }

    // vertical
    for y in 0..<self.puzzle.count {
      for x in 0..<self.puzzle[y].count {
        let start = self.puzzle[y].index(self.puzzle[y].startIndex, offsetBy: x)
        let end = self.puzzle[y].index(self.puzzle[y].startIndex, offsetBy: x + 3)
        let part = self.puzzle[y][start..<end]
        if part == "XMAS" || part == "SAMX" {
          sum += 1
        }
      }
    }
    */

    let offsets = [
      ((0, 0), (0, -1), (0, -2), (0, -3)),
      ((0, 0), (1, -1), (2, -2), (3, -3)),
      ((0, 0), (1, 0), (2, 0), (3, 0)),
      ((0, 0), (1, 1), (2, 2), (3, 3)),
      ((0, 0), (0, 1), (0, 2), (0, 3)),
      ((0, 0), (-1, 1), (-2, 2), (-3, 3)),
      ((0, 0), (-1, 0), (-2, 0), (-3, 0)),
      ((0, 0), (-1, -1), (-2, -2), (3, -3)),
    ]

    // diagonal left to right
    let width = self.puzzle[0].count
    for y in 0..<self.puzzle.count {
      for x in 0..<width {
        for offsets in offsets {
          let valid_combination = handle_offsets(start: (x, y), offsets: offsets)
          if valid_combination {
            sum += 1
          }
        }
      }
    }

    // diagonal right to left

    return "\(sum)"
  }

  func part2() -> String {
    let sum = 0
    return "\(sum)"
  }
}
