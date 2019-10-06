import Foundation
import CoreGraphics
#if os(iOS)
    import UIKit
#endif

extension CGColor {
    //  context?.setStrokeColor(CGColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>))
    
//    convenience init(_ rgbColor: (Double, Double, Double)) {
//        return CGColor(red: rgbColor.0, green: rgbColor.1, blue: rgbColor.2, alpha: 1.0))
//    }
    
    static public func from(_ rgbColor: (Double, Double, Double)) -> CGColor {
        #if os(macOS)
        return CGColor(red: CGFloat(rgbColor.0), green: CGFloat(rgbColor.1), blue: CGFloat(rgbColor.2), alpha: 1.0)
        #else
        let color = UIColor(red: CGFloat(rgbColor.0), green: CGFloat(rgbColor.1), blue: CGFloat(rgbColor.2), alpha: 1.0)
        return color.cgColor
        #endif
    }

}
