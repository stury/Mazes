//
//  SettingsViewController.swift
//  Amaze
//
//  Created by Scott Tury on 9/23/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit
import MazeKit

protocol SettingsViewControllerDelegate {
    func updatedSettings( _ settings: MazeSettings )
}

class SettingsViewController : UIViewController {
    
    // @IBOutlet
    @IBOutlet var height : UISlider!
    @IBOutlet var width : UISlider!
    @IBOutlet var sizeLabel: UILabel!
    
    @IBOutlet var useColor : UISwitch!
    @IBOutlet var showSolution : UISwitch!
    @IBOutlet var colorPicker : UIPickerView!
    
    @IBOutlet var algorithmPicker : UIPickerView!
    
    let colorPickerDataSource : ColorPickerDataSource = ColorPickerDataSource()
    let algorithmPickerDataSource : AlgorithmPickerDataSource = AlgorithmPickerDataSource()
    
    var settings : MazeSettings?
    var delegate : SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the colorPicker!
        colorPicker.dataSource = colorPickerDataSource
        colorPicker.delegate = colorPickerDataSource
        
        // setup algorithmDataPicker
        algorithmPicker.dataSource = algorithmPickerDataSource
        algorithmPicker.delegate = algorithmPickerDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // setup all of the settings correctly.
        if let settings = settings {
            setup(with: settings)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // I know what the original settings were!  So compare them!
        let current = currentSettings()
        if current != settings {
            delegate?.updatedSettings(current)
        }
    }
    
    func sizeLabelText() -> String {
        var result = ""
        
        if settings?.supportColumns ?? true {
            result = "\(Int(height.value))x\(Int(width.value))"
        }
        else {
            result = "\(Int(height.value))"
        }
        return result
    }
    
    @IBAction func sliderChangedValue() {
        // Slider changed value, so update the text to display!
        if let sizeLabel = sizeLabel {
            sizeLabel.text = sizeLabelText()
        }
    }
    
    func currentSettings() -> MazeSettings {
        var result : MazeSettings = MazeSettings()
        
        if let height = height {
            result.rows = Int(height.value)
        }
        if let width = width {
            result.cols = Int(width.value)
        }
        if let useColor = useColor {
            result.useColor = useColor.isOn
        }
        if let showSolution = showSolution {
            result.showSolution = showSolution.isOn
        }
        result.color = selectedColor()
        result.algorithm = selectedAlgorithm()
        
        return result
    }
    
    func setup(with settings: MazeSettings) {
        // This method should set all of the data settings
        self.settings = settings
        
        if let height = height {
            height.setValue(Float(settings.rows), animated: true)
        }
        if let width = width {
            width.setValue(Float(settings.cols), animated: true)
            if settings.supportColumns == false {
                width.isEnabled = false
            }
        }
        if let sizeLabel = sizeLabel {
            sizeLabel.text = sizeLabelText()
        }
        if let useColor = useColor {
            useColor.isOn = settings.useColor
        }
        if let showSolution = showSolution {
            showSolution.isOn = settings.showSolution
        }
        selectColor(settings.color)
        selectAlgorithm(settings.algorithm)
    }
    
    func selectColor(_ color: String ) {
        if let colorPicker = colorPicker {
            
            let maxRows = colorPicker.numberOfRows(inComponent: 0)
            var row = 0
            var found = false
            while !found && row < maxRows {
                let foundString = colorPickerDataSource.pickerView(colorPicker, titleForRow: row, forComponent: 0)
                if foundString == color {
                    found = true
                    colorPicker.selectRow(row, inComponent: 0, animated: true)
                }
                row = row+1
            }
        }
    }
    
    func selectedColor( ) -> String {
        var result = ""
        
        if let colorPicker = colorPicker {
            let selectedRow = colorPicker.selectedRow(inComponent: 0)
            if let title = colorPickerDataSource.pickerView(colorPicker, titleForRow: selectedRow, forComponent: 0) {
                result = title
            }
        }
        
        return result
    }

    func selectAlgorithm(_ algorithm: String ) {
        if let algorithmPicker = algorithmPicker {
            
            let maxRows = algorithmPicker.numberOfRows(inComponent: 0)
            var row = 0
            var found = false
            while !found && row < maxRows {
                let foundString = algorithmPickerDataSource.pickerView(algorithmPicker, titleForRow: row, forComponent: 0)
                if foundString == algorithm {
                    found = true
                    algorithmPicker.selectRow(row, inComponent: 0, animated: true)
                }
                row = row+1
            }
        }
    }
    
    func selectedAlgorithm( ) -> String {
        var result = ""
        
        if let algorithmPicker = algorithmPicker {
            let selectedRow = algorithmPicker.selectedRow(inComponent: 0)
            if let title = algorithmPickerDataSource.pickerView(algorithmPicker, titleForRow: selectedRow, forComponent: 0) {
                result = title
            }
        }
        
        return result
    }

}

