enum Card:Int, Comparable, CustomStringConvertible {
    case two = 1
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    case ace

    var description: String {
        switch self {
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "T"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        }
    }

    static func parse(_ input: Character) -> Card {
        switch input {
        case "2": return .two
        case "3": return .three
        case "4": return .four
        case "5": return .five
        case "6": return .six
        case "7": return .seven
        case "8": return .eight
        case "9": return .nine
        case "T": return .ten
        case "J": return .jack
        case "Q": return .queen
        case "K": return .king
        case "A": return .ace
        default: fatalError("Invalid card: \(input)")
        }
    }

    static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

enum Card2:Int, Comparable, CustomStringConvertible {
    case joker = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case queen
    case king
    case ace

    var description: String {
        switch self {
        case .joker: return "J"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "T"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        }
    }

    static func parse(_ input: Character) -> Card2 {
        switch input {
        case "J": return .joker
        case "2": return .two
        case "3": return .three
        case "4": return .four
        case "5": return .five
        case "6": return .six
        case "7": return .seven
        case "8": return .eight
        case "9": return .nine
        case "T": return .ten
        case "Q": return .queen
        case "K": return .king
        case "A": return .ace
        default: fatalError("Invalid card: \(input)")
        }
    }

    static func < (lhs: Card2, rhs: Card2) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

enum HandType:Int, Comparable, CustomStringConvertible {
    case highCard = 0
    case onePair
    case twoPair
    case threeOfAKind
    case fullHouse
    case fourOfAKind
    case fiveOfAKind

    var description: String {
        switch self {
        case .highCard: return "High Card"
        case .onePair: return "One Pair"
        case .twoPair: return "Two Pair"
        case .threeOfAKind: return "Three of a Kind"
        case .fullHouse: return "Full House"
        case .fourOfAKind: return "Four of a Kind"
        case .fiveOfAKind: return "Five of a Kind"
        }
    }

    static func parse(_ cards: [Card]) -> HandType {
        let counts = cards.reduce(into: [:]) { counts, card in counts[card, default: 0] += 1 }
        let sortedCounts = counts.sorted { $0.value > $1.value }
        for (_, count) in sortedCounts {
            if count == 5 {
                return .fiveOfAKind
            }
            if count == 4 {
                return .fourOfAKind
            }
            if count == 3 {
                if sortedCounts[1].value == 2 {
                    return .fullHouse
                }
                return .threeOfAKind
            }
            if count == 2 {
                if sortedCounts[1].value == 2 {
                    return .twoPair
                }
                return .onePair
            }
        }
        return .highCard
    }

    static func < (lhs: HandType, rhs: HandType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

enum HandError: Error {
    case DevError
}

enum HandType2:Int, Comparable, CustomStringConvertible {
    case highCard = 0
    case onePair
    case twoPair
    case threeOfAKind
    case fullHouse
    case fourOfAKind
    case fiveOfAKind

    var description: String {
        switch self {
        case .highCard: return "High Card"
        case .onePair: return "One Pair"
        case .twoPair: return "Two Pair"
        case .threeOfAKind: return "Three of a Kind"
        case .fullHouse: return "Full House"
        case .fourOfAKind: return "Four of a Kind"
        case .fiveOfAKind: return "Five of a Kind"
        }
    }

    static func parse(_ cards: [Card2]) throws -> HandType2 {
        let jokers = cards.filter { $0 == .joker }.count
        if jokers == 5 {
            return .fiveOfAKind
        }
        let counts = cards.reduce(into: [:]) { counts, card in counts[card, default: 0] += 1 }
        var sortedCounts = counts.sorted { $0.value > $1.value }
        
        let highestNonJokerIdx = sortedCounts.firstIndex(where: {
            (key, _) in
            return key != .joker
        })!
        var highestNonJoker = sortedCounts[highestNonJokerIdx]
        highestNonJoker.value += jokers
        sortedCounts.remove(at: highestNonJokerIdx)
        sortedCounts.insert(highestNonJoker, at: highestNonJokerIdx)

        let jokerIdx = sortedCounts.firstIndex(where: {
            (key, _) in
            return key == .joker
        })
        if let jokerIdx=jokerIdx {
            sortedCounts.remove(at: jokerIdx)
        }
        sortedCounts = sortedCounts.sorted(by: { $0.value > $1.value })
        //print(sortedCounts)

        switch sortedCounts[0].value {
        case 5: return .fiveOfAKind
        case 4: return .fourOfAKind
        case 3:
            if sortedCounts[1].value == 2 {
                return .fullHouse
            }
            return .threeOfAKind
        case 2:
            if sortedCounts[1].value == 2 {
                return .twoPair
            }
            return .onePair
        case 1:
            return .highCard
        default:
            throw HandError.DevError
        }
    }

    static func < (lhs: HandType2, rhs: HandType2) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}



struct Hand: Equatable, Comparable, CustomStringConvertible {
    let bid: Int
    let cards: [Card]
    let type: HandType

    var description: String {
        return "Hand(bid: \(bid), cards: \(cards), type: \(type))"
    }

    static func parse(_ input: String) -> Hand {
        let parts = input.components(separatedBy: " ")
        let cards = parts[0].map { (c: Character ) in let r = Card.parse(c); return r }
        let type = HandType.parse(cards)

        let bid = Int(parts[1])!

        return Hand(bid: bid, cards: cards, type: type)
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.type == rhs.type {
            for (l, r) in zip(lhs.cards, rhs.cards) {
                if l != r {
                    return l < r
                }
            }
        }
        return lhs.type < rhs.type
    }
}

struct Hand2: Equatable, Comparable, CustomStringConvertible {
    let bid: Int
    let cards: [Card2]
    let type: HandType2

    var description: String {
        return "Hand(bid: \(bid), cards: \(cards), type: \(type))"
    }

    static func parse(_ input: String) -> Hand2 {
        let parts = input.components(separatedBy: " ")
        let cards = parts[0].map { (c: Character ) in let r = Card2.parse(c); return r }
        let type = try! HandType2.parse(cards)

        let bid = Int(parts[1])!

        return Hand2(bid: bid, cards: cards, type: type)
    }

    static func < (lhs: Hand2, rhs: Hand2) -> Bool {
        if lhs.type == rhs.type {
            for (l, r) in zip(lhs.cards, rhs.cards) {
                if l != r {
                    return l < r
                }
            }
        }
        return lhs.type < rhs.type
    }
}


class Day7: Day {
    var input: String
    let hands: [Hand]
    let hands2: [Hand2]

    required init(input: String) {
        self.input = input

        let lines = input.components(separatedBy: "\n")
        let hands = lines.map { Hand.parse($0) }
        self.hands = hands

        let hands2 = lines.map { Hand2.parse($0) }
        self.hands2 = hands2
    }

    func partOne() -> Int {
        for hand in hands {
            print("\(hand)")
        }
        let sorted = hands.sorted()

        var sum = 0
        for (i, hand) in sorted.enumerated() {
            sum += hand.bid * (i + 1)
        }

        return sum
    }

    func partTwo() -> Int {
        let sorted = hands2.sorted()

        var sum = 0
        for (i, hand) in sorted.enumerated() {
            sum += hand.bid * (i + 1)
        }

        return sum
    }
}