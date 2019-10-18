//
//  HuntAndKill.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/27/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

//
//  AldousBroder.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/26/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class HuntAndKill : MazeGenerator {
    
    public static func on( grid: Grid ) {
        HuntAndKill.on( grid: grid, at: grid.randomCell() )
    }
    
    static func on( grid: Grid, at: Cell? ) {
        var current = at
        var neighbor : Cell?
        
        while current != nil {
            let unvisitedNeighbors = current?.neighbors().filter({ (cell) -> Bool in
                cell.links.count == 0
            })
            if let unvisitedNeighbors = unvisitedNeighbors, unvisitedNeighbors.count > 0 {
                neighbor = unvisitedNeighbors.sample()
                if let neighbor = neighbor {
                    current?.link(cell: neighbor)
                }
                current = neighbor
            }
            else {
                current = nil
            }

            grid.eachCell({ (cell) in
                var result = false
                if let visitedNeighbors = cell?.neighbors().filter({ (cell) -> Bool in
                    cell.links.count > 0
                }) {
                    
                    if cell?.links.count == 0 && visitedNeighbors.count > 0 {
                        current = cell
                        
                        let neighbor = visitedNeighbors.sample()
                        current?.link(cell: neighbor)
                        result = true
                    }
                }
                return result
            })
            
//            // Alternate implementation - doesn't seem to help!
//            let cells = grid.cells
//            for cell in cells {
//                let visitedNeighbors = cell.neighbors().filter({ (cell) -> Bool in
//                    cell.links.count > 0
//                })
//                if cell.links.count == 0 && visitedNeighbors.count > 0 {
//                    current = cell
//                    
//                    let neighbor = visitedNeighbors.sample()
//                    current?.link(cell: neighbor)
//                    break
//                }
//            }
        }
    }
}
