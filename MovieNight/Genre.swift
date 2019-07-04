//
//  Genre.swift
//  MovieNight
//
//  Created by Bharath on 26/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct Genre: Decodable {
    
    let ID: Int
    let name: String
    
    
    enum InnerCodingKey: String, CodingKey {
        case ID = "id"
        case name
    }
    
    
    init(from decoder: Decoder) throws {
        
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: InnerCodingKey.self)
        
        self.ID = try container.decode(Int.self, forKey: .ID)
        self.name = try container.decode(String.self, forKey: .name)
    }

}






