//
//  Day.swift
//  test
//
//  Created by Dave DeLong on 12/22/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

public protocol Day {
    associatedtype Part1Result: CustomStringConvertible = String
    associatedtype Part2Result: CustomStringConvertible = String
    
    static var day: UInt8 { get }
    static var rawInput: String? { get }
    
    func part1() async throws -> Part1Result
    func part2() async throws -> Part2Result
    func run() async throws -> (Part1Result, Part2Result)
}

extension Day {
    public static var rawInput: String? { 
        let inputFilename = "input_\(String(format: "%02d", Self.day)).txt"
        
        //let inputFilePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("data").appendingPathComponent(inputFilename)
        //print("reading input \(inputFilePath.relativeString)")
        //return try! String(contentsOfFile: inputFilePath.absoluteString)
        
        return try! String(contentsOfFile: "data/\(inputFilename)")
    }
    
    public func part1() async throws -> Part1Result {
        fatalError("Implement \(#function)")
    }
    
    public func part2() async throws -> Part2Result {
        fatalError("Implement \(#function)")
    }
    
    public func run() async throws -> (Part1Result, Part2Result) {
        let p1 = try await part1()
        let p2 = try await part2()
        return (p1, p2)
    }
    
}