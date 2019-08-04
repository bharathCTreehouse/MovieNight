//
//  MovieDetailViewController.swift
//  MovieNight
//
//  Created by Bharath on 31/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class MovieDetailViewController: UIViewController {
    
    let movie: Movie
    var moviedetailViewModel: MovieDetailViewModel? = nil
    var movieBackdropView: MovieBackdropView? = nil
    var movieDetailTableView: MovieDetailTableView? = nil
    
    
    init(withMovie movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        movie = Movie(id: 1, voteCount: 0, video: false, voteAverage: 0.0, title: "", popularity: 0.0, posterPath: nil, originalLanguage: "", originalTitle: "", backdropPath: nil, adult: false, overview: "", releaseDate: "")
        super.init(coder: aDecoder)
    }
    
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
        
        movieBackdropView = MovieBackdropView()
        view.addSubview(movieBackdropView!)
        movieBackdropView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        movieBackdropView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        movieBackdropView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        movieDetailTableView = MovieDetailTableView(withMovieDetailViewModel: MovieDetailViewModel(withMovie: self.movie))
        view.addSubview(movieDetailTableView!)
        movieDetailTableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        movieDetailTableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        movieDetailTableView!.topAnchor.constraint(equalTo: movieBackdropView!.bottomAnchor).isActive = true
        movieDetailTableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movie detail"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        fetchBackdopImage()
    }
    
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    deinit {
        moviedetailViewModel = nil
        movieBackdropView = nil
        movieDetailTableView = nil
    }
}


extension MovieDetailViewController {
    
    func fetchBackdopImage() {
        
        movieBackdropView?.updateBackdropView(withType: .loading)
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        guard let imageConfig = appDelegate?.imageConfiguration, let backdropPath = movie.backdropPath, let url = imageConfig.urlFor(imagePath: backdropPath, withImageCategory: ImageCategory.backdrop(ImageCategory.BackdropSize.w780))
            else  {
                
                movieBackdropView?.updateBackdropView(withType: .noImagePresent)
                return
        }
        
        let apiClient: MovieNightAPI = MovieNightAPI()
        apiClient.fetchData(atUrl: url, completionHandler: { [unowned self] (imageData: Data?, error: Error?) -> Void in
            
            if let data = imageData, let image = UIImage(data: data) {
                
                self.movieBackdropView?.updateBackdropView(withType: .image(image))
            }
            else {
                self.movieBackdropView?.updateBackdropView(withType: .noImagePresent)
            }
            
        })
        
    }
}
