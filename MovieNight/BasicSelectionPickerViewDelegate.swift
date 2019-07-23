//
//  BasicSelectionPickerViewDelegate.swift
//  MovieNight
//
//  Created by Bharath on 22/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol BasicSelectionPickerViewChangeResponder: class {
    func didSelectRow(_ row:Int, inComponent component: Int)
}


class BasicSelectionPickerViewDelegate: NSObject, UIPickerViewDelegate {
    
    var data: [pickerViewComponent: [String]]
    weak var changeResponderDelegate: BasicSelectionPickerViewChangeResponder? = nil
    
    
    init(withData data: [pickerViewComponent: [String]], changeResponderDelegate delegate: BasicSelectionPickerViewChangeResponder?) {
        
        self.data = data
        changeResponderDelegate = delegate
    }
    
    
    func update(withData data: [pickerViewComponent: [String]]) {
        self.data = data
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return data[component]?[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.changeResponderDelegate?.didSelectRow(row, inComponent: component)
        
    }

    
    
    deinit {
        changeResponderDelegate = nil
    }
    
}
