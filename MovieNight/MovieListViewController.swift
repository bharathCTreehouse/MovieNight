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
    
    var tableView: TextWithSubtTitleTableView? = nil
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    var movies: Set<Movie> = [] {
        didSet {
            //Create view model for each movie object.
            self.moviesListViewModels = movies.compactMap({ return MovieListViewModel(withMovie: $0)})
        }
    }
    var moviesListViewModels: [MovieListViewModel] = [] {
        didSet {
            //Update the table view here.
            tableView?.update(withData: moviesListViewModels)
            
            //Start fetching movie poster images.
            //Find all view models without images.
            let viewModelsWithoutImages: [MovieListViewModel] = moviesListViewModels.filter({ return $0.posterImage == nil})
            fetchPosterImages(for: viewModelsWithoutImages)
            
        }
    }
    
    
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
        
        tableView = TextWithSubtTitleTableView(withData: moviesListViewModels)
        view.addSubview(tableView!)
        tableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        fetchMoviesBasedOnSelectedCriteria()
    }
    
    
   
    deinit {
        tableView = nil
    }
    
}



extension MovieListViewController {
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.movieCriteria.reset()
        dismiss(animated: true, completion: nil)
    }
}



extension MovieListViewController {
    
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
                    print("Movies: \(movies)")
                    self.movies = self.movies.union(movies)
                }
            }
        })
    }
}



extension MovieListViewController {
    
    
    func fetchPosterImages(for viewModels: [MovieListViewModel]) {
        
        let imageOperationQueue: OperationQueue = OperationQueue.init()
        
        for (index,viewModel) in viewModels.enumerated() {
            
            let posterImagePath: String? = viewModel.movie.posterPath
            if posterImagePath == nil {
                continue
            }
            
            let url: URL? = self.appDelegate?.imageConfiguration?.urlFor(imagePath: posterImagePath!, withImageCategory: ImageCategory.poster(.original))
            
            if let url = url {
                
                let imageOperation: MovieListPosterImageOperation = MovieListPosterImageOperation(withURL: url, identifier: index, movieListViewModel: viewModel, completionHandler: { [unowned self] (index: Int?, error: Error?) -> Void in
                    
                    if error == nil && index != nil {
                        self.tableView?.reloadRows(at: [IndexPath.init(row: index!, section: 0)], with: .automatic)
                    }
                })
                
                imageOperationQueue.addOperation(imageOperation)
            }
            
        }

    }
    
}


