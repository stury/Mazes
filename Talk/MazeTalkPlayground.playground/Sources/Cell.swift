import Foundation

public class Cell : Equatable, CustomStringConvertible, Hashable {
    
    public var hashValue: Int {
        return row.hashValue ^ column.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(row.hashValue)
        hasher.combine(column.hashValue)
    }
    
    public var description: String {
        return "Cell(\(row), \(column))"
    }
    
    public static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    public let row, column : Int
    public var links: [Cell]
    
    public init( row: Int, column: Int) {
        self.row = row
        self.column = column
        links = [Cell]()
    }
    
    public func link(cell: Cell, bidi: Bool = true) {
        links.append(cell)
        if bidi {
            cell.link(cell: self, bidi: false)
        }
    }
    
    public func unlink(cell: Cell, bidi: Bool = true) {
        links = links.filter {$0 != cell}
        if bidi {
            cell.unlink(cell: self, bidi: false)
        }
    }
    
    public func linked(_ cell: Cell) -> Bool {
        let result = links.contains(cell)
        return result
    }

    public func linked(_ cell: Cell?) -> Bool {
        var result = false
        if let cell = cell {
            result = linked(cell)
        }
        return result
    }
    
    public func neighbors() -> [Cell] {
        return [Cell]()
    }
    
    public func distances() -> Distances {
        let result = Distances(root: self)
        
        var frontier : [Cell] = [self]
        
        while frontier.count > 0 {
            var newFrontier = [Cell]()
        
            for cell in frontier {
                if let cellDistance=result[cell] {
                    for linked in cell.links {
                        if result[linked] == nil {
                            result[linked] = cellDistance+1
                            newFrontier.append(linked)
                        }
                    }
                }
            }
            
            frontier = newFrontier
        }
        
        return result
    }
}
