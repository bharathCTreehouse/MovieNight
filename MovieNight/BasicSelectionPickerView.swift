//
//  BasicSelectionPickerView.swift
//  MovieNight
//
//  Created by Bharath on 22/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class BasicSelectionPickerView: UIPickerView {
    
    private var pickerDataSource: SelectionPickerViewDataSource? = nil
    
    var pickerDelegate: BasicSelectionPickerViewDelegate? = nil {
        
        didSet {
            
            if let pickerDelegate = pickerDelegate {
                
                var dataSource: [pickerViewComponent: pickerViewRowCount] = [:]
                for (column, content) in pickerDelegate.data {
                    dataSource.updateValue(content.count, forKey: column)
                }
                pickerDataSource = SelectionPickerViewDataSource(withData: dataSource)
            }
            else {
                pickerDataSource = nil
            }
            
            delegate = pickerDelegate
            dataSource = pickerDataSource
            reloadAllComponents()

            
        }
    }
    
    
    init(withDelegate delegate: BasicSelectionPickerViewDelegate) {
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        update(withDelegate: delegate)
    }
    
    
    
    func update(withDelegate delegate: BasicSelectionPickerViewDelegate) {
        pickerDelegate = delegate
    }
    
    
    func update(withRawData data: [pickerViewComponent: [String]], changeResponderDelegate delegate: BasicSelectionPickerViewChangeResponder?) {

        update(withDelegate: BasicSelectionPickerViewDelegate(withData: data, changeResponderDelegate: delegate))
    }

   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    deinit {
        pickerDataSource = nil
        pickerDelegate = nil
    }
    
}
