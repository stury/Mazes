import Foundation

public class BinaryTree : MazeGenerator {
    public static func on( grid: Grid ) {
        grid.eachCell { (cell) in
            var neighbors = [Cell]()
            if let cell = cell as? RectCell {
                if let north = cell.north {
                    neighbors.append( north )
                }
                if let east = cell.east {
                    neighbors.append( east )
                }
            }
            else if let cell = cell as? PolarCell {
                if let ccw = cell.ccw {
                    neighbors.append( ccw )
                }
                if let inward = cell.inward {
                    neighbors.append( inward )
                }
            }
            else if let cell = cell as? HexCell {
                if let north = cell.north {
                    neighbors.append( north )
                }
                if let southeast = cell.southeast {
                    neighbors.append( southeast )
                }
            }
            else {
                print("Unknown Cell sent to BinaryTree to process!")
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
