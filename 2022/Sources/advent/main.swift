//
//  File.swift
//  
//
//  Created by >.>
//  jonha892 on 30.11.22.
//
import AOC

let d: any Day = AOC2022.day(2)

let d1 = Date()
let (p1, p2) = try await d.run()
let d2 = Date()
print("Executing \(type(of: d))")
print("Part 1: \(p1)")
print("Part 2: \(p2)")
print("Time: \(d2.timeIntervalSince(d1))")