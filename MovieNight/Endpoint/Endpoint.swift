//
//  Endpoint.swift
//  MovieNight
//
//  Created by Bharath on 27/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


enum Endpoint: URLCreator {
    
    case fetchGenre
    case fetchPopularActors
    case fetchActor(name: String)
    case fetchCertifications
    case fetchMovie(genres: CollectionQueryItemConfigurer, actors: CollectionQueryItemConfigurer?, certification: Certification?)
    case fetchImageConfiguration
    
    var path: String {
        switch self {
            case .fetchGenre: return "/3/genre/movie/list"
            case .fetchPopularActors: return "/3/person/popular"
            case .fetchActor: return "/3/search/person"
            case .fetchCertifications: return "/3/certification/movie/list"
            case .fetchMovie: return "/3/discover/movie"
            case .fetchImageConfiguration: return "/3/configuration"

        }
    }
    
    var queryItems: [URLQueryItem] {
        
        var items: [URLQueryItem] = [URLQueryItem(name: "api_key", value: "8102c0c8495a01ed0e10caccf707a760")]
        
        switch self {
            
            case let .fetchActor(name: actorName): items.append(URLQueryItem(name: "query", value: actorName))
            
            case let .fetchMovie(genres: genreConfigurer, actors: actorConfigurer, certification: certi):
                
                items.append(URLQueryItem(name: "with_genres", value: genreConfigurer.combinedParameterString))
                if let actorConfigurer = actorConfigurer {
                    items.append(URLQueryItem(name: "with_cast", value: actorConfigurer.combinedParameterString))
                }
                if let certi = certi {
                    items.append(URLQueryItem(name: "certification_country", value: certi.country))
                    items.append(URLQueryItem(name: "certification", value: certi.name))
                }
            
            default: break
        }
        
        return items
    }
    
    
}
