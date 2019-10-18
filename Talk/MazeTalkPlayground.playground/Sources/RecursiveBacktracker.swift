//
//  RecursiveBacktracker.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/29/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class RecursiveBacktracker : MazeGenerator {
    public static func on(grid: Grid) {
        RecursiveBacktracker.on( grid: grid, at: grid.randomCell() )
    }
    
    static func on( grid: Grid, at: Cell? ) {
        var stack = [Cell]()
        if let startCell = at {
            stack.append(startCell)
        }
        
        while stack.count > 0 {
            if let current = stack.last {
                let neighbors = current.neighbors().filter({ (cell) -> Bool in
                    cell.links.count == 0
                })
                
                if neighbors.count == 0 {
                    _ = stack.popLast()
                }
                else {
                    let neighbor = neighbors.sample()
                    current.link(cell: neighbor)
                    stack.append(neighbor)
                }
            }
        }
    }
}
