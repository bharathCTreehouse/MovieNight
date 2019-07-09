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
    
    var tableView: MultipleOptionSelectionTableView? = nil

    var popularActorsViewModel: [MultipleOptionSelectionDisplayable] = [] {
        didSet {
            
        }
    }
    
    
    var searchedActorsViewModel: [MultipleOptionSelectionDisplayable] = [] {
        didSet {
            
        }
    }
    
    var popularActors: [Actor] = []
    var searchedActors: [Actor] = []
    
    let searchSectionInfo: TableViewSectionInfo = TableViewSectionInfo(title: "Search result", ID: 0)
    let popularSectionInfo: TableViewSectionInfo = TableViewSectionInfo(title: "Popular actors", ID: 1)
    
    
    
    override init(withMovieCriteria criteria: MovieCriteria) {
        super.init(withMovieCriteria: criteria)
        fetchAllPopularActors()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func loadView() {
        
        self.view = UIView()
        
       
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
        tableView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
    func fetchAllPopularActors() {
        
        let movieNightClient: MovieNightAPI = MovieNightAPI()
        
        movieNightClient.fetchAllPopularActors(withEndPoint: Endpoint.fetchPopularActors, completionHandler: { (actors: [Actor]?, error: Error?) -> Void in
            
            if let error = error {
                print("Error: \(error)")
            }
            else {
                if let actors = actors {
                    print("Actors: \(actors)")
                }
            }
        })
        
    }
    
}
