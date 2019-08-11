//
//  MovieNightAPIError.swift
//  MovieNight
//
//  Created by Bharath on 28/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation

enum MovieNightAPIError: Swift.Error {
    
    case invalidRequest
    case invalidResponse
    case invalidData
    
}


extension Error {
    
    var representsTaskCancellation: Bool {
        return (self as NSError).code == NSURLErrorCancelled
    }
}
