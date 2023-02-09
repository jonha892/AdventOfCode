//
//  Day2.swift
//  AOC2022
//
//  Created by... >.>
//  jonha892 on 1.12.22.
//

class Day2: Day {
    
    static var day: UInt8 { 2 }

    func part1() async throws -> String {
        
        let lines = Self.rawInput!.components(separatedBy: "\n")
        let result = try lines.reduce(0, {x, y in

            let parts = y.components(separatedBy: " ")
            
            let you: Choice = try parseChoice( parts[1] )
            let oponent: Choice = try parseChoice( parts[0] )

            let result = playRound(ownChoice: you, oponentChoice: oponent)
            let resultScore = scoreRound(choice: you, result: result)

            return x + Int(resultScore)
        })

        return "\(result)"
    }

    func part2() async throws -> String {
        let lines = Self.rawInput!.components(separatedBy: "\n")
        let result = try lines.reduce(0, {x, y in 

            let parts = y.components(separatedBy: " ")
            
            let outcome: RockPaperScissorsResult = try parseDesiredResult( parts[1] )
            let oponent = try parseChoice( parts[0] )

            let you = determineDesiredInput(oponentChoice: oponent, result: outcome)
            let result = playRound(ownChoice: you, oponentChoice: oponent)
            let resultScore = scoreRound(choice: you, result: result)
            
            return x + Int(resultScore)
        })

        return "\(result)"
    }

    func run() async throws -> (String, String) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }


    func parseChoice(_ input: String) throws -> Choice {
        switch(input) {
        case "A", "X": return .rock
        case "B", "Y": return .paper
        case "C", "Z": return .scissors
        default: throw RockPaperScissorError.invalidCharacter(input)
        }
    }

    func scoreRound(choice: Choice, result: RockPaperScissorsResult) -> UInt8 {
        return choice.score + result.score
    }

    func playRound(ownChoice p1: Choice, oponentChoice p2: Choice) -> RockPaperScissorsResult {
        switch (p1, p2) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper): return .win
            case (.rock, .rock), (.paper, .paper), (.scissors, .scissors): return .draw
            case (.rock, .paper), (.paper, .scissors), (.scissors, .rock): return .loss
        }
    }

    func parseDesiredResult(_ input: String) throws -> RockPaperScissorsResult {
        switch(input) {
        case"X": return .loss
        case"Y": return .draw
        case"Z": return .win
        default: throw RockPaperScissorError.invalidCharacter(input)
        }
    }

    func determineDesiredInput(oponentChoice choice: Choice, result: RockPaperScissorsResult) -> Choice {
        switch (choice, result) {
        case (.rock, .draw), (.paper, .loss), (.scissors, .win): return .rock
        case (.rock, .win), (.paper, .draw), (.scissors, .loss): return .paper
        case (.rock, .loss), (.paper, .win), (.scissors, .draw): return .scissors
        }
    }
}


enum Choice {
    case rock
    case paper
    case scissors
}

enum RockPaperScissorsResult {
    case win
    case draw
    case loss
}

enum RockPaperScissorError: Error {
    case invalidCharacter(String)
}

extension RockPaperScissorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCharacter(let invalidString): return "Cannot parse RockPaperScirros input for character \(invalidString)"             
        }
    }
}

protocol Scoreable {
    var score: UInt8 { get }
}

extension RockPaperScissorsResult: Scoreable {
    public var score: UInt8 {
        switch self {
        case .win: return 6
        case .draw: return 3
        case .loss: return 0
        }
    }
}
extension Choice: Scoreable {
    public var score: UInt8 {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }
}