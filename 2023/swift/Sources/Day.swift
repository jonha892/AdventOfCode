protocol Day {
  var input: String { get }

  init(input: String)

  func partOne() -> Int
  func partTwo() -> Int
}
