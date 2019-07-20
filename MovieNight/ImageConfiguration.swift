//
//  ImageConfiguration.swift
//  MovieNight
//
//  Created by Bharath on 18/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation

enum ImageCategory {
    
    case backdrop (BackdropSize)
    case logo (LogoSize)
    case poster (PosterSize)
    case profile (ProfileSize)
    case still (StillSize)
    
    enum BackdropSize: String {
        case w300
        case w780
        case w1280
        case original
    }
    enum LogoSize: String {
        case w45
        case w92
        case w154
        case w185
        case w300
        case w500
        case original
    }
    enum PosterSize: String {
        case w92
        case w154
        case w185
        case w342
        case w500
        case w780
        case original
    }
    enum ProfileSize: String {
        case w45
        case w185
        case w632
        case original
    }
    enum StillSize: String {
        case w92
        case w185
        case w300
        case original
    }
}


struct ImageConfiguration: Decodable {
    
    private let baseUrl:String
    private let secureBaseUrl:String
    private let backdropSizes: [String]
    private let logoSizes: [String]
    private let posterSizes: [String]
    private let profileSizes: [String]
    private let stillSizes: [String]
    
    enum OuterKeys: String, CodingKey {
        case images
    }
    
    enum InnerKeys: String, CodingKey {
        case baseUrl
        case secureBaseUrl
        case backdropSizes
        case logoSizes
        case posterSizes
        case profileSizes
        case stillSizes
    }
    
    init(from decoder: Decoder) throws {
        
        let outerContainer: KeyedDecodingContainer = try decoder.container(keyedBy: OuterKeys.self)
        let innerContainer: KeyedDecodingContainer = try outerContainer.nestedContainer(keyedBy: InnerKeys.self, forKey: .images)
        
        self.baseUrl = try innerContainer.decode(String.self, forKey: .baseUrl)
        self.secureBaseUrl = try innerContainer.decode(String.self, forKey: .secureBaseUrl)
        self.backdropSizes = try innerContainer.decode([String].self, forKey: .backdropSizes)
        self.logoSizes = try innerContainer.decode([String].self, forKey: .logoSizes)
        self.posterSizes = try innerContainer.decode([String].self, forKey: .posterSizes)
        self.profileSizes = try innerContainer.decode([String].self, forKey: .profileSizes)
        self.stillSizes = try innerContainer.decode([String].self, forKey: .stillSizes)
    }

}



extension ImageConfiguration {
    
    func urlFor(imagePath path: String, withImageCategory category: ImageCategory) -> URL? {
        
        var urlString: String = self.secureBaseUrl
        
        switch category {
            
        case .backdrop(let size): urlString.append(size.rawValue)
        case .logo(let size): urlString.append(size.rawValue)
        case .poster(let size): urlString.append(size.rawValue)
        case .profile(let size): urlString.append(size.rawValue)
        case .still(let size): urlString.append(size.rawValue)
        }
        
        urlString.append(path)
        return URL(string: urlString)
        
    }
    
}
