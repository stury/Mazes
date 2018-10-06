//
//  PickerDataSource.swift
//  Amaze
//
//  Created by Scott Tury on 10/5/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

/// This is a simple class to allow you to allocate this clss with a dataset of
/// [String] representing each different selectable item you'd like to be available.
/// It then deals with populating the PickerView with these values.  You then set the
/// UIPickerView's data source to this object, and you should have minimal work to do.
class SimplePickerDataSource<T> : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let data : [T]
    
    init(_ data: [T]) {
        self.data = data
        super.init()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var result : String = ""
        let value = data[row]
        if let value = value as? String {
            result = value
        }
        else if let value = value as? CustomStringConvertible {
            result = value.description
        }
        else {
            result = "unknown"
        }
        return result
    }
    
}

