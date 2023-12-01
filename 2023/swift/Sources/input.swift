import Foundation

func parseInput(url: String) -> String {
  let fileURL = URL(fileURLWithPath: url)
  print(fileURL)
  let data = try! Data(contentsOf: fileURL)
  let input = String(data: data, encoding: .utf8)!
  return input
}
