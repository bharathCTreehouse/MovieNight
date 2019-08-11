//
//  MovieNightAPI.swift
//  MovieNight
//
//  Created by Bharath on 28/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class MovieNightAPI {
    
    @discardableResult func fetchAllGenres(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping ([Genre]?, Error?) -> ()) -> URLSessionDataTask? {
        
        
        let dataTask: URLSessionDataTask? = fetchData(forUrlRequest: endPoint.request, completionHandler: { (data: Data?, error: Error?) -> () in
            
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
        
        return dataTask
        
        
    }
    
    
    
    @discardableResult func fetchActors(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping ([Actor]?, Error?) -> ()) -> URLSessionDataTask? {
        
        
        let dataTask: URLSessionDataTask? = fetchData(forUrlRequest: endPoint.request, completionHandler: { (data: Data?, error: Error?) -> () in
            
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
        
        return dataTask
    }
    
    
    
    @discardableResult func fetchImageConfiguration(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping (ImageConfiguration?, Error?) -> ()) -> URLSessionDataTask? {
        
        
        let dataTask: URLSessionDataTask? = fetchData(forUrlRequest: endPoint.request, completionHandler: { (data: Data?, error: Error?) -> () in
            
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
        
        return dataTask
        
    }
    
    
    
    @discardableResult func fetchAllCertifications(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping ([String: [Certification]]?, Error?) -> ()) -> URLSessionDataTask? {
        
        
        let dataTask: URLSessionDataTask? = fetchData(forUrlRequest: endPoint.request, completionHandler: { (data: Data?, error: Error?) -> () in
            
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
        
        return dataTask
    }
    
    
    
    @discardableResult func fetchMovies(withEndPoint endPoint: URLCreator, completionHandler handler: @escaping ([Movie]?, Error?, Int?, Int?) -> ()) -> URLSessionDataTask? {
        
        
        let dataTask: URLSessionDataTask? = fetchData(forUrlRequest: endPoint.request, completionHandler: { (data: Data?, error: Error?) -> () in
            
            if let error = error {
                handler(nil, error, nil, nil)
            }
            else {
                if let data = data {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let movieList: MovieResultList = try! jsonDecoder.decode(MovieResultList.self, from: data)
                    handler(movieList.results, nil, movieList.page, movieList.totalPages)
                }
                else {
                    handler(nil, error, nil, nil)
                }
            }
        })
        
        return dataTask
    }
    
    
    
    @discardableResult func fetchData(atUrl url: URL, completionHandler handler: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask? {
        
        let urlRequest: URLRequest? = URLRequest(url: url)
        
        let dataTask: URLSessionDataTask? = fetchData(forUrlRequest: urlRequest, completionHandler: { (data: Data?, error: Error?) -> Void in
            
            if let error = error {
                handler(nil, error)
            }
            else {
                if let data = data {
                    handler(data, nil)
                }
                else {
                    handler(nil, error)
                }
            }
            
        })
        
        return dataTask
    }
}


extension MovieNightAPI {
    
    
    @discardableResult private func fetchData(forUrlRequest urlRequest: URLRequest?, completionHandler handler: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask? {
        
        
        if urlRequest == nil {
            handler(nil, MovieNightAPIError.invalidRequest)
            return nil
        }
        else {
            
            let urlSession: URLSession = URLSession.init(configuration: .default)

            let task = urlSession.dataTask(with: urlRequest!, completionHandler: { (data: Data?, resp: URLResponse?, error: Error?) -> () in
                
                
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
            return task
            
            
        }
        
        
    }
    
}
