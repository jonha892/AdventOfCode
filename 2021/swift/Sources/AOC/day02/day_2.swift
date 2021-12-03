class Day2: Day{
    init() {
        super.init(day: 2)
    }

    override func part1() -> Int {
        var sub = Submarine()

        do {
            for commandString in self.inputLines {
                let command = try Submarine.parseCommand(commandString)
                sub.move(command: command)
            }
            print("Depth: \(sub.depth) posY \(sub.posY)")
            return sub.depth * sub.posY
        } catch {
            print("\(error.localizedDescription)")
            return -1
        }
    }

    override func part2() -> Int {
        var sub = Submarine()

        do {
            for commandString in self.inputLines {
                let command = try Submarine.parseCommand(commandString)
                sub.movePart2(command: command)
            }
            print("Depth: \(sub.depth) posY \(sub.posY)")
            return sub.depth * sub.posY
        } catch {
            print("\(error.localizedDescription)")
            return -1
        }
    }
}