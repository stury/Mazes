//
//  ColoredHexGrid.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class ColoredHexGrid : HexGrid {
    var mode : ColoredGridMode = .green
    var maximum : Int = 0
    var distances : Distances? {
        didSet {
            if let distances = distances {
                (_, distance: maximum) = distances.max()
            }
        }
    }
    
    // protocol for Image callback to grid to see if we want to color the backgrounds.
    override public func background( ) -> Bool {
        return true
    }
    
    // protocol for Image callback to grid for the background color
    override public func backgroundColor( for cell: Cell ) -> (CGFloat, CGFloat, CGFloat) {
        var result = (CGFloat(1.0), CGFloat(1.0), CGFloat(1.0))
        if let distances = distances {
            if let distance = distances[cell] {
                let intensity = CGFloat(maximum - distance)/CGFloat(maximum)
                let dark = CGFloat(1.0 * intensity)
                let bright = CGFloat(0.5 + (0.5*intensity))
                switch mode {
                case .red:
                    result = (bright, dark, dark)
                case .green:
                    result = (dark, bright, dark)
                case .blue:
                    result = (dark, dark, bright)
                case .yellow:
                    result = (bright, bright, dark)
                case .cyan:
                    result = (dark, bright, bright)
                case .magenta:
                    result = (bright, dark, bright)
                case .gray:
                    result = (bright, bright, bright)
                }
            }
        }
        return result
    }
}
