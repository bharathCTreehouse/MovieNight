//
//  MovieResultList.swift
//  MovieNight
//
//  Created by Bharath on 26/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct MovieResultList: Decodable {
    
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
}
