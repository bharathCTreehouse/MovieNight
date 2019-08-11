//
//  MovieNightAlertViewController.swift
//  MovieNight
//
//  Created by Bharath on 10/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

class MovieNightAlertViewController {
    
    static func displayAlertController(onViewController vc: UIViewController, withTitle title: String?, message: String?, actionTitles: [String], buttonActionCompletion: ((Int?) -> Void)?) {
        
        let alertController: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        for actionTitle in actionTitles {
            let alertAction: UIAlertAction = UIAlertAction(title: actionTitle, style: .default, handler: { (action: UIAlertAction) -> Void in
                buttonActionCompletion?(alertController.actions.firstIndex(of: action))
            })
            alertController.addAction(alertAction)
        }
        vc.present(alertController, animated: true, completion: nil)
        
    }
    
}
