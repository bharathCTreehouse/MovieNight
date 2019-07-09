//
//  ActorResultList.swift
//  MovieNight
//
//  Created by Bharath on 10/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct ActorResultList: Decodable {
    
    let actors: [Actor]
    
    let page: Int
    let totalResults: Int
    let totalPages: Int
    
    
    enum OuterCodingKeys: String, CodingKey {
        case actors = "results"
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    
    init(from decoder: Decoder) throws {
        
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: OuterCodingKeys.self)
        actors = try container.decode([Actor].self, forKey: .actors)
        page = try container.decode(Int.self, forKey: .page)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        
        
    }
    
}
