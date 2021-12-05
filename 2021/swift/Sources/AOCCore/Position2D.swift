enum Position2DError: Error {
    case invalidArgumentError(String, String, [String])
    case numberNotParsableError(String)
    case invalidInputError(Position2D, Position2D)
}

extension Position2DError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidArgumentError(let str, let separatedBy, let components):
            return "String \"\(str)\" and separator \"\(separatedBy)\" resulted in more/less than two components \"\(components)\""
        case .numberNotParsableError(let str):
            return "String \"\(str)\" could not be parsed as an Int"
        case .invalidInputError(let p1, let p2):
            return "Could not perform operation for points \(p1) and \(p2)"
        }
    }
}

public struct Position2D: Hashable {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    public init(of str: String, separatedBy: String) throws {
        let components = str.components(separatedBy: separatedBy)
        guard components.count == 2 else {
            throw Position2DError.invalidArgumentError(str, separatedBy, components)
        }
        guard let x = Int(components[0]) else {
            throw Position2DError.numberNotParsableError(components[0])
        }
        guard let y = Int(components[1]) else {
            throw Position2DError.numberNotParsableError(components[1])
        }
        self.init(x: x, y: y)
    }

    public func positionsBetweenPart1(other: Position2D) -> [Position2D] {
        var result: [Position2D] = []
        // horizontal
        if self.y == other.y {
            let dx = other.x - self.x
            let s = dx > 0 ? 1 : -1
            for xOffset in stride(from: 0, through: dx, by: s) {
                result.append(Position2D(x: self.x + xOffset, y: self.y))
            }
        }
        // vertical
        else if self.x == other.x {
            let dy = other.y - self.y
            let s = dy > 0 ? 1 : -1
            for yOffset in stride(from: 0, through: dy, by: s) {
                result.append(Position2D(x: self.x, y: self.y + yOffset))
            }
        } else {
            return []
        }
        return result
    }
    public func positionsBetween(other: Position2D) throws -> [Position2D] {
        var result: [Position2D] = []
        // horizontal
        if self.y == other.y {
            let dx = other.x - self.x
            let s = dx > 0 ? 1 : -1
            for xOffset in stride(from: 0, through: dx, by: s) {
                result.append(Position2D(x: self.x + xOffset, y: self.y))
            }
        }
        // vertical
        else if self.x == other.x {
            let dy = other.y - self.y
            let s = dy > 0 ? 1 : -1
            for yOffset in stride(from: 0, through: dy, by: s) {
                result.append(Position2D(x: self.x, y: self.y + yOffset))
            }
        } else {
            let dx = other.x - self.x
            let dy = other.y - self.y
            if abs(dx) != abs(dy) {
                throw Position2DError.invalidInputError(self, other)
            }
            let sx = dx > 0 ? 1 : -1
            let sy = dy > 0 ? 1 : -1
            let xOffsets = stride(from: 0, through: dx, by: sx).map { $0} 
            let yOffsets = stride(from: 0, through: dy, by: sy).map { $0} 
            for (xOffset, yOffset) in zip(xOffsets, yOffsets) {
                result.append(Position2D(x: self.x + xOffset, y: self.y + yOffset))
            }
        }
        return result
    }
}