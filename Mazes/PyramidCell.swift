//
//  PyramidCell.swift
//  Mazes
//
//  Created by Scott Tury on 9/14/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

class PyramidCell : TriangleCell {
    override public var upright : Bool {
        get {
            return column.even
        }
    }
}
