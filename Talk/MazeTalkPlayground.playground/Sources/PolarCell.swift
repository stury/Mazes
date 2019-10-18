//
//  PolarCell.swift
//  Mazes
//
//  Created by Scott Tury on 9/4/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class PolarCell : Cell {
    
    var cw : PolarCell?
    var ccw : PolarCell?
    var inward : PolarCell?

    var outward : [PolarCell]
    
    public override init(row: Int, column: Int) {
        outward = []
        super.init(row: row, column: column)
    }
    
    public override func neighbors() -> [Cell] {
        var result : [Cell] = []
        
        if let cw = cw {
            result.append(cw)
        }
        if let ccw = ccw {
            result.append(ccw)
        }
        if let inward = inward {
            result.append(inward)
        }
        result.append(contentsOf: outward)
        
        return result
    }
}
