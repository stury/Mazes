//
//  main.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/21/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

func image( for grid: Grid, name: String = "maze" ) {
    if let image = grid.image(cellSize: 20) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let documentURL = URL(string: "\(name).png", relativeTo: URL(fileURLWithPath: documentsPath)) {
            output(image, url: documentURL)
        }
    }
}

func maze(_ grid: Grid ) {
    print( grid )
}

func path(_ grid: DistanceGrid) {
    let start = grid[Point(row:0,col:0)]
    if let distances = start?.distances() {
        grid.distances = distances
        print( grid )
        if let southwestCell = grid[Point(row:grid.rows-1, col:0)] {
            grid.distances = distances.path(to: southwestCell)
            print( "Path from northwest corner to southwest corner" )
            print( grid )
        }
    }
    
}

func longestPath(_ grid: DistanceGrid) -> Int {
    var result : Int = 0
    
    let start = grid[Point(row:0,col:0)]
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

func coloredGrid(_ grid: ColoredGrid) {
    if let start = grid[Point(row:grid.rows/2,col:grid.columns/2)] {
        grid.distances = start.distances() 
    }
}

func distanceGrid() {
    let grid = DistanceGrid(rows: 20, columns: 20)
    // .binaryTree, .sidewinder
    let _ = Mazes.factory(.binaryTree, grid: grid)
    //maze(grid)
    //path(grid)
    let pathLength = longestPath(grid)
    print( "longest path length:  \(pathLength)" )
    
    image(for: grid, name: "maze" )
}

func generateMazes(_ maze: Mazes, max: Int, color:ColoredGridMode = .green) {
    for index in 1...max {
        let grid = ColoredGrid(rows: 20, columns: 20)
        grid.mode = color
        // .binaryTree, .sidewinder
        let _ = Mazes.factory(maze, grid: grid)
        print("\(grid.deadends().count) dead-ends in maze")
        coloredGrid(grid)
        image(for: grid, name: "\(maze.rawValue)_\(index)" )
    }
}

func deadends(_ tries:Int = 100) {
    let size = 20
    let algorithms:[Mazes] = Mazes.all()
    var averages:[Int] = [Int].init(repeating: 0, count: algorithms.count)
    
    for algorithm in algorithms {
        
        print("running \(algorithm.rawValue)")
        
        var deadendCounts = [Int]()
        for _ in 1...tries {
            let grid = Grid(rows: size, columns: size)
            let _ = Mazes.factory(algorithm, grid: grid)
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


//let grid = ColoredGrid(rows: 20, columns: 20)
//// .binaryTree, .sidewinder
//let generator = Mazes.factory(.wilsons, grid: grid)
//coloredGrid(grid)
//image(for: grid, name: "wilsons" )

//generateMazes(.huntAndKill, max: 6, color: .blue)
deadends()
