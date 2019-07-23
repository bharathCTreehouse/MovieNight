//
//  CertificationResultList.swift
//  MovieNight
//
//  Created by Bharath on 21/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


struct CertificationResultList: Decodable {
    
    let allCertifications: [String: [Certification]]
    
    
    enum OuterCodingKeys: String, CodingKey {
        case certifications
    }
    
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: OuterCodingKeys.self)
        allCertifications = try container.decode([String: [Certification]].self, forKey: .certifications)
    }

    
}
