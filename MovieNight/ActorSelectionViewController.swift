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
    
    let searchSectionInfo: TableViewSectionDetail = TableViewSectionDetail(withHeader: TableViewSection.header(.title("Search results")), footer: TableViewSection.footer(.view(UIView.init(), 40.0)), identifier: 0)
    
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
        
        
        tableView = MultipleOptionSelectionTableView(withData: [searchSectionInfo: searchedActorsViewModel, popularSectionInfo: popularActorsViewModel], selectionHandler: { [unowned self] (selectedIndexes: [IndexPath]) -> Void in
            
            let searchResultIndexPaths: [IndexPath] = selectedIndexes.filter({ return $0.section == 0 })
            if searchResultIndexPaths.isEmpty == false {
                let selectedActors: [Actor] = searchResultIndexPaths.compactMap({ return self.searchedActors[$0.row] })
                self.movieCriteria.addActors(selectedActors)
            }
            
            let popularIndexPaths: [IndexPath] = selectedIndexes.filter({ return $0.section == 1 })
            if popularIndexPaths.isEmpty == false {
                let selectedActors: [Actor] = popularIndexPaths.compactMap({ return self.popularActors[$0.row] })
                self.movieCriteria.addActors(selectedActors)
            }
            
        })
        
        self.view.addSubview(tableView!)
        tableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView!.topAnchor.constraint(equalTo: searchBar!.bottomAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
    func fetchAllPopularActors() {
        
        let movieNightClient: MovieNightAPI = MovieNightAPI()
        
        movieNightClient.fetchAllPopularActors(withEndPoint: Endpoint.fetchPopularActors, completionHandler: { [unowned self] (actors: [Actor]?, error: Error?) -> Void in
            
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
    
}
