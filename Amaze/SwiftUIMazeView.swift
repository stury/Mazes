import SwiftUI

#if canImport(SwiftUI)
@available(iOS 13.0, *)
public struct SwiftUIMazeView: View {
    public let grid: Grid?
    public let cellSize: CGFloat
    public let strokeSize: CGFloat
    public let showColors: Bool
    public let colorMode: ColoredGridMode

    public init(grid: Grid?, cellSize: CGFloat = 40, strokeSize: CGFloat = 2, showColors: Bool = true, colorMode: ColoredGridMode = .green) {
        self.grid = grid
        self.cellSize = cellSize
        self.strokeSize = strokeSize
        self.showColors = showColors
        self.colorMode = colorMode
    }

    public var body: some View {
        Group {
            if let grid = grid {
                MazeGridBackgroundView(grid: grid, cellSize: cellSize, showColors: showColors, colorMode: colorMode)
                    .overlay(
                        MazeGridWallView(grid: grid, cellSize: cellSize, strokeSize: strokeSize)
                    )
            }
            else {
                Color.clear
            }
        }
    }
}

@available(iOS 13.0, *)
private struct MazeGridBackgroundView: View {
    let grid: Grid
    let cellSize: CGFloat
    let showColors: Bool
    let colorMode: ColoredGridMode

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<grid.rows, id: \ .self) { row in
                    ForEach(0..<grid.columns, id: \ .self) { column in
                        if let cell = grid[(row, column)] {
                            if let coloredGrid = grid as? ColoredGrid, showColors {
                                let color = coloredGrid.backgroundColor(for: cell)
                                let tint = Color(red: Double(color.0), green: Double(color.1), blue: Double(color.2), opacity: 1.0)
                                Rectangle()
                                    .fill(tint)
                                    .frame(width: cellSize, height: cellSize)
                                    .position(x: (CGFloat(column) * cellSize) + (cellSize / 2), y: (CGFloat(row) * cellSize) + (cellSize / 2))
                            }
                            else {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: cellSize, height: cellSize)
                                    .position(x: (CGFloat(column) * cellSize) + (cellSize / 2), y: (CGFloat(row) * cellSize) + (cellSize / 2))
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(width: CGFloat(grid.columns) * cellSize + 4, height: CGFloat(grid.rows) * cellSize + 4)
    }
}

@available(iOS 13.0, *)
private struct MazeGridWallView: View {
    let grid: Grid
    let cellSize: CGFloat
    let strokeSize: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for row in 0..<grid.rows {
                    for column in 0..<grid.columns {
                        guard let cell = grid[(row, column)] as? RectCell else { continue }

                        let x = CGFloat(column) * cellSize
                        let y = CGFloat(row) * cellSize
                        let x2 = x + cellSize
                        let y2 = y + cellSize

                        if cell.north == nil {
                            path.move(to: CGPoint(x: x, y: y))
                            path.addLine(to: CGPoint(x: x2, y: y))
                        }
                        if cell.west == nil {
                            path.move(to: CGPoint(x: x, y: y))
                            path.addLine(to: CGPoint(x: x, y: y2))
                        }
                        if let east = cell.east, !cell.linked(east) {
                            path.move(to: CGPoint(x: x2, y: y))
                            path.addLine(to: CGPoint(x: x2, y: y2))
                        }
                        if let south = cell.south, !cell.linked(south) {
                            path.move(to: CGPoint(x: x, y: y2))
                            path.addLine(to: CGPoint(x: x2, y: y2))
                        }
                    }
                }
            }
            .stroke(Color.black, lineWidth: strokeSize)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(width: CGFloat(grid.columns) * cellSize + 4, height: CGFloat(grid.rows) * cellSize + 4)
    }
}
#endif
