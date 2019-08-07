//
//  MovieListViewController.swift
//  MovieNight
//
//  Created by Bharath on 26/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class MovieListViewController: MovieCriteriaViewController {
    
    var tableView: TextWithSubtTitleTableView? = nil
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var footerView: ButtonWithActivityIndicatorHeaderFooterView? = nil
    var paginatedApiHandler: PaginatedMovieAPIHandler?
    
    var movies: NSOrderedSet = [] {
        didSet {
            //Create view model for each movie object.
            self.moviesListViewModels = movies.compactMap({ return MovieListViewModel(withMovie: $0 as! Movie)})
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
        
        tableView = TextWithSubtTitleTableView(withData: moviesListViewModels, tableViewActionResponder: self, headerFooterDataSource: self)
        view.addSubview(tableView!)
        tableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Movie list"
        configurePaginatedApiHandler()
    }
    
    
    override var rightNavigationBarButtonItemConfig: BarButtonType? {
        return BarButtonType.system(.done, titleColor: .white, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    override var leftNavigationBarButtonItemConfig: BarButtonType? {
        return nil
    }
    
    
    deinit {
        tableView = nil
        footerView = nil
    }
    
}


extension MovieListViewController: TableViewHeaderAndFooterProvider {
    
    
    var tableViewFooter: UIView? {
        
        if let paginatedApiHandler = paginatedApiHandler {
            
            if paginatedApiHandler.apiDataActive == nil {
                return nil
            }
        }
        else {
            return nil
        }
       
        if footerView == nil {
            
            footerView = ButtonWithActivityIndicatorHeaderFooterView(withFrame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 75.0), displayState: .notLoading(buttonTitle: "Load more"), buttonTapHandler: { [unowned self] () -> Void in
                
                self.footerView?.update(displayState: .loading)
                self.paginatedApiHandler?.triggerAPIRequest()
            })
        }
        return footerView
    }
}


extension MovieListViewController: TextWithSubTitleTableViewActionResponder {
    
    func accessoryInfoButtonTapped(atIndexPath indexPath: IndexPath) {
        self.showMovieDetail(atIndex: indexPath.row)
    }
    
    func tableViewCellTapped(atIndexPath indexPath: IndexPath) {
        self.showMoviePosterImage(atIndexPath: indexPath)
    }
    
    
    func showMovieDetail(atIndex index: Int) {
        
        let selectedMovie: Movie = movies[index] as! Movie
        let movieDetailVC: MovieDetailViewController = MovieDetailViewController(withMovie: selectedMovie)
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    
    func showMoviePosterImage(atIndexPath indexPath: IndexPath) {
        
        let viewModel: MovieListViewModel = self.moviesListViewModels[indexPath.row]
        if let posterImage = viewModel.contentImage {
            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let imageVC: ImageViewController? = sb.instantiateViewController(withIdentifier: "ImgViewController") as? ImageViewController
            
            if let imageVC = imageVC {
                imageVC.imageToDisplay = posterImage
                let navController: UINavigationController = UINavigationController(rootViewController: imageVC)
                navController.navigationBar.barTintColor = UIColor.init(red: 196.0/155.0, green: 26.0/155.0, blue: 22.0/155.0, alpha: 1.0)
                present(navController, animated: true, completion: nil)
            }
        }
        
    }
}


extension MovieListViewController {
    
    
    func paginatedApiData() -> [PaginatedMovieAPIData] {
        
        let allParameterTypes: [QueryParameterType] = QueryParameterType.allParameterTypes
        var list : [PaginatedMovieAPIData] = []
        
        for parameterType in allParameterTypes {
            
            let genreConfigurer: CollectionQueryItemConfigurer = CollectionQueryItemConfigurer(parameters: self.movieCriteria.genres, parameterType: parameterType)
            
            var actorConfigurer: CollectionQueryItemConfigurer? = nil
            if let actors = self.movieCriteria.actors {
                actorConfigurer = CollectionQueryItemConfigurer(parameters: actors, parameterType: parameterType)
            }
            
            if let certifications = self.movieCriteria.certifications {
                
                for certification in certifications {
                    
                    let paginatedApiData = PaginatedMovieAPIData(withGenreConfig: genreConfigurer, actorConfig: actorConfigurer, certification: certification, pageToFetch: 0, maxPageLimit: nil)
                    
                    list.append(paginatedApiData)
                }
            }
            else {
                let paginatedApiData = PaginatedMovieAPIData(withGenreConfig: genreConfigurer, actorConfig: actorConfigurer, certification: nil, pageToFetch: 0, maxPageLimit: nil)
                
                list.append(paginatedApiData)
                
            }
            
        }
        return list
    }
    
    
    func configurePaginatedApiHandler() {
        
        paginatedApiHandler = PaginatedMovieAPIHandler(withPaginatedMovieApiList: paginatedApiData(), responseHandler: { [unowned self] (movies: [Movie]?, error: Error?, allDataFetched: Bool) -> Void in
            
            self.footerView?.update(displayState: .notLoading(buttonTitle: "Load more"))
            self.handleMovieListResponse(containing: movies, error: error, allDataFetched: allDataFetched)
            
        })
    }
    
    
    func handleMovieListResponse(containing movies: [Movie]?, error: Error?, allDataFetched: Bool) {
        
        if let error = error {
            print("Error: \(error)")
        }
        else {
            if let movies = movies {
                
                print("Movies: \(movies)")
                
                let existingSet: NSMutableOrderedSet = NSMutableOrderedSet.init(orderedSet: self.movies)
                existingSet.addObjects(from: movies)
                self.movies = existingSet
                
            }
        }
        
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
            
            let url: URL? = self.appDelegate?.imageConfiguration?.urlFor(imagePath: posterImagePath!, withImageCategory: ImageCategory.poster(.w780))
            
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


extension MovieListViewController {
    
    @objc override func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        
        movieCriteria.reset()
        dismiss(animated: true, completion: nil)
    }
   
}


