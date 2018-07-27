//
//  MazeGenerator.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/25/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

enum Mazes {
    case binaryTree
    case sidewinder
    case aldousBroder
    case wilsons
    
    static func factory(_ maze:Mazes, grid: Grid) -> MazeGenerator {
        var result : MazeGenerator
        switch maze {
        case .binaryTree:
            result = BinaryTree(grid: grid)
        case .sidewinder:
            result = Sidewinder(grid: grid)
        case .aldousBroder:
            result = AldousBroder(grid: grid)
        case .wilsons:
            result = Wilsons(grid: grid)
//        default:
//            result = BinaryTree(grid: grid)
        }
        return result
    }
}


public class MazeGenerator {
    
    // Override init, and implement your maze generation algorithm!
    public init( grid: Grid ){
    }
    
}
