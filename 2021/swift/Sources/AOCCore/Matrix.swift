public class Matrix<T: Hashable & Numeric>: CustomStringConvertible {
    public private(set) var data: Array<Array<T>>
    
    public var rowCount: Int { return data.count }
    public var colCount: Int { return data.first?.count ?? 0 }

    public init(data: [[T]]) {
        self.data = data
    }

    public func firstPosition(of element: T) -> Position2D? {
        for r in 0 ..< rowCount {
            for c in 0 ..< colCount {
                if self[r, c] == element { return Position2D(x: c, y: r) }
            }
        }
        return nil
    }



    public subscript(_ row: Int, _ col: Int) -> T {
        get { return data[row][col] }
        set { data[row][col] = newValue }
    }
    
    public subscript(_ coordinate: Position2D) -> T {
        get { return data[coordinate.y][coordinate.x] }
        set { data[coordinate.y][coordinate.x] = newValue }
    }
    
    public var description: String {
        // create and return a String that is how
        // you’d like a Store to look when printed
        return self.data.map{ $0.map{ "\($0)" }.joined(separator: "\t") }.joined(separator: "\n")
    }

    // Matrix is bingo if a row or column is crossed out => row/rol has the same element
    public func hasBingo(searchValue: T) -> Bool {
        // rows
        for rowIndex in 0 ..< self.rowCount {
            let selection = self.data[rowIndex]
            if selection.allSatisfy( { $0 == searchValue } ) {
                return true
            }
        }
        // columns
        for columnIndex in 0 ..< self.colCount {
            let selection = self.data.map { $0[columnIndex] }
            if selection.allSatisfy( { $0 == searchValue } ) {
                return true
            }
        }
        return false
    }

    public func replaceAll(_ element: T, with newElement: T) {
        for rowIndex in 0 ..< self.rowCount {
            for colIndex in 0 ..< self.colCount {
                if self[rowIndex, colIndex] == element {
                    self[rowIndex, colIndex] = newElement
                }
            }
        }
    }

    public func getAll() -> [T] {
        return Array(self.data.joined())
    }

    public func times(right: Vector<T>) throws -> Vector<T> {
        if self.colCount != right.dim {
            return Vector(data: [])
        }
        var result: [T] = []
        for row in self.data {
            let value = zip(row, right.data).map{ $0.0 * $0.1}.reduce(0, { r, c in r + c })
            result.append(value)
        }
        return Vector(data: result)
    }
}


enum MatrixError {
    case invalidMultiplication(Int, Int)
}

extension MatrixError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidMultiplication(let matDim, let vecDim): return "Cannot multiply matrix with \(matDim) columns and a vector of dim \(vecDim)"
        }
    }
}