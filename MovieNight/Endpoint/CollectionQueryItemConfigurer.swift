//
//  CollectionQueryItemConfigurer.swift
//  MovieNight
//
//  Created by Bharath on 27/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


enum QueryParameterType {
    case AND
    case OR
    
    var separator: String {
        
        switch self {
            case .AND: return ","
            case .OR: return "|"
        }
    }
    
    static var allParameterTypes: [QueryParameterType] {
        return [.AND, .OR]
    }
}



struct CollectionQueryItemConfigurer {
    
    let parameters: Set<String>
    let parameterType: QueryParameterType
    
    
    var combinedParameterString: String {
        return parameters.separatedItemsFor(parameterType: parameterType)
    }
}
