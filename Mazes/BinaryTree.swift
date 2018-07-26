import Foundation

public class BinaryTree : MazeGenerator {
    override public init( grid: Grid ){
        super.init(grid: grid)
        grid.eachCell { (cell) in
            var neighbors = [Cell]()
            if let north = cell.north {
                neighbors.append( north )
            }
            if let east = cell.east {
                neighbors.append( east )
            }
            
            if neighbors.count > 0 {
                let index = random(neighbors.count)
                let neighbor = neighbors[index]
                cell.link(cell: neighbor)
            }
        }
    }
}
