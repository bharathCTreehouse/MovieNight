//
//  MovieNightAPI.swift
//  MovieNight
//
//  Created by Bharath on 28/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class MovieNightAPI {
    
    func fetchAllGenres(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping ([Genre]?, Error?) -> ()) {
        
        
        fetchData(forEndPoint: endPoint, completionHandler: { (data: Data?, error: Error?) -> () in
            
            if let error = error {
                handler(nil, error)
            }
            else {
                if let data = data {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    let genreResultList: GenreResultList = try! jsonDecoder.decode(GenreResultList.self, from: data)
                    handler(genreResultList.allGenres, nil)
                }
                else {
                    handler(nil, error)
                }
            }
        })
        
        
    }
    
    
    
    
    func fetchActors(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping ([Actor]?, Error?) -> ()) {
        
        
        fetchData(forEndPoint: endPoint, completionHandler: { (data: Data?, error: Error?) -> () in
            
            if let error = error {
                handler(nil, error)
            }
            else {
                if let data = data {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    let actorResultList: ActorResultList = try! jsonDecoder.decode(ActorResultList.self, from: data)
                    handler(actorResultList.actors, nil)
                }
                else {
                    handler(nil, error)
                }
            }
        })
        
        
    }
    
    
    
    func fetchImageConfiguration(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping (ImageConfiguration?, Error?) -> ()) {
        
        
        fetchData(forEndPoint: endPoint, completionHandler: { (data: Data?, error: Error?) -> () in
            
            if let error = error {
                handler(nil, error)
            }
            else {
                if let data = data {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let imageConfig: ImageConfiguration = try! jsonDecoder.decode(ImageConfiguration.self, from: data)
                    handler(imageConfig, nil)
                }
                else {
                    handler(nil, error)
                }
            }
        })
        
    }
    
    
    
    func fetchAllCertifications(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping ([String: [Certification]]?, Error?) -> ()) {
        
        
        fetchData(forEndPoint: endPoint, completionHandler: { (data: Data?, error: Error?) -> () in
            
            if let error = error {
                handler(nil, error)
            }
            else {
                if let data = data {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    let certificationResultList: CertificationResultList = try! jsonDecoder.decode(CertificationResultList.self, from: data)
                    handler(certificationResultList.allCertifications, nil)
                }
                else {
                    handler(nil, error)
                }
            }
        })
    }
    
    
    
    func fetchMovies(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping ([Movie]?, Error?) -> ()) {
        
        
        fetchData(forEndPoint: endPoint, completionHandler: { (data: Data?, error: Error?) -> () in
            
            if let error = error {
                handler(nil, error)
            }
            else {
                if let data = data {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let movieList: MovieResultList = try! jsonDecoder.decode(MovieResultList.self, from: data)
                    handler(movieList.results, nil)
                }
                else {
                    handler(nil, error)
                }
            }
        })
        
    }
    
}


extension MovieNightAPI {
    
    
    private func fetchData(forEndPoint endPoint: URLCreator, completionHandler handler: @escaping (Data?, Error?) -> ()) {
        
        let urlSession: URLSession = URLSession.init(configuration: .default)
        
        if endPoint.request == nil {
            handler(nil, MovieNightAPIError.invalidRequest)
        }
        else {
            
            let task = urlSession.dataTask(with: endPoint.request!, completionHandler: { (data: Data?, resp: URLResponse?, error: Error?) -> () in
                
                
                DispatchQueue.main.async {
                    
                    if let error = error {
                        handler(nil, error)
                    }
                    else {
                        
                        if let resp = resp as? HTTPURLResponse {
                            
                            if resp.statusCode == 200 {
                                
                                if let data = data {
                                    handler(data, nil)
                                }
                                else {
                                    handler(nil, MovieNightAPIError.invalidData)
                                }
                            }
                            else {
                                handler(nil, MovieNightAPIError.invalidResponse)
                            }
                            
                        }
                        else {
                            handler(nil, MovieNightAPIError.invalidResponse)
                        }
                    }
                    
                }
                
            })
            
            task.resume()
            
        }
        
        
    }
    
}
