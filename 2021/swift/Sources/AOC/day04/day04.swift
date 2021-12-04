class Day4: Day{
    init() {
        // super.init(day: 4, test: true)
        super.init(day: 4)
    }

    override func part1() -> Int {
        let draws = self.inputLines[0].components(separatedBy: ",").map{ Int($0)! }
        print(draws)
        let chunks = self.inputLines.dropFirst(2).split(separator: "")
        let boards = chunks.map{ Matrix(data: $0.map{$0.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ").filter{ $0 != ""}.map{Int($0)!}}) }

        for draw in draws {
            for board in boards {
                if let p=board.firstPosition(of: draw) {
                    board[p] = -1
                }
                if board.hasBingo(searchValue: -1) {
                    board.replaceAll(-1, with: 0)
                    let sum = board.getAll().reduce(0, { r, e in r + e })
                    print(sum)
                    return sum * draw
                }
            }
        }
        return -1
    }

    override func part2() -> Int {
        let draws = self.inputLines[0].components(separatedBy: ",").map{ Int($0)! }
        print(draws)
        let chunks = self.inputLines.dropFirst(2).split(separator: "")
        let boards = chunks.map{ Matrix(data: $0.map{$0.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ").filter{ $0 != ""}.map{Int($0)!}}) }

        var solvedBoards = Set<Int>()
        for draw in draws {
            for (index, board) in boards.enumerated() {
                if solvedBoards.contains(index) {
                    continue
                }
                if let p=board.firstPosition(of: draw) {
                    board[p] = -1
                }
                if board.hasBingo(searchValue: -1) {
                    solvedBoards.insert(index)

                    if solvedBoards.count == boards.count {
                        board.replaceAll(-1, with: 0)
                        let sum = board.getAll().reduce(0, { r, e in r + e })
                        print(sum)
                        return sum * draw
                    }
                }
            }
        }
        return -1
    }
}