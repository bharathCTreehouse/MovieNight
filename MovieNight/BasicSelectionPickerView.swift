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
    
    var selectionCompletionHandler: ((Int, Int) -> Void)?
    
    
    
    init(withData data: [pickerViewComponent: [String]], completionHandler handler: ((Int, Int) -> Void)? ) {
        
        selectionCompletionHandler = handler
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        update(withData: data)
    }
    
    
    
    func update(withData data: [pickerViewComponent: [String]]) {
        pickerDelegate = BasicSelectionPickerViewDelegate(withData: data, changeResponderDelegate: self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    deinit {
        pickerDataSource = nil
        pickerDelegate = nil
    }
    
}



extension BasicSelectionPickerView: BasicSelectionPickerViewChangeResponder {
    
    
    func didSelectRow(_ row: Int, inComponent component: Int) {
        selectionCompletionHandler?(component, row)
    }
    
    
}
