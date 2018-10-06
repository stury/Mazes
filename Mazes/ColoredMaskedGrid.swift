//
//  ColoredMaskedGrid.swift
//  Mazes
//
//  Created by Scott Tury on 10/5/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

/// Siomple class to allow us to colorize the Masked mazes we've created.
public class ColoredMaskedGrid : MaskedGrid, ColoredGrid {
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
