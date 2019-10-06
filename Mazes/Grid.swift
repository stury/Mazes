import Foundation
import CoreGraphics

/// Extend String such that we can use multiplication operator to duplicate a String X times...
extension String {
    public static func *(left: String, right: Int) -> String {
        var result:String = ""
        for _ in 0..<right {
            result += left
        }
        return result
    }
}

public class Grid : CustomStringConvertible {
    
    public let rows, columns : Int
    var grid : [[Cell?]]
    public var renderer : ImageRenderer

    public init( rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        renderer = ImageRenderer((1.0, 1.0, 1.0, 0.0))
        self.grid = [[Cell?]]()
        self.grid = prepareGrid()
        
        configureCells()
    }
    
    internal func prepareGrid() -> [[Cell?]] {
        var result = [[Cell?]]()
        for row in 0..<rows {
            var rowArray = [Cell?]()
            for column in 0..<columns {
                rowArray.append(RectCell(row: row, column: column))
            }
            result.append(rowArray)
        }
        return result
    }
    
    internal func configureCells() {
        for row in 0..<rows {
            for col in 0..<columns {
                if let cell = grid[row][col] as? RectCell {
                    cell.north = self[(row-1,col)] as? RectCell
                    cell.south = self[(row+1,col)] as? RectCell
                    cell.east  = self[(row,col+1)] as? RectCell
                    cell.west  = self[(row,col-1)] as? RectCell
                }
            }
        }
    }
    
    public subscript(_ location: (Int,Int)) -> Cell? {
        get {
            var result : Cell? = nil
            if location.0 >= 0 && location.0 < rows &&
                location.1 >= 0 && location.1 < grid[location.0].count {
                result = grid[location.0][location.1]
            }
            return result
        }
        set (newValue) {
            if let newValue = newValue {
                if location.0 >= 0 && location.0 < rows &&
                    location.1 >= 0 && location.1 < grid[location.0].count {
                    grid[location.0][location.1] = newValue
                }
            }
        }
    }

    public func randomCell() -> Cell? {
        var result : Cell? = nil
        
        let row = random(rows)
        let cellsInRow = grid[row]
        let col = random(cellsInRow.count)
        result = cellsInRow[col]
        return result
    }

    public func size() -> Int {
        return rows * columns
    }
    
    public func eachRow(_ block: ([Cell?])->Void ) {
        for row in grid {
            block(row)
        }
    }
    
    // Return true from the block to tell us to stop iterating over the cells!
    public func eachCell(_ block: (Cell?)->Bool ) {
        var stop = false
        for row in grid {
            for col in row {
                stop = block(col)
                
                if stop {
                    break
                }
            }
            if stop {
                break
            }
        }
    }
    
    public var cells : [Cell?] {
        get {
            var result = [Cell?]()
            
            eachCell { (cell) -> Bool in
                result.append(cell)
                return false
            }
            //print( result )
            return result
        }
    }
    
    public func contentsOfCell(_ cell:Cell) -> String {
        return " "
    }
        
    /// Simple method for returning the size of the image we need to create for this maze.
    public func imageSize(_ cellSize: Int) -> CGSize {
        let imageWidth = cellSize * self.columns
        let imageHeight = cellSize * self.rows
        return CGSize(width: imageWidth+1, height: imageHeight+1)
    }
    
    public func image( cellSize: Int, strokeSize: Int = 2 ) -> Image? {
        let result : Image? = renderer.raster(size: imageSize(cellSize)) { (context) in
            Image.gridMaze(in:context, for: self, cellSize: cellSize, strokeSize: strokeSize)
        }
        return result
    }

    public func pdfImage( cellSize: Int, strokeSize: Int = 2 ) -> Data? {
        let result : Data? = renderer.data(mode: .pdf, size: imageSize(cellSize)) { (context) in
            Image.gridMaze(in:context, for: self, cellSize: cellSize, strokeSize: strokeSize)
        }
        return result
    }

    public func deadends() -> [Cell] {
        var result = [Cell]()
        
        eachCell { (cell) -> Bool in
            if let cell = cell {
                if cell.links.count == 1 {
                    result.append(cell)
                }
            }
            return false
        }
        
        return result
    }
    
    /// Turns your perfect maze into a raided maze.  This means that loops will be introduced
    /// at various dead ends such that there are multiple paths through the maze.
    public func braid(_ p:Double = 1.0) {
        let deadends = self.deadends().shuffled()
        for cell in deadends {
            // next if cell.links.count != 1 || rand() > p\
            next( cell.links.count != 1 || rand() > p ) { () in
                let neighbors = cell.neighbors().filter { !cell.linked($0) }
                var best = neighbors.filter { $0.links.count == 1 }
                if best.count == 0 {
                    best = neighbors
                }
                
                if best.count > 0 {
                    let neighbor = best.sample()
                    cell.link(cell: neighbor)
                }
            }
        }
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        var result = "+" + "---+" * columns + "\n"
        
        for row in grid {
            var top = "|"
            var bottom = "+"
            for cell in row {
                
                let corner = "+"

                if let cell = cell as? RectCell {
                    let contents = contentsOfCell(cell)
                    let body : String
                    
                    #if swift(>=3.2)
                    let length = contents.count
                    #else
                    let length = contents.characters.count
                    #endif
                    
                    switch( length ) {
                    case 1:
                        body = " \(contents) "
                    case 2:
                        body = " \(contents)"
                    default:
                        body = contents
                    }
                    
                    var eastBoundary : String = "|"
                    if let eastCell = cell.east, cell.linked(eastCell) {
                        eastBoundary = " "
                    }
                    top += body + eastBoundary
                    
                    var southBoundary : String = "---"
                    if let southCell = cell.south, cell.linked(southCell) {
                        southBoundary = "   "
                    }
                    bottom += southBoundary + corner
                }
                else {
                    let eastBoundary : String = "|"
                    let southBoundary : String = "---"
                    
                    let body : String = "XXX"
                    top += body + eastBoundary
                    bottom += southBoundary + corner
                }
            }
            result += top + "\n"
            result += bottom + "\n"
        }
        
        return result
    }
    
}
