//
//  ColoredHexGrid.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class ColoredHexGrid : HexGrid, ColoredGrid {
    public var mode : ColoredGridMode = .green
    public var maximum : Int = 0
    public var distances : Distances? {
        didSet {
            if let distances = distances {
                (_, distance: maximum) = distances.max()
            }
        }
    }
}
