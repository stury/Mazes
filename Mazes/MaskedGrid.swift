//
//  MaskedGrid.swift
//  Mazes
//
//  Created by J. Scott Tury on 8/8/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class MaskedGrid : Grid {
    let mask : Mask
    
    public override init(rows: Int, columns: Int) {
        self.mask = Mask(rows: rows, columns: columns)
        super.init(rows: rows, columns: columns)
    }
    
    override internal func prepareGrid() -> [[Cell]] {
        
        
        return super.prepareGrid()
    }
}
