//
//  Actor.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct Actor: Decodable {
    
    let name: String
    let ID: Int
    let profilePath: String?
    
    
    enum DecodableKeys: String, CodingKey {
        case ID = "id"
        case name
        case profilePath = "profile_path"
    }
    
    
    init(from decoder: Decoder) throws {
        
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: DecodableKeys.self)
        
        self.ID = try container.decode(Int.self, forKey: .ID)
        self.name = try container.decode(String.self, forKey: .name)
        self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)

    }
    
}
