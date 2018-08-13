import Foundation

public extension Array {
    // To match Ruby's sample() method, we will implement a sample extension to Array in Swift.  This will allow us to choose a random item from the array.
    public func sample() -> Element {
        return self[random(self.count)]
    }
}

public class Sidewinder : MazeGenerator {

    public static func on( grid: Grid ) {
        grid.eachRow { (row) in
            var run = [Cell]()
            for cell in row {
                if let cell = cell {
                    run.append(cell)
                    
                    let atEasternBoundary = cell.east == nil
                    let atNorthernBoundary = cell.north == nil
                    let shouldCloseOut = atEasternBoundary || (!atNorthernBoundary&&random(2) == 0)
                    if shouldCloseOut {
                        let member = run.sample()
                        if let north = member.north {
                            member.link(cell: north)
                        }
                        run.removeAll()
                    }
                    else
                    {
                        if let east = cell.east {
                            cell.link(cell: east)
                        }
                    }
                }
            }
        }
    }
}
