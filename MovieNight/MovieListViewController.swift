//
//  MovieListViewController.swift
//  MovieNight
//
//  Created by Bharath on 26/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class MovieListViewController: MovieNightViewController {
    
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        fetchMoviesBasedOnSelectedCriteria()
    }
    
    
    func fetchMoviesBasedOnSelectedCriteria() {
        
        let allParameterTypes: [QueryParameterType] = QueryParameterType.allParameterTypes
        
        for parameterType in allParameterTypes {
            
            let genreConfigurer: CollectionQueryItemConfigurer = CollectionQueryItemConfigurer(parameters: self.movieCriteria.genres, parameterType: parameterType)
            
            var actorConfigurer: CollectionQueryItemConfigurer? = nil
            if let actors = self.movieCriteria.actors {
                actorConfigurer = CollectionQueryItemConfigurer(parameters: actors, parameterType: parameterType)
            }
            
            if let certifications = self.movieCriteria.certifications {
                
                for certification in certifications {
                    fetchMovies(forGenreConfig: genreConfigurer, actorConfig: actorConfigurer, certification: certification)
                }
            }
            else {
                fetchMovies(forGenreConfig: genreConfigurer, actorConfig: actorConfigurer, certification: nil)
            }
            
        }
    }
    
    
    func fetchMovies(forGenreConfig genreConfig: CollectionQueryItemConfigurer, actorConfig: CollectionQueryItemConfigurer?, certification: Certification?) {
        
        
        let movieNightAPI: MovieNightAPI = MovieNightAPI()

        movieNightAPI.fetchMovies(withEndPoint: Endpoint.fetchMovie(genres: genreConfig, actors: actorConfig, certification: certification), completionHandler: { (movies: [Movie]?, error: Error?) -> Void in
            
            if let error = error {
                print("Error: \(error)")
            }
            else {
                if let movies = movies {
                    print("MOVIES: \(movies)")
                }
            }
        })
    }
    
}



extension MovieListViewController {
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.movieCriteria.reset()
        dismiss(animated: true, completion: nil)
    }
}
