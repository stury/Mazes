//
//  MazeGenerator.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/25/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

#if swift(>=4.2)
enum Mazes : String, CaseIterable {
    case binaryTree
    case sidewinder
    case aldousBroder
    case wilsons
    case huntAndKill
    case recursiveBacktracker
}
#else
enum Mazes : String {
    case binaryTree
    case sidewinder
    case aldousBroder
    case wilsons
    case huntAndKill
    case recursiveBacktracker
}
#endif

extension Mazes {
    static func factory(_ maze:Mazes, grid: Grid) {
        
        switch maze {
        case .binaryTree:
            BinaryTree.on(grid: grid)
        case .sidewinder:
            Sidewinder.on(grid: grid)
        case .aldousBroder:
            AldousBroder.on(grid: grid)
        case .wilsons:
            Wilsons.on(grid: grid)
        case .huntAndKill:
            HuntAndKill.on(grid: grid)
        case .recursiveBacktracker:
            RecursiveBacktracker.on(grid: grid)
//        default:
//            result = BinaryTree(grid: grid)
        }
    }
    
//static var allCases: Self.AllCases
#if swift(>=4.2)
#else
static var allCases : [Mazes]  {
        get {
            return [.binaryTree, .sidewinder, .aldousBroder, .wilsons, .huntAndKill, .recursiveBacktracker]
        }
    }
#endif

    static func deadends(_ tries:Int = 100) {
        let size = 20
        let algorithms:[Mazes] = Mazes.allCases
        var averages:[Int] = [Int].init(repeating: 0, count: algorithms.count)
        
        for algorithm in algorithms {
            
            print("running \(algorithm.rawValue)")
            
            var deadendCounts = [Int]()
            for _ in 1...tries {
                let grid = Grid(rows: size, columns: size)
                Mazes.factory(algorithm, grid: grid)
                deadendCounts.append(grid.deadends().count)
            }
            var totalDeadends = 0
            for count in deadendCounts {
                totalDeadends += count
            }
            if let index = algorithms.index(of: algorithm) {
                averages[index] = totalDeadends / deadendCounts.count
            }
        }
        
        let totalCells = size*size
        print("\nAverage dead-ends per \(size)*\(size) maze \(totalCells) cells:\n")
        
        let sortedAlgorithms = algorithms.sorted(by: { (lhs, rhs) -> Bool in
            var result = false
            if let lhsIndex = algorithms.index(of: lhs),
                let rhsIndex = algorithms.index(of: rhs) {
                result = averages[lhsIndex] > averages[rhsIndex]
            }
            return result
        })
        for algorithm in sortedAlgorithms {
            if let index = algorithms.index(of: algorithm) {
                let percentage = averages[index]*100/(size*size)
                print("\(algorithm.rawValue) : \(averages[index])/\(totalCells) (\(percentage)%)")
            }
        }
        
    }

}


public protocol MazeGenerator {
    // Create this method, and implement your maze generation algorithm!
    static func on( grid: Grid )
}
