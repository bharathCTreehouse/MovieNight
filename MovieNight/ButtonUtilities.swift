//
//  ButtonUtilities.swift
//  MovieNight
//
//  Created by Bharath on 26/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

enum AlphaChangeNeeded {
    case no
    case yes (CGFloat)
}


extension UIButton {
    
    func changeEnabledState(to isEnabled: Bool, alphaChangeStatus change: AlphaChangeNeeded) {
        self.isEnabled = isEnabled
        
        switch change {
            case .no: self.alpha = self.alpha
            case .yes(let alphaValue): self.alpha = alphaValue
        }
    }
}
