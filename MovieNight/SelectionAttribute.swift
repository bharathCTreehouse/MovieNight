//
//  SelectionAttribute.swift
//  MovieNight
//
//  Created by Bharath on 04/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


struct SelectionAttribute {
    
    private(set) var isSelected: Bool = false
    let selectionColor: UIColor
    
    init(withSelected selected: Bool, color: UIColor) {
        isSelected = selected
        selectionColor = color
    }
    
    
    mutating func changeSelectedState(to state: Bool) {
        self.isSelected = state
    }
}
