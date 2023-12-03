import Foundation

enum Color: String, CustomStringConvertible {
  case red
  case green
  case blue

  var description: String {
    return rawValue
  }

  static func fromString(_ str: String) -> Color? {
    switch str {
    case "red":
      return .red
    case "green":
      return .green
    case "blue":
      return .blue
    default:
      return nil
    }
  }
}

typealias CubeSet = (Color, Int)
typealias Revealing = [CubeSet]

struct Game: CustomStringConvertible {
  let id: Int
  let revealings: [Revealing]

  init(id: Int, revealings: [Revealing]) {
    self.id = id
    self.revealings = revealings
  }

  var description: String {
    return "Game \(id): \(revealings)"
  }
}

enum ParsingError: Error {
  case invalidInput
}

class Day2: Day {
  var input: String

  required init(input: String) {
    self.input = input
  }

  private func parseCubeSet(str: String) throws -> CubeSet {
    if let result = str.firstMatch(of: ##/(\d+)\s+(\w+)/##) {
      let amount = Int(result.1)!
      let colorStr = String(result.2)
      let color = Color.fromString(colorStr)

      guard let unwrappedColor = color else {
        throw ParsingError.invalidInput
      }
      return (unwrappedColor, amount)
    }
    throw ParsingError.invalidInput
  }

  private func parseGame(_ line: String) throws -> Game {
    let regex = ##/Game (\d+): /##

    if let result = line.firstMatch(of: regex) {
      let id = Int(result.1)!
      let remaining = line[result.range.upperBound...]

      let completeShowings = remaining.components(separatedBy: "; ")
      let revealings = try completeShowings.map { (showing: String) in
        let cubeSetStrings = showing.components(separatedBy: ", ")
        let result = try cubeSetStrings.map(parseCubeSet)
        return result
      }

      return Game(id: id, revealings: revealings)
    }

    return Game(id: 0, revealings: [])
  }

  func partOne() -> String {
    var games: [Game] = []
    do {
      games = try input.components(separatedBy: "\n").map(parseGame)
    } catch {
      print("invalid input")
      return ""
    }

    let max = [
      Color.red: 12,
      Color.green: 13,
      Color.blue: 14,
    ]

    let validGames = games.filter({ (game: Game) in
      for revealing in game.revealings {
        for (color, amount) in revealing {
          if amount > max[color]! {
            return false
          }
        }
      }
      return true
    })
    let validIds = validGames.map { $0.id }

    return "\(validIds.reduce(0, +))"
  }

  func partTwo() -> String {
    var games: [Game] = []
    do {
      games = try input.components(separatedBy: "\n").map(parseGame)
    } catch {
      print("invalid input")
      return ""
    }

    let powers = games.map({
      (game: Game) in
      var min = [
        Color.red: Int.min,
        Color.green: Int.min,
        Color.blue: Int.min,
      ]
      for revealing in game.revealings {
        for (color, amount) in revealing {
          if amount > min[color]! {
            min[color] = amount
          }
        }
      }
      return min[Color.red]! * min[Color.green]! * min[Color.blue]!
    })

    let power = powers.reduce(0, +)
    return "\(power)"
  }
}
