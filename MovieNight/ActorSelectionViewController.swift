//
//  ActorSelectionViewController.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ActorSelectionViewController: MovieCriteriaViewController {
    
    var searchBar: UISearchBar? = nil
    var tableView: MultipleOptionSelectionTableView? = nil
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate


    var popularActorsViewModel: [MultipleOptionSelectionDisplayable] = [] {
        didSet {
             self.tableView?.update(withData: [self.popularSectionInfo: self.popularActorsViewModel, self.searchSectionInfo: self.searchedActorsViewModel])
            self.tableView?.reloadSections(IndexSet.init(integer: 1), with: .automatic)
            fetchActorProfileImages(forFetchType: .popular)
        }
    }
    var searchedActorsViewModel: [MultipleOptionSelectionDisplayable] = [] {
        didSet {
            self.tableView?.update(withData: [self.popularSectionInfo: self.popularActorsViewModel, self.searchSectionInfo: self.searchedActorsViewModel])
            self.tableView?.reloadSections(IndexSet.init(integer: 0), with: .automatic)
            fetchActorProfileImages(forFetchType: .searched)
        }
    }
    
    
    var popularActors: [Actor] = [] {
        didSet {
            self.popularActorsViewModel = self.popularActors.compactMap({ return ActorListViewModel(withActor: $0)})
        }
    }
    var searchedActors: [Actor] = [] {
        didSet {
            self.searchedActorsViewModel = self.searchedActors.compactMap({ return ActorListViewModel(withActor: $0) })
        }
    }
    
    let searchSectionInfo: TableViewSectionDetail = TableViewSectionDetail(withHeader: TableViewSection.header(.title("Search results")), footer: TableViewSection.footer(.view(UIView.init(), 20.0)), identifier: 0)
    
    let popularSectionInfo: TableViewSectionDetail = TableViewSectionDetail(withHeader: TableViewSection.header(.title("Popular actors")), footer: nil, identifier: 1)
    
    
    
    override init(withMovieCriteria criteria: MovieCriteria) {
        super.init(withMovieCriteria: criteria)
        fetchAllPopularActors()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
        
        searchBar = UISearchBar()
        searchBar!.placeholder = "Search for an actor"
        searchBar!.delegate = self
        searchBar!.barStyle = .default
        searchBar!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBar!)
        searchBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        
        tableView = MultipleOptionSelectionTableView(withData: [searchSectionInfo: searchedActorsViewModel, popularSectionInfo: popularActorsViewModel], tableViewRowHeight: 90.0, selectionHandler: { [unowned self] (selectedIDs: [String]) -> Void in
            
            self.movieCriteria.addActors(withIDs: selectedIDs)
            
        })
        
        self.view.addSubview(tableView!)
        tableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView!.topAnchor.constraint(equalTo: searchBar!.bottomAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select actors"
    }
    
    
    
    func fetchAllPopularActors() {
        
        let movieNightClient: MovieNightAPI = MovieNightAPI()
        
        movieNightClient.fetchActors(withEndPoint: Endpoint.fetchPopularActors, completionHandler: { [unowned self] (actors: [Actor]?, error: Error?) -> Void in
            
            if let error = error {
                print("Error: \(error)")
            }
            else {
                if let actors = actors {
                    self.popularActors = actors
                }
            }
            
        })
        
    }
    
    
    deinit {
        tableView = nil
        searchBar = nil
    }
    
}



extension ActorSelectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
        guard let searchText = searchBar.text else {
            return
        }
        searchActor(withName: searchText)
    }
    
    
    func searchActor(withName name: String) {
        
        let movieNightClient: MovieNightAPI = MovieNightAPI()
        
        movieNightClient.fetchActors(withEndPoint: Endpoint.fetchActor(name: name), completionHandler: { [unowned self] (actors: [Actor]?, error: Error?) -> Void in
            
            if let error = error {
                print("Error: \(error)")
            }
            else {
                if let actors = actors {
                    self.searchedActors = actors
                }
            }
        })
    }
}




extension ActorSelectionViewController {
    
    
    func fetchActorProfileImages(forFetchType fetchType: ActorFetchType) {
        
        var list: [MultipleOptionSelectionDisplayable] = self.popularActorsViewModel
        var section: Int = 1
        
        if fetchType == .searched {
            list = self.searchedActorsViewModel
            section = 0
        }
        
        let imageQueue: OperationQueue = OperationQueue.init()
        
        
        for (index, data) in list.enumerated() {
            
            let viewModel: ActorListViewModel? = data as? ActorListViewModel
            if viewModel == nil {
                continue
            }
            if viewModel!.actor.profilePath == nil {
                continue
            }
            let imageURL: URL? = self.appDelegate?.imageConfiguration?.urlFor(imagePath: viewModel!.actor.profilePath!, withImageCategory: ImageCategory.profile(.original))
            if imageURL == nil {
                continue
            }
            
            
            let imageOperation: ActorListImageOperation =  ActorListImageOperation(withActorListViewModel: viewModel!, uniqueIdentifier: index, url: imageURL!, actorFetchType: fetchType, completionHandler: { (identifier: Int?, fetchType: ActorFetchType, error: Error?) -> Void in
                
                if error == nil {
                    
                    if let identifier = identifier {
                        self.tableView?.reloadRows(at: [IndexPath.init(row: identifier, section: section)], with: .automatic)
                    }
                }
                
            })
            
            imageQueue.addOperation(imageOperation)
        }
        
    }
}


extension ActorSelectionViewController {
    
    @objc override func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        
        tableView?.fetchAllSelectedObjects()
        
        let certiSelectionVC: CertificationSelectionViewController = CertificationSelectionViewController(withMovieCriteria: self.movieCriteria)
        navigationController?.pushViewController(certiSelectionVC, animated: true)
        
    }
    
    
    @objc override func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        
        movieCriteria.removeAllActors()
        super.leftBarButtonTapped(sender)
    }
    
}




