//
//  RecursiveBacktracker.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/29/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class RecursiveBacktracker : MazeGenerator {
    static func on(grid: Grid) {
        var stack = [Cell]()
        if let startCell = grid.randomCell() {
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
