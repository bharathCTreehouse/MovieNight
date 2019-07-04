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
    
    
//    var queryItems: [URLQueryItem] {
//        let item: URLQueryItem = URLQueryItem(name: "api_key", value: "8102c0c8495a01ed0e10caccf707a760")
//        return [item]
//    }

    
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
