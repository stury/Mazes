//
//  MazeHelper.swift
//  Mazes
//
//  Created by Scott Tury on 9/17/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class MazeHelper {
    
    /// The size of the maze
    public var mazeSize: Int = 40
    /// the number of pixels to use for drawing the cell in the maze
    public var cellSize: Int = 40
    /// thickness of the stroke being used to generate the walls of the maze.
    public var strokeSize: Int = 2
    
    public var braided: Bool = false
    public var braidValue : Double = 0.5
    
    public var supportsColumns : Bool {
        get {
            return true
        }
    }
    
    public init() {
    }
    
    /// MARK: Overrideable methods
    public func getGrid( _ size: (Int, Int)) -> Grid {
        return Grid(rows: size.0, columns: size.1)
    }
    
    public func getGrid( _ size: Int) -> Grid {
        return getGrid((size, size))
    }
    
    public func getColoredGrid( _ size: Int) -> Grid {
        return getColoredGrid((size, size))
    }
    
    public func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredRectGrid(rows: size.0, columns: size.1)
    }
    
    public var imageNamePrefix : String   = ""
    public var braidedImagePrefix : String = "braided_"
    
    public func startCell( _ grid: Grid ) -> Cell? {
        return grid[(grid.rows/2,grid.columns/2)]
    }
    
    public var mazes:[Mazes] {
        get {
            return Mazes.allCases
        }
    }
    
    public func automaticNameGeneration(_ maze: Mazes ) -> String {
        var result = "\(imageNamePrefix)"
        if braided {
            result += "\(braidedImagePrefix)"
        }
        result += "\(maze.rawValue)"
        
        return result
    }
    
    /// MARK:
    
    public func image( for grid: Grid, name: String = "maze" ) {
        if let image = grid.image(cellSize: cellSize, strokeSize: strokeSize) {
            fileHelper?.export(fileType: "png", name: name, data: image.data())
        }
    }

    public func image( for grid: Grid ) -> Image? {
        var result : Image? = nil
        if let image = grid.image(cellSize: cellSize, strokeSize: strokeSize) {
            result = image
        }
        return result
    }

    /// Generated a quick grid, without any maze generation.
    public func generateGrid(_ size: Int, name: String  ) {
        let grid = getGrid(size)
        image( for: grid, name: name)
    }
    
    /// generates a quick maze using the specified Mazes algorithm specified.
    public func generateMaze(_ maze: Mazes, _ size: (Int, Int) ) -> Grid? {
        let grid = getColoredGrid(size)
        Mazes.factory(maze, grid: grid)

        if braided {
            grid.braid(braidValue)
        }

        var coloredGrid = grid as? ColoredGrid
        //        if coloredGrid != nil {
        //            coloredGrid?.mode = color[index%color.count]
        //        }
        
        if let startCell = startCell( grid ) {
            if coloredGrid != nil {
                coloredGrid?.distances = startCell.distances()
            }
        }
        
        return grid
    }

    /// generates a quick maze using the RecursizeBacktracker algorithm.
    public func generateMaze(_ size: Int ) -> Grid? {
        return generateMaze(.recursiveBacktracker, (size, size))
    }

    /// generates a quick maze using hte RecursizeBacktracker algorithm.
    public func generateMaze(_ size: Int ) -> Image? {
        var result : Image? = nil
        let grid = generateMaze(size) as Grid?
        if let grid = grid {
            result = image( for: grid)
        }
        return result
    }


    /// generates a quick maze using hte RecursizeBacktracker algorithm.
    public func generateMaze(_ size: Int, name: String ) {
        let grid = getGrid(size)
        RecursiveBacktracker.on(grid: grid)
        image( for: grid, name: name)
    }
    
    /// generate a series of mazes at once, using a particular maze algorithm.
    public func generateMazes(_ maze: Mazes, max: Int, color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for index in 1...max {
            let grid = getColoredGrid(mazeSize)
            var coloredGrid = grid as? ColoredGrid
            if coloredGrid != nil {
                coloredGrid?.mode = color[index%color.count]
            }
            // .binaryTree, .sidewinder
            Mazes.factory(maze, grid: grid)
            print("\(grid.deadends().count) dead-ends in maze")
            
            if braided {
                grid.braid(braidValue)
            }
            
            if let startCell = startCell( grid ) {
                if coloredGrid != nil {
                    coloredGrid?.distances = startCell.distances()
                }
            }
            let imageName = "\(automaticNameGeneration( maze ))_\(index)"
            image(for: grid, name: imageName )
        }
    }
    
    /// generate a series of mazes at once, using a multiple maze algorithms.
    public func generateMazes(_ mazes: [Mazes], maxes: [Int], color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for (mazeIndex, maze) in mazes.enumerated() {
            let max = maxes[mazeIndex%maxes.count]
            generateMazes(maze, max: max, color:color)
        }
    }
    
    public func longestPath(_ grid: Grid) -> Int {
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
            
            var coloredGrid = grid as? ColoredGrid
            coloredGrid?.distances = newDistances.path(to: goal)
            
            //            print( grid )
        }
        return result
    }
    
    public func generateMazesSolution(_ maze: Mazes, max: Int, color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for index in 1...max {
            let grid = getColoredGrid((mazeSize, mazeSize))
            var coloredGrid = grid as? ColoredGrid
            coloredGrid?.mode = color[index%color.count]
            Mazes.factory(maze, grid: grid)
            
            if braided {
                grid.braid(braidValue)
            }
            
            //print("\(grid.deadends().count) dead-ends in maze")
            coloredGrid?.maximum = longestPath(grid)
            let imageName = "solution_\(automaticNameGeneration( maze ))_\(index)"
            image(for: grid, name: imageName )
        }
    }
    
    /// generate a series of mazes at once, using a multiple maze algorithms.
    public func generateMazesSolutions(_ mazes: [Mazes], maxes: [Int], color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for (mazeIndex, maze) in mazes.enumerated() {
            let max = maxes[mazeIndex%maxes.count]
            generateMazesSolution(maze, max: max, color:color)
        }
    }
}

extension MazeHelper {
    /// Static variable where you can get all of the different MazeHelper classes as an array that you can iterate through.
    public static var allHelpers : [MazeHelper] {
        get {
            return [MazeHelper(), CircularMazeHelper(), HexagonalMazeHelper(), TriangularMazeHelper(), PyramidMazeHelper(), DiamondMazeHelper()]
        }
    }
    
    /// This accessor allows you to fetch all of the helpers, and configure them all in the same manner with a block initializer.
    /// You can use this for things like getting helpers to set the braiding of th ehelpers, so you can generate braided mazes, without
    /// having to manually walk though th elist yourself to set the values.
    public static func allHelpers(with blockInitializer:(MazeHelper)->Void ) -> [MazeHelper] {
        let  result = MazeHelper.allHelpers
        for helper in result {
            blockInitializer(helper)
        }
        return result
    }
}
