//
//  PaginatedAPIData.swift
//  MovieNight
//
//  Created by Bharath on 06/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation

class PaginatedAPIData {
    
    private(set) var page: Int = 0
    let maxPageLimit: Int?

    
    init(withPageToFetch page: Int, maxPageLimit limit: Int? ) {
        self.page = page
        maxPageLimit = limit
    }
    
    
    func incrementPage() {
        page = page + 1
    }
    
    func decrementPage() {
        page = page - 1
    }
    
}
