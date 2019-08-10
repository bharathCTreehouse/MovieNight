//
//  UINavigationItemUtilities.swift
//  MovieNight
//
//  Created by Bharath on 04/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum UINavigationItemTitleType {
    case title(String?)
    case view(UIView?)
}


extension UINavigationItem {
    
    func setupRightNavigationBarButtonItem(usingConfigData configData: BarButtonType?) {
        
        if configData == nil {
            self.rightBarButtonItem = nil
        }
        else {
            
            switch configData! {
                
            case let .custom(withTitle: title, titleColor: color, style: style, target: actionTarget, action: action):
                
                self.rightBarButtonItem = UIBarButtonItem(title: title, style: style, target: actionTarget, action: action)
                self.rightBarButtonItem?.tintColor = color
                
                
            case let .system(systemType, titleColor: color, target: actionTarget, action: action):
                
                self.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: systemType, target: actionTarget, action: action)
                self.rightBarButtonItem?.tintColor = color
                
            }
        }
        
    }
    
    
    func setupLeftNavigationBarButtonItem(usingConfigData configData: BarButtonType?) {
        
        if configData == nil {
            self.leftBarButtonItem = nil
        }
        else {
            
            switch configData! {
                
            case let .custom(withTitle: title, titleColor: color, style: style, target: actionTarget, action: action):
                
                self.leftBarButtonItem = UIBarButtonItem(title: title, style: style, target: actionTarget, action: action)
                self.leftBarButtonItem?.tintColor = color
                
                
            case let .system(systemType, titleColor: color, target: actionTarget, action: action):
                
                self.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: systemType, target: actionTarget, action: action)
                self.leftBarButtonItem?.tintColor = color
                
            }
        }
    }
    
    
    func configureTitle(forType type: UINavigationItemTitleType) {
        
        switch type {
            case .title(let titleString): self.title = titleString
                                          self.titleView = nil
            
            case .view(let titleView): self.titleView = titleView
        }
    }
}
