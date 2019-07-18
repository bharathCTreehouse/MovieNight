//
//  ActorSelectionViewController.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ActorSelectionViewController: MovieNightViewController {
    
    var searchBar: UISearchBar? = nil
    var tableView: MultipleOptionSelectionTableView? = nil
    let apiGroup: DispatchGroup = DispatchGroup.init()
    var imageConfiguration: ImageConfiguration? = nil


    var popularActorsViewModel: [MultipleOptionSelectionDisplayable] = [] {
        didSet {
             self.tableView?.update(withData: [self.popularSectionInfo: self.popularActorsViewModel, self.searchSectionInfo: self.searchedActorsViewModel])
            self.tableView?.reloadSections(IndexSet.init(integer: 1), with: .automatic)
        }
    }
    var searchedActorsViewModel: [MultipleOptionSelectionDisplayable] = [] {
        didSet {
            
            self.tableView?.update(withData: [self.popularSectionInfo: self.popularActorsViewModel, self.searchSectionInfo: self.searchedActorsViewModel])
            self.tableView?.reloadSections(IndexSet.init(integer: 0), with: .automatic)

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
        
        apiGroup.enter()
        apiGroup.enter()
        
        apiGroup.notify(queue: DispatchQueue.init(label: "apiQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .never, target: nil), execute: { [unowned self] () -> Void in
            
            let imageQueue: OperationQueue = OperationQueue.init()
            
            for (index, data) in self.popularActorsViewModel.enumerated() {
                
                let viewModel: ActorListViewModel? = data as? ActorListViewModel
                if viewModel == nil {
                    continue
                }
                let imageURL: URL? = self.imageConfiguration?.urlFor(imagePath: viewModel!.actor.profilePath, withImageCategory: ImageCategory.profile(.original))
                if imageURL == nil {
                    continue
                }
                
                let imageOperation: ActorListImageOperation =  ActorListImageOperation(withActorListViewModel: viewModel!, uniqueIdentifier: index, url: imageURL!, actorFetchType: .popular, completionHandler: { (identifier: Int?, fetchType: ActorFetchType, error: Error?) -> Void in
                    
                    if error == nil {
                        
                        if let identifier = identifier {
                            self.tableView?.reloadRows(at: [IndexPath.init(row: identifier, section: 1)], with: .automatic)
                        }
                    }
                    
                })
                
                imageQueue.addOperation(imageOperation)
            }
            
        })
        
        fetchAllPopularActors()
        fetchImageConfiguration()
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
        
        
        tableView = MultipleOptionSelectionTableView(withData: [searchSectionInfo: searchedActorsViewModel, popularSectionInfo: popularActorsViewModel], selectionHandler: { [unowned self] (selectedIDs: [String]) -> Void in
            
            self.movieCriteria.addActors(withIDs_: selectedIDs)
            
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
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
            
            self.apiGroup.leave()
        })
        
    }
    
    
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        self.movieCriteria.removeAllActors()
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func nextButtonTapped(_ sender: UIBarButtonItem) {
        tableView?.fetchAllSelectedObjects()
    }
    
    
    
    func fetchImageConfiguration() {
        
        let movieAPI: MovieNightAPI = MovieNightAPI()
        
        movieAPI.fetchImageConfiguration(withEndPoint: Endpoint.fetchImageConfiguration, completionHandler: { [unowned self] (imgConfig: ImageConfiguration?, error: Error?) -> Void in
            
            if let error = error {
                print("Error: \(error)")
            }
            else {
                self.imageConfiguration = imgConfig
            }
            
            self.apiGroup.leave()
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




