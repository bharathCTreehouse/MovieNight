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
    var currentMovieListCount: Int = 0
    var movieFetchDataTask: URLSessionDataTask? = nil
    let imageOperationQueue: OperationQueue = OperationQueue.init()

    var paginatedApiHandler: PaginatedMovieAPIHandler? {
        didSet {
            activateNavigationItemTitleView()
            paginatedApiHandler?.triggerAPIRequest()
        }
    }
    var movies: NSOrderedSet = [] {
        didSet {
            respondToMovieListUpdate()
        }
    }
    var moviesListViewModels: [MovieListViewModel] = [] {
        didSet {
            respondToMovieListViewModelUpdate()
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
        configurePaginatedApiHandler()
    }
    
    
    override var rightNavigationBarButtonItemConfig: BarButtonType? {
        return BarButtonType.system(.done, titleColor: .white, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    override var leftNavigationBarButtonItemConfig: BarButtonType? {
        return nil
    }
    
    
    override var titleString: String? {
        return "Movie list"
    }
    
    
    deinit {
        tableView = nil
        footerView = nil
    }
    
}


extension MovieListViewController {
    
    func respondToMovieListUpdate() {
        
        //Create view model for each movie object.
        
        if currentMovieListCount > 0 {
            //Movie objects already present. So create view models only for the newly added movies.
            let movieSubset = movies.dropFirst(currentMovieListCount)
            moviesListViewModels.append(contentsOf: movieSubset.compactMap({ return MovieListViewModel(withMovie: $0 as! Movie)}))
        }
        else {
            moviesListViewModels = movies.compactMap({ return MovieListViewModel(withMovie: $0 as! Movie)})
        }
    }
    
    
    func respondToMovieListViewModelUpdate() {
        
        //Update the table view here.
        tableView?.update(withData: moviesListViewModels)
        
        //Start fetching movie poster images.
        if currentMovieListCount > 0 {
            let viewModelSubset = Array(moviesListViewModels.dropFirst(currentMovieListCount))
            fetchPosterImages(for: viewModelSubset)
            
        }
        else {
            fetchPosterImages(for: moviesListViewModels)
        }
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
        
        let selectedMovie: Movie? = movies[index] as? Movie
        if let selectedMovie = selectedMovie {
            let movieDetailVC: MovieDetailViewController = MovieDetailViewController(withMovie: selectedMovie)
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
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
            
            self.activateNavigationItemTitle()
            self.currentMovieListCount = self.movies.count
            self.footerView?.update(displayState: .notLoading(buttonTitle: "Load more"))
            self.handleMovieListResponse(containing: movies, error: error, allDataFetched: allDataFetched)
            
        })
    }
    
    
    func handleMovieListResponse(containing movies: [Movie]?, error: Error?, allDataFetched: Bool) {
        
        if let error = error {
            
            if error.representsTaskCancellation == false {
                showAlertController(withTitle: "Alert", message: error.localizedDescription, actionTitles: ["OK"])
            }
            
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
        
        for (_,viewModel) in viewModels.enumerated() {
            
            let mainIndex: Int? = moviesListViewModels.firstIndex(of: viewModel)
            let posterImagePath: String? = viewModel.movie.posterPath
            if posterImagePath == nil {
                continue
            }
            
            let url: URL? = self.appDelegate?.imageConfiguration?.urlFor(imagePath: posterImagePath!, withImageCategory: ImageCategory.poster(.w780))
            
            if let url = url {
                
                let imageOperation: MovieListPosterImageOperation = MovieListPosterImageOperation(withURL: url, identifier: mainIndex, movieListViewModel: viewModel, completionHandler: { [unowned self] (index: Int?, error: Error?) -> Void in
                    
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
        
        paginatedApiHandler?.cancelAllPaginatedTasks()
        imageOperationQueue.cancelAllOperations()
        movieCriteria.reset()
        dismiss(animated: true, completion: nil)
    }
   
}


