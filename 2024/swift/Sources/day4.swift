import Foundation

class Day4: Day {

  var puzzle: [String]
  var puzzleGrid = [[Character]]()

  init(filename: String) throws {
    do {
      let puzzle = try String(contentsOfFile: filename, encoding: .utf8).components(
        separatedBy: .newlines)
      self.puzzle = puzzle

      let grid = puzzle.map { Array($0) }
      self.puzzleGrid = grid
    } catch {
      print("Error reading file \(error)")
      throw error
    }
  }

  func handle_offsets(start: (Int, Int), offsets: ((Int, Int), (Int, Int), (Int, Int), (Int, Int))) -> (Bool ,(Int, Int)) {
    var part: [Character] = []
    for offset in [offsets.0, offsets.1, offsets.2, offsets.3] {
      let x = start.0 + offset.0
      let y = start.1 + offset.1
      if x < 0 || x >= self.puzzle[0].count || y < 0 || y >= self.puzzle.count {
        //print(x, y, x < 0, x >= self.puzzle[0].count, y < 0, y >= self.puzzle.count)
        return (false, (0, 0))
      }
      let line = self.puzzle[y]
      let index = line.index(line.startIndex, offsetBy: x)
      part.append(line[index])
    }
    let part_str = String(part)
    //print(part_str)
    if part_str == "XMAS" || part_str == "SAMX" {
      return (true, (start.0 + offsets.3.0, start.1 + offsets.3.1))
    }
    return (false, (0, 0))
  }

  func handle_x_marks_the_spot(at: (Int, Int)) -> Bool {
    let x = at.0
    let y = at.1

    let top_left = (x - 1, y - 1)
    let top_right = (x + 1, y - 1)
    let bottom_left = (x - 1, y + 1)
    let bottom_right = (x + 1, y + 1)

    if [top_left, top_right, bottom_left, bottom_right].contains(where: { $0.0 < 0 || $0.0 >= self.puzzle[0].count || $0.1 < 0 || $0.1 >= self.puzzle.count }) {
      return false
    }

    let middle_char = self.puzzleGrid[y][x]
    let top_left_char = self.puzzleGrid[top_left.1][top_left.0]
    let top_right_char = self.puzzleGrid[top_right.1][top_right.0]
    let bottom_left_char = self.puzzleGrid[bottom_left.1][bottom_left.0]
    let bottom_right_char = self.puzzleGrid[bottom_right.1][bottom_right.0]
    let env = [top_left_char, top_right_char, bottom_left_char, bottom_right_char]

    let diag1 = [top_left_char, middle_char, bottom_right_char]
    let diag2 = [top_right_char, middle_char, bottom_left_char]
    let diag1_cond = diag1 == ["M", "A", "S"] || diag1 == ["S", "A", "M"]
    let diag2_cond = diag2 == ["M", "A", "S"] || diag2 == ["S", "A", "M"]
    
    return diag1_cond && diag2_cond
  }

  func part1() -> String {
    var sum = 0

    let offsets = [
      ((0, 0), (0, -1), (0, -2), (0, -3)),
      ((0, 0), (1, -1), (2, -2), (3, -3)),
      ((0, 0), (1, 0), (2, 0), (3, 0)),
      ((0, 0), (1, 1), (2, 2), (3, 3)),
      ((0, 0), (0, 1), (0, 2), (0, 3)),
      ((0, 0), (-1, 1), (-2, 2), (-3, 3)),
      ((0, 0), (-1, 0), (-2, 0), (-3, 0)),
      ((0, 0), (-1, -1), (-2, -2), (-3, -3)),
    ]

    var paths: [((Int, Int), (Int, Int))] = []


    let width = self.puzzle[0].count
    for y in 0..<self.puzzle.count {
      for x in 0..<width {
        for offsets in offsets {
          let valid_combination = handle_offsets(start: (x, y), offsets: offsets)
          //print(x, y, offsets, valid_combination)
          if valid_combination.0 {
            if paths.contains(where: { $0.0 == valid_combination.1 && $0.1 == (x, y) }) {
              continue
            }
            paths.append(((x, y), valid_combination.1))
            sum += 1
          }
        }
      }
    }
    return "\(sum)"
  }

  func part2() -> String {
    var sum = 0

    let width = self.puzzle[0].count
    for y in 0..<self.puzzle.count {
      for x in 0..<width {
        let valid_combination = handle_x_marks_the_spot(at: (x, y))
        //print(x, y, offsets, valid_combination)
        if valid_combination {            
          sum += 1
        }
      }
    }
    return "\(sum)"
  }
}
