//
//  Certification.swift
//  MovieNight
//
//  Created by Bharath on 27/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct Certification: Decodable {
    
    let country: String
    let name: String
    let meaning: String
    let order: Int
    
    
    enum InnerCodingKey: String, CodingKey {
        case country
        case name = "certification"
        case meaning
        case order
    }
    
    
    init(from decoder: Decoder) throws {
        
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: InnerCodingKey.self)
        name = try container.decode(String.self, forKey: .name)
        meaning = try container.decode(String.self, forKey: .meaning)
        order = try container.decode(Int.self, forKey: .order)
        country = decoder.codingPath[1].stringValue
    }
    
    
    
    init(withCountry country: String) {
        
        self.country = country
        name = "None"
        meaning = ""
        order = -1
    }

}


extension Certification: Hashable {
    
}
