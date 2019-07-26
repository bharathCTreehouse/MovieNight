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
        fetchMovies()
    }
    
    
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.movieCriteria.reset()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func fetchMovies() {
        
        let movieNightAPI: MovieNightAPI = MovieNightAPI()
        
        movieNightAPI.fetchMovies(withEndPoint: Endpoint.fetchMovie(genreIDs: self.movieCriteria.genres, actorIDs: self.movieCriteria.actors, certification: self.movieCriteria.certifications?.first), completionHandler: { (movies: [Movie]?, error: Error?) -> Void in
            
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
