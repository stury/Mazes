import Foundation

public class BinaryTree : MazeGenerator {
    public static func on( grid: Grid ) {
        grid.eachCell { (cell) in
            var neighbors = [Cell]()
            if let north = cell?.north {
                neighbors.append( north )
            }
            if let east = cell?.east {
                neighbors.append( east )
            }
            
            if neighbors.count > 0 {
                let index = random(neighbors.count)
                let neighbor = neighbors[index]
                cell?.link(cell: neighbor)
            }
            return false
        }
    }
}
