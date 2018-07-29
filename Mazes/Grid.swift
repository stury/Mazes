import Foundation

// returns a value of 0 to maxInt.  So random(4) would return one of the following: 0, 1, 2, 3
public func random(_ maxInt: Int ) -> Int {
    var result : Int = 0
    
    result = Int(arc4random_uniform(UInt32(maxInt)))
    
    return result
}

// Extend String such that we can use multiplication operator to duplicate a String X times...
extension String {
    public static func *(left: String, right: Int) -> String {
        var result:String = ""
        for _ in 0..<right {
            result += left
        }
        return result
    }
}

public typealias Point = (row: Int, col: Int)

public class Grid : CustomStringConvertible {
    
    public let rows, columns : Int
    var grid : [[Cell]]
    
    public init( rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = [[Cell]]()
        self.grid = prepareGrid()
        
        configureCells()
    }
    
    private func prepareGrid() -> [[Cell]] {
        var result = [[Cell]]()
        for row in 0..<rows {
            var rowArray = [Cell]()
            for column in 0..<columns {
                rowArray.append(Cell(row: row, column: column))
            }
            result.append(rowArray)
        }
        return result
    }
    
    private func configureCells() {
        for row in 0..<rows {
            for col in 0..<columns {
                let cell = grid[row][col]
                
                //                if row > 0 {
                //                    cell.north = grid[row-1][col]
                //                }
                //                if row < rows-1 {
                //                    cell.south = grid[row+1][col]
                //                }
                //                if col > 0 {
                //                    cell.west  = grid[row][col-1]
                //                }
                //                if col < columns-1 {
                //                    cell.east  = grid[row][col+1]
                //                }
                cell.north = self[Point(row:row-1, col:col)]
                cell.south = self[Point(row:row+1, col:col)]
                cell.east  = self[Point(row:row, col:col+1)]
                cell.west  = self[Point(row:row, col:col-1)]
            }
        }
    }
    
    
    public subscript(point: Point) -> Cell? {
        get {
            var result : Cell? = nil
            if point.row >= 0 && point.row < rows &&
                point.col >= 0 && point.col < columns {
                result = grid[point.row][point.col]
            }
            return result
        }
        set (newValue) {
            if let newValue = newValue {
                if point.row >= 0 && point.row < rows &&
                    point.col >= 0 && point.col < columns {
                    grid[point.row][point.col] = newValue
                }
            }
        }
    }
    
    public func randomCell() -> Cell? {
        let row = random(rows)
        let col = random(columns)
        return self[Point(row, col)]
    }
    
    public func size() -> Int {
        return rows * columns
    }
    
    public func eachRow(_ block: ([Cell])->Void ) {
        for row in grid {
            block(row)
        }
    }
    
    // Return true from the block to tell us to stop iterating over the cells!
    public func eachCell(_ block: (Cell)->Bool ) {
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
    
    public var cells : [Cell] {
        get {
            var result = [Cell]()
            
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
    
    // MARK: - CustomStringConvertible
    public var description: String {
        var result = "+" + "---+" * columns + "\n"
        
        for row in grid {
            var top = "|"
            var bottom = "+"
            
            for cell in row {
                let contents = contentsOfCell(cell)
                let body : String
                switch( contents.characters.count ) {
                case 1:
                    body = " \(contents) "
                case 2:
                    body = " \(contents)"
                default:
                    body = contents
                }
                var east_boundary : String = "|"
                if let eastCell = cell.east, cell.linked(eastCell) {
                    east_boundary = " "
                }
                top += body + east_boundary
                
                var south_boundary : String = "---"
                if let southCell = cell.south, cell.linked(southCell) {
                    south_boundary = "   "
                }
                let corner = "+"
                bottom += south_boundary + corner
            }
            result += top + "\n"
            result += bottom + "\n"
        }
        
        return result
    }
    
    // protocol for Image callback to grid to see if we want to color the backgrounds.  Do we need this???
    public func background( ) -> Bool {
        return false
    }

    // protocol for Image callback to grid for the background color
    public func backgroundColor( for cell: Cell ) -> (CGFloat, CGFloat, CGFloat) {
        return (1.0, 1.0, 1.0)
    }
    
    public func image( cellSize: Int ) -> Image? {
        var result : Image? = nil
        
        let cgImage = Image.cgImage(for: self, cellSize: cellSize)
        if let cgImage = cgImage {
            result = Image.init(cgImage: cgImage)
        }
        
        return result
    }
    
    public func deadends() -> [Cell] {
        var result = [Cell]()
        
        eachCell { (cell) -> Bool in
            if cell.links.count == 1 {
                result.append(cell)
            }
            return false
        }
        
        return result
    }
}
