public class Vector<T: Hashable & Numeric> {
    public let data: [T]
    public var dim: Int {
        get {
            return self.data.count
        }
    }

    public init(data: [T]) {
        self.data = data 
    }

    public var description: String {
        // create and return a String that is how
        // you’d like a Store to look when printed
        return "Vector\(self.data)"
    }
}