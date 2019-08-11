//
//  CountryPickerAlertAction.swift
//  MovieNight
//
//  Created by Bharath on 26/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class CountryPickerAlertAction {
    
    let completionHandler: ((String) -> Void)
    var alertAction: UIAlertAction? = nil
    let identifierString: String
    
    
    init(withIdentifier identifier: String, style: UIAlertAction.Style, actionTitle title: String,  handler: @escaping ((String) -> Void)) {
        
        completionHandler = handler
        identifierString = identifier
        
        self.alertAction = UIAlertAction.init(title: title, style: style, handler: { (action: UIAlertAction) -> Void in
            
            self.completionHandler(self.identifierString)
        })
    }
    
    
    deinit {
        alertAction = nil
    }
    
}
