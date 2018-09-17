//
//  main.swift
//  Mazes
//
//  Created by J. Scott Tury on 7/21/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class MazeGeneratorHelper {

    /// The size of the maze
    public var mazeSize: Int = 40
    // the number of pixels to use for drawing the cell in the maze
    public var cellSize: Int = 40
    
    public var braided: Bool = false
    
    /// MARK: Overrideable methods
    func getGrid( _ size: (Int, Int)) -> Grid {
        return Grid(rows: size.0, columns: size.1)
    }

    func getGrid( _ size: Int) -> Grid {
        return getGrid((size, size))
    }
    
    func getColoredGrid( _ size: Int) -> Grid {
        return getColoredGrid((size, size))
    }
    
    func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredRectGrid(rows: size.0, columns: size.1)
    }
    
    public var imageNamePrefix : String   = ""
    public var braidedImagePrefix : String = "braided_"
    
    func startCell( _ grid: Grid ) -> Cell? {
        return grid[(grid.rows/2,grid.columns/2)]
    }
    
    var mazes:[Mazes] {
        get {
            return Mazes.allCases
        }
    }

    /// MARK:
    
    func image( for grid: Grid, name: String = "maze" ) {
        if let image = grid.image(cellSize: cellSize) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            if let documentURL = URL(string: "\(name).png", relativeTo: URL(fileURLWithPath: documentsPath)) {
                image.output(documentURL)
            }
        }
    }

    /// Generated a quick grid, without any maze generation.
    func generateGrid(_ size: Int, name: String  ) {
        let grid = getGrid(size)
        image( for: grid, name: name)
    }
    
    /// generates a quick maze using hte RecursizeBacktracker algorithm.
    func generateMaze(_ size: Int, name: String ) {
        let grid = getGrid(size)
        RecursiveBacktracker.on(grid: grid)
        image( for: grid, name: name)
    }
    
    /// generate a series of mazes at once, using a particular maze algorithm.
    func generateMazes(_ maze: Mazes, max: Int, color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for index in 1...max {
            let grid = getColoredGrid(mazeSize)
            var coloredGrid = grid as? ColoredGrid
            if coloredGrid != nil {
                coloredGrid?.mode = color[index%color.count]
            }
            // .binaryTree, .sidewinder
            Mazes.factory(maze, grid: grid)
            print("\(grid.deadends().count) dead-ends in maze")
            
            var imageName = "\(imageNamePrefix)"
            if braided {
                grid.braid()
                imageName += "\(braidedImagePrefix)"
            }
            imageName += "\(maze.rawValue)_\(index)"
            
            if let startCell = startCell( grid ) {
                if coloredGrid != nil {
                    coloredGrid?.distances = startCell.distances()
                }
            }
            image(for: grid, name: imageName )
        }
    }
    
    /// generate a series of mazes at once, using a multiple maze algorithms.
    func generateMazes(_ mazes: [Mazes], maxes: [Int], color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for (mazeIndex, maze) in mazes.enumerated() {
            let max = maxes[mazeIndex%maxes.count]
            generateMazes(maze, max: max, color:color)
        }
    }
    
    func longestPath(_ grid: Grid) -> Int {
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

    
    func generateMazesSolution(_ maze: Mazes, max: Int, color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for index in 1...max {
            let grid = getColoredGrid((mazeSize, mazeSize))
            var coloredGrid = grid as? ColoredGrid
            coloredGrid?.mode = color[index%color.count]
            Mazes.factory(maze, grid: grid)
            
            var imageName = "solution_\(imageNamePrefix)"
            if braided {
                grid.braid()
                imageName += "\(braidedImagePrefix)"
            }
            imageName += "\(maze.rawValue)_\(index)"

            //print("\(grid.deadends().count) dead-ends in maze")
            coloredGrid?.maximum = longestPath(grid)
            image(for: grid, name: imageName )
        }
    }

    /// generate a series of mazes at once, using a multiple maze algorithms.
    func generateMazesSolutions(_ mazes: [Mazes], maxes: [Int], color:[ColoredGridMode] = ColoredGridMode.allCases) {
        for (mazeIndex, maze) in mazes.enumerated() {
            let max = maxes[mazeIndex%maxes.count]
            generateMazesSolution(maze, max: max, color:color)
        }
    }
}

