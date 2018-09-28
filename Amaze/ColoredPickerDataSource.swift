//
//  ColoredPickerDataSource.swift
//  Amaze
//
//  Created by Scott Tury on 9/25/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit
import MazeKit

//class PickerDataSource<T : CaseIterable> : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return T.allCases.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let values = T.allCases.map { (item) -> T in
//            return "\(item)"
//        }
//        return values.item[row].rawValue
//    }
//
//}
//
//class ColorPickerDataSource : PickerDataSource<ColoredGridMode> {
//}
//
//class MazeAlgorithmPickerDataSource : PickerDataSource<Mazes> {
//}
//
//


class ColorPickerDataSource : NSObject, UIPickerViewDataSource, UIPickerViewDelegate { // PickerDataSource<ColoredGridMode> {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ColoredGridMode.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ColoredGridMode.allCases[row].rawValue
    }

}

