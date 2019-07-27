//
//  SetUtilities.swift
//  MovieNight
//
//  Created by Bharath on 27/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


extension Set where Element == String {
    
    
    func itemsSeparated(by separatorString: String) -> String {
        
        if self.isEmpty == true {
            return ""
        }
        else {
            var concatenatedString: String = self.reduce("") { (interimString, content) -> String in
                return interimString + "\(content)\(separatorString)"
            }
            concatenatedString.removeLast()
            return concatenatedString
        }
    }
    
    
    
    func separatedItemsFor(parameterType type: QueryParameterType) -> String {
        return self.itemsSeparated(by: type.separator)
    }
}