class CircularMazeHelper : MazeGeneratorHelper {
    
    override init() {
        super.init()
        imageNamePrefix = "circular_"
    }
    
    override func getGrid( _ size: (Int, Int)) -> Grid {
        return PolarGrid(size.0)
    }
    
    override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredPolarGrid(size.0)
    }
    
    override func startCell( _ grid: Grid ) -> Cell? {
        return grid[(0,0)]
    }

    override var mazes:[Mazes] {
        get {
            var mazes = Mazes.agnosticMazes
            // .aldousBroder mazes don't seem to work for circular mazes...
            if let index = mazes.index(of: .aldousBroder) {
                mazes.remove(at: index)
            }
            return mazes
        }
    }

}

class HexagonalMazeHelper : MazeGeneratorHelper {
    
    override init() {
        super.init()
        imageNamePrefix = "hex_"
    }

    override func getGrid( _ size: (Int, Int)) -> Grid {
        return HexGrid(rows: size.0, columns: size.1)
    }
    
    override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredHexGrid(rows: size.0, columns: size.1)
    }
    
    override var mazes:[Mazes] {
        get {
            return Mazes.agnosticMazes
        }
    }

}

class TriangularMazeHelper : MazeGeneratorHelper {

    override init() {
        super.init()
        imageNamePrefix = "triangle_"
    }

    override func getGrid( _ size: (Int, Int)) -> Grid {
        return TriangleGrid(rows: size.0, columns: size.1)
    }
    
    override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredTriangleGrid(rows: size.0, columns: size.1)
    }
    
    override var mazes:[Mazes] {
        get {
            var mazes = Mazes.agnosticMazes
            if let index = mazes.index(of: .binaryTree) {
                mazes.remove(at: index)
            }
            return mazes
        }
    }
}

class PyramidMazeHelper : MazeGeneratorHelper {
    
    override init() {
        super.init()
        imageNamePrefix = "pyramid_"
    }

    override func getGrid( _ size: (Int, Int)) -> Grid {
        return PyramidGrid(rows: size.0, columns: size.1)
    }
    
    override func getColoredGrid( _ size: (Int, Int)) -> Grid {
        return ColoredPyramidGrid(rows: size.0, columns: size.1)
    }
    
    override func startCell( _ grid: Grid ) -> Cell? {
        // For a pyramid, this should be the middle of the pyramid.  rows/2. col = rows
        let row = grid.rows/2
        let cells = grid.grid[row]
        let col = cells.count/2
        return grid[(row,col)]
    }

    override var mazes:[Mazes] {
        get {
            var mazes = Mazes.agnosticMazes
            if let index = mazes.index(of: .binaryTree) {
                mazes.remove(at: index)
            }
            return mazes
        }
    }
}

extension MazeGeneratorHelper {
    /// Static variable where you can get all of the different MazeHelper classes as an array that you can iterate through.
    static var allHelpers : [MazeGeneratorHelper] {
        get {
            return [MazeGeneratorHelper(), CircularMazeHelper(), HexagonalMazeHelper(), TriangularMazeHelper(), PyramidMazeHelper()]
        }
    }
    
    /// This accessor allows you to fetch all of the helpers, and configure them all in the same manner with a block initializer.
    /// You can use this for things like getting helpers to set the braiding of th ehelpers, so you can generate braided mazes, without
    /// having to manually walk though th elist yourself to set the values.
    static func allHelpers(with blockInitializer:(MazeGeneratorHelper)->Void ) -> [MazeGeneratorHelper] {
        let  result = MazeGeneratorHelper.allHelpers
        for helper in result {
            blockInitializer(helper)
        }
        return result
    }
}

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

func generateMazes(_ helpers:[MazeGeneratorHelper]) {
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
let helpers = MazeGeneratorHelper.allHelpers { (helper) in
    helper.braided = true
    helper.mazeSize = 20
}
generateMazes(helpers)

