//
//  CGContextExtensions.swift
//  Mazes
//
//  Created by Scott Tury on 9/13/18.
//  Copyright © 2018 self. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGContext {
    
    /// Simple method for drawing a Polygon using abn array of (x, y) points.
    public func drawPolygon( points: [(Int, Int)], using: CGPathDrawingMode = .fillStroke ) {
        
        if points.count > 0 {
            for (index, point) in points.enumerated() {
                if index == 0 {
                    move(to: CGPoint(x:point.0, y:point.1))
                }
                else {
                    addLine(to: CGPoint(x:point.0, y:point.1))
                }
            }
            addLine(to: CGPoint(x:points[0].0, y:points[0].1))
            
            drawPath(using: using)
        }
    }
   
    /// Simple method for drawing a Polygon using abn array of (x, y) points.
    public func drawPolygon( points: [(CGFloat, CGFloat)], using: CGPathDrawingMode = .fillStroke ) {
        
        if points.count > 0 {
            for (index, point) in points.enumerated() {
                if index == 0 {
                    move(to: CGPoint(x:point.0, y:point.1))
                }
                else {
                    addLine(to: CGPoint(x:point.0, y:point.1))
                }
            }
            addLine(to: CGPoint(x:points[0].0, y:points[0].1))
            
            drawPath(using: using)
        }
    }

    
    /// Simple method to draw a line segment in the current context.
    public func drawLineSegment( points: [(Int, Int)] ) {
        
        if points.count == 2 {
            move(to: CGPoint(x:points[0].0, y:points[0].1))
            addLine(to: CGPoint(x:points[1].0, y:points[1].1))
            strokePath()
        }
    }

    /// Simple method to draw a line segment in the current context.
    public func drawLineSegment( points: [(CGFloat, CGFloat)] ) {
        
        if points.count == 2 {
            move(to: CGPoint(x:points[0].0, y:points[0].1))
            addLine(to: CGPoint(x:points[1].0, y:points[1].1))
            strokePath()
        }
    }

}
