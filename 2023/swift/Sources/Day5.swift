enum SeedError: Error {
    case DevError
}

struct SeedRange: CustomStringConvertible, Equatable {
    let start : Int
    let length : Int
    var end: Int {
        return start + length - 1
    }

    var description: String {
        return "SeedRange(start: \(start), length: \(length))"
    }

    static func == (lhs: SeedRange, rhs: SeedRange) -> Bool {
        return lhs.start == rhs.start && lhs.length == rhs.length
    }

    static func seedOverlap(seed seedRange: SeedRange, mapping mappingRange: SeedRange) throws -> (SeedRange?, SeedRange?, SeedRange?) {
        // no overlap
        if mappingRange.start > seedRange.end || mappingRange.end < seedRange.start {
            return (nil, nil, nil)
        }

        // mappingRange is contained in seedRange
        if mappingRange.start >= seedRange.start && mappingRange.end <= seedRange.end {
            let remainingLower = SeedRange(start: seedRange.start, length: mappingRange.start - seedRange.start)
            let remainingUpper = SeedRange(start: mappingRange.end + 1, length: seedRange.end - mappingRange.end)
            return (remainingLower, mappingRange, remainingUpper)
        }

        // mappingRange contains seedRange
        if mappingRange.start <= seedRange.start && mappingRange.end >= seedRange.end {
            return (nil, seedRange, nil)
        }

        // mappingRange is "left"
        if mappingRange.start < seedRange.start {
            let overlap = SeedRange(start: seedRange.start, length: mappingRange.end - seedRange.start + 1)
            let remaining = SeedRange(start: mappingRange.end + 1, length: seedRange.end - mappingRange.end)
            return (nil, overlap, remaining)
        }

        // mappingRange is "right"
        if mappingRange.start > seedRange.start {
            let overlap = SeedRange(start: mappingRange.start, length: seedRange.end - mappingRange.start + 1)
            let remaining = SeedRange(start: seedRange.start, length: mappingRange.start - seedRange.start)
            return (remaining, overlap, nil)
        }

        throw SeedError.DevError
    }
}

struct RangeMapping: CustomStringConvertible {
    let destStart : Int
    let mappingRange : SeedRange

    var description: String {
        return "RangeMapping(destStart: \(destStart), mappingRange: \(mappingRange))"
    }

    func mapValue(_ value: Int) -> Int? {
        if value < mappingRange.start {
            return nil
        }
        if value > mappingRange.end {
            return nil
        }
        let offset = value - mappingRange.start
        return destStart + offset
    }

    func mapRange(_ seedRange: SeedRange) -> (SeedRange?, SeedRange?, SeedRange?) {
        let (leftRemaining, overlap, rightRemaining) = try! SeedRange.seedOverlap(seed: seedRange, mapping: mappingRange)
        //print("seed Range: \(seedRange) mapping range: \(mappingRange) destStart: \(destStart)")
        //print("overlap: \(overlap), leftRemaining: \(leftRemaining), rightRemaining: \(rightRemaining)")
        if overlap == nil {
            return (nil, nil, nil)
        }

        let mappedStart = destStart + (overlap!.start - mappingRange.start)
        let mappedOverlapp = SeedRange(start: mappedStart, length: overlap!.length)

        return (leftRemaining, mappedOverlapp, rightRemaining)
    }
}

struct Transition {
    let rangeMappings: [RangeMapping]

    init(rangeMappings: [RangeMapping]) {
        self.rangeMappings = rangeMappings
    }

    func mapValue(_ value: Int) -> Int {
        for rangeMapping in rangeMappings {
            if let mappedValue = rangeMapping.mapValue(value) {
                return mappedValue
            }
        }
        return value
    }

    func mapRanges(_ seedRanges: [SeedRange]) -> [SeedRange] {
        var newSeedRanges: [SeedRange] = []
        for range in seedRanges {
            var currentSeedRange = range
            for (i, mapping) in rangeMappings.enumerated() {
                let overlapps = mapping.mapRange(currentSeedRange)
                //print("i: \(i) checking seed \(currentSeedRange) mapping \(mapping) => overlapps \(overlapps)")

                switch overlapps {
                case (nil, nil, nil):
                    break
                case (nil, let middle, nil):
                    newSeedRanges.append(middle!)
                    break
                case (let left, let middle, nil):
                    newSeedRanges.append(left!)
                    newSeedRanges.append(middle!)
                    break
                case (nil, let middle, let right):
                    newSeedRanges.append(middle!)
                    currentSeedRange = right!
                    break
                case (let left, let middle, let right):
                    newSeedRanges.append(left!)
                    newSeedRanges.append(middle!)
                    currentSeedRange = right!
                    break
                }
                //print("i: \(i) newSeedRanges: \(newSeedRanges)")
            }
        }
        if newSeedRanges.isEmpty {
            return seedRanges
        }
        return newSeedRanges
    }
}

class Day5: Day {
    var input: String
    var seeds: [Int] = []
    var transitions: [Transition] = []

    required init(input: String) {
        self.input = input

        let lines = input.split(separator: "\n")
        let seedParts = lines[0].split(separator: "seeds: ")
        let seeds = seedParts[0].components(separatedBy: .whitespaces).map { Int($0)! }
        self.seeds = seeds

        let transitions = input.components(separatedBy: "\n\n")[1...].map { (chunk: String) -> Transition in
            let lines = chunk.components(separatedBy: .newlines)
            let rangeMappings = lines[1...].map { (line: String) -> RangeMapping in
                let parts = line.components(separatedBy: .whitespaces)
                let destStart = Int(parts[0])!
                let sourceStart = Int(parts[1])!
                let length = Int(parts[2])!
                let startRange = SeedRange(start: sourceStart, length: length)
                return RangeMapping(destStart: destStart, mappingRange: startRange)
            }
            let sortedMappings = rangeMappings.sorted(by: { (a, b) in a.mappingRange.start < b.mappingRange.start })
            return Transition(rangeMappings: sortedMappings)
        }
        self.transitions = transitions
    }

    func partOne() -> Int {
        let destSeeds = [transitions.reduce(70, { (v, t) in t.mapValue(v) })]
        let minSeed = destSeeds.min()!
        return minSeed
    }

    func partTwo() -> Int {
        var seedRanges: [SeedRange] = []
        for i in stride(from: 0, to: seeds.count, by: 2) {
            let firstNumber = seeds[i]
            let secondNumber = seeds[i+1]
            let range = SeedRange(start: firstNumber, length: secondNumber)
            seedRanges.append(range)
        }

        var minDest = Int.max

        for seedRange in seedRanges[...] {
            var ranges = [seedRange]
            print("process seed range: \(seedRange)")

            for (i, transition) in transitions.enumerated() {
                ranges = transition.mapRanges(ranges)
                print("out ranges after transition \(i): \(ranges)")
            }

            let min = ranges.min(by: { (a, b) in a.start < b.start })!
            if min.start < minDest {
                minDest = min.start
            }
        }

        return minDest
    }
}