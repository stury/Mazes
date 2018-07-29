//
//  MazeGenerator.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/25/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

enum Mazes : String {
    case binaryTree
    case sidewinder
    case aldousBroder
    case wilsons
    case huntAndKill
    case recursiveBacktracker
    
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
    
    static func all() -> [Mazes] {
        return [.binaryTree, .sidewinder, .aldousBroder, .wilsons, .huntAndKill, .recursiveBacktracker]
    }
}


public protocol MazeGenerator {
    // Create this method, and implement your maze generation algorithm!
    static func on( grid: Grid )
   
}
