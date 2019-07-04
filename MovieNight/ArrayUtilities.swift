//
//  ArrayUtilities.swift
//  MovieNight
//
//  Created by Bharath on 27/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


extension Array where Element == String {
    
    var commaSeparatedItems: String {
        
        if self.isEmpty == true {
            return ""
        }
        else {
            var concatenatedString: String = self.reduce("") { (interimString, content) -> String in
                return interimString + "\(content),"
            }
            concatenatedString.removeLast()
            return concatenatedString
        }
    }
}
