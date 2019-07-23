//
//  SelectionPickerViewDataSource.swift
//  MovieNight
//
//  Created by Bharath on 22/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

typealias pickerViewComponent = Int
typealias pickerViewRowCount = Int


class SelectionPickerViewDataSource: NSObject, UIPickerViewDataSource {
    
    var data: [pickerViewComponent:pickerViewRowCount]
    
    
    init(withData data: [pickerViewComponent:pickerViewRowCount]) {
        self.data = data
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.keys.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component] ?? 0
    }
}
