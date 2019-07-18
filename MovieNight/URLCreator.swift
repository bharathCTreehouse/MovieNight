//
//  URLCreator.swift
//  MovieNight
//
//  Created by Bharath on 26/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation

protocol URLCreator {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}


extension URLCreator {
    
    var base: String {
        return "https://api.themoviedb.org/"
    }
    
    
    var request: URLRequest? {
        
        var urlComponents: URLComponents? = URLComponents(url: URL(string: base)!, resolvingAgainstBaseURL: true)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        
        if let url = urlComponents?.url {
            return URLRequest(url: url)
        }
        else {
            return nil
        }
        
    }
}
