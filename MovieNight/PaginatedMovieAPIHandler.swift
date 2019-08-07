//
//  PaginatedMovieAPIHandler.swift
//  MovieNight
//
//  Created by Bharath on 06/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class PaginatedMovieAPIHandler: PaginatedAPIHandler {
    
    var responseHandler: (([Movie]?, Error?, Bool) -> Void)?
    
    
    init(withPaginatedMovieApiList list: [PaginatedMovieAPIData], responseHandler handler: (([Movie]?, Error?, Bool) -> Void)?) {
        
        responseHandler = handler
        super.init(withPaginatedDataList: list)
    }
    
    
    override func triggerAPIRequest() {
        
        let movieAPI: MovieNightAPI = MovieNightAPI()
        apiDataActive = allPaginatedData.first
        let movieApiData: PaginatedMovieAPIData? = apiDataActive as? PaginatedMovieAPIData

        if self.maxLimitReached == true ||  apiDataActive == nil || movieApiData == nil {
            responseHandler?([], nil, true)
            return
        }
        
        apiDataActive!.incrementPage()
        
        movieAPI.fetchMovies(withEndPoint: Endpoint.fetchMovie(genres: movieApiData!.genreQueryConfig, actors: movieApiData!.actorQueryConfig, certification: movieApiData!.certification, pageToFetch: apiDataActive!.page), completionHandler: { [unowned self] (movies: [Movie]?, error: Error?, currentPage: Int?, totalPages: Int?) -> Void in
            
            if let error = error {
                print(error)
                
                //Decrement the page count since there was an error.
                self.apiDataActive!.decrementPage()
                
                //Call the completion handler
                self.responseHandler?(nil, error, false)
            }
            else {
                if let movies = movies {
                    if movies.isEmpty == true {
                        self.removePaginatedData(atIndex: 0)
                        self.triggerAPIRequest()
                    }
                    else {
                        //Call the completion handler
                        self.responseHandler?(movies, nil, false)
                    }
                }
                else {
                    self.removePaginatedData(atIndex: 0)
                    self.triggerAPIRequest()
                }
            }
        })
    }
    
    
    deinit {
        responseHandler = nil
    }
}
