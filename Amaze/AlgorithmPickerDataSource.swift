//
//  AlgorithmPickerDataSource.swift
//  Amaze
//
//  Created by Scott Tury on 9/27/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit
import MazeKit

class AlgorithmPickerDataSource : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Mazes.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Mazes.allCases[row].rawValue
    }
    
}
