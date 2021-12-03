public enum Command {
    case forward(UInt16)
    case down(UInt16)
    case up(UInt16)
}

public enum SubmarineError: Error {
    case invalidCommandParts([String])
    case momentumNotParsable(String)
    case directionNotParsable(String)
}

extension SubmarineError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCommandParts(let parts): return "Expected exactly two parts (direction, momentum). Received: \(parts)"
        case .momentumNotParsable(let value): return "Momentum value could not be parsed. Received: \(value)"
        case .directionNotParsable(let value): return "Direction value could not be parsed. Received: \(value)"
        }
    }
}

public struct Submarine {
    public private(set) var posY: Int = 0 
    public private(set) var depth: Int = 0
    public private(set) var aim: Int = 0

    public init() {}

    public static func parseCommand(_ commandString: String) throws -> Command {
        let parts = commandString.components(separatedBy: " ")
        guard parts.count == 2 else {
            throw SubmarineError.invalidCommandParts(parts)
        }
        let direction = parts[0]
        guard let momentum = UInt16(parts[1]) else {
            throw SubmarineError.momentumNotParsable(parts[1])
        }
        
        switch direction {
        case "forward":
            return .forward(momentum)
        case "down":
            return .down(momentum)
        case "up":
            return .up(momentum)
        default:
            throw SubmarineError.directionNotParsable(direction)
        }
    }

    mutating public func move(command: Command) {
        switch command {
        case .forward(let value):
            self.posY += Int(value)
        case .down(let value):
            self.depth += Int(value)
        case .up(let value):
            self.depth -= Int(value)
        }
    }

    mutating public func movePart2(command: Command) {
        switch command {
        case .forward(let value):
            self.posY += Int(value)
            self.depth += self.aim * Int(value)
        case .down(let value):
            self.aim += Int(value)
        case .up(let value):
            self.aim -= Int(value)
        }
    }
}