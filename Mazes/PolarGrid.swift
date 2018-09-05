//
//  PolarGrid.swift
//  Mazes
//
//  Created by J. Scott Tury on 8/20/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation

public class PolarGrid : Grid {

    override public func image( cellSize: Int ) -> Image? {
        var result : Image? = nil
        
        let cgImage = Image.cgPolarImage(for: self, cellSize: cellSize)
        if let cgImage = cgImage {
            result = Image.init(cgImage: cgImage)
        }
        
        return result
    }
    
}
