//
//  ColoredPyramidGrid.swift
//  Mazes
//
//  Created by Scott Tury on 9/14/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class ColoredPyramidGrid : PyramidGrid, ColoredGrid {
    var mode : ColoredGridMode = .green
    var maximum : Int = 0
    var distances : Distances? {
        didSet {
            if let distances = distances {
                (_, distance: maximum) = distances.max()
            }
        }
    }
}
