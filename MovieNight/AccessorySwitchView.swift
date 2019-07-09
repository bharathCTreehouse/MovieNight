//
//  AccessorySwitchView.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class AccessorySwitchView: UISwitch {
    
    let indexPath: IndexPath
    
    
    init(withIndexPath indexPath: IndexPath) {
        
        self.indexPath = indexPath
        super.init(frame: .zero)
        self.sizeToFit()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        self.indexPath = IndexPath(row: 0, section: 0)
        super.init(coder: aDecoder)
    }
    
}
