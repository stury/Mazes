//
//  main.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/21/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation


func image( for grid: Grid, name: String = "maze" ) {
    if let image = grid.image(cellSize: 40) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let documentURL = URL(string: "\(name).png", relativeTo: URL(fileURLWithPath: documentsPath)) {
            image.output(documentURL)
        }
    }
}

func maze(_ grid: Grid ) {
    print( grid )
}

func path(_ grid: DistanceGrid) {
    let start = grid[(0,0)]
    if let distances = start?.distances() {
        grid.distances = distances
        print( grid )
        if let southwestCell = grid[(grid.rows-1, 0)] {
            grid.distances = distances.path(to: southwestCell)
            print( "Path from northwest corner to southwest corner" )
            print( grid )
        }
    }
}

func longestPath(_ grid: DistanceGrid) -> Int {
    var result : Int = 0
    
    let start = grid[(0,0)]
    if let distances = start?.distances() {
        var newStart: Cell
        var distance : Int
        (cell:newStart, distance:distance) = distances.max()
        //print(distance)
        let newDistances = newStart.distances()
        let goal : Cell
        (cell:goal,distance:distance) = newDistances.max()
        //print(distance)
        result = distance
        
        grid.distances = newDistances.path(to: goal)
        print( grid )
    }
    return result
}

func distanceGrid() {
    let grid = DistanceGrid(rows: 20, columns: 20)
    // .binaryTree, .sidewinder
    Mazes.factory(.binaryTree, grid: grid)
    //maze(grid)
    //path(grid)
    let pathLength = longestPath(grid)
    print( "longest path length:  \(pathLength)" )
    
    image(for: grid, name: "maze" )
}


// MARK: - Masked Mazes

func killingCells_v1() {
    let grid = Grid(rows: 5, columns: 5)

    /// This function removes the north, south, east, and west cells from accessing the cell.
    func orphanCell( _ cell : Cell ) {
        if let cell = cell as? RectCell {
            if let east = cell.east {
                east.west = nil
            }
            cell.east  = nil
            if let west = cell.west {
                west.east = nil
            }
            cell.west  = nil
            
            if let south = cell.south {
                south.north = nil
            }
            cell.south = nil
            if let north = cell.north {
                north.south = nil
            }
            cell.north = nil
        }
    }
    
    if let nwCell = grid[(0, 0)] {
        orphanCell( nwCell )
    }
    if let seCell = grid[(4, 4)] {
        orphanCell( seCell )
    }
    RecursiveBacktracker.on(grid: grid, at: grid[(1, 1)])
    
    print( grid )
    image(for: grid, name: "killingCells" )
}

func killingCells_v2() {
    let mask = Mask(rows: 5, columns: 5)
    mask[(0,0)] = false
    mask[(2,2)] = false
    mask[(4,4)] = false
    
    let grid = MaskedGrid(mask)
    RecursiveBacktracker.on(grid: grid)
    
    print( grid )
    image(for: grid, name: "killingCells" )
}

/// This method works for Text and Image file data for the mask.
func killingCells(_ path: String, name: String = "killingCells") {
    let url = URL(fileURLWithPath: path)
    if let mask = Mask.from(url) {
        let grid = MaskedGrid.init(mask)
        RecursiveBacktracker.on(grid: grid)
        print( grid )
        image(for: grid, name: name )
    }
    else {
        print( "File \(url) did not exist!" )
    }
}

//killingCells("../../../../../Examples/MazeMask.txt", name: "killingCells")
//killingCells("../../../../../Examples/MazeMask.png", name: "killingCells2")
//killingCells("../../../../../Examples/Scott Maze.png")

func generateMazes(_ helpers:[MazeHelper]) {
    for mazeHelper in helpers {
        mazeHelper.generateGrid(20, name: "\(mazeHelper.imageNamePrefix)grid")
        mazeHelper.generateMaze(20, name: "\(mazeHelper.imageNamePrefix)maze")
        mazeHelper.generateMazes(mazeHelper.mazes, maxes: [6])
        mazeHelper.generateMazesSolutions(mazeHelper.mazes, maxes: [6])
    }
}


// Generate ALL Mazes!
// generateMazes(MazeGeneratorHelper.allHelpers)

// Now generate all of the mazes, and make the mazes braided!
let helpers = MazeHelper.allHelpers { (helper) in
    helper.braided = true
    helper.mazeSize = 20
}
generateMazes(helpers)

