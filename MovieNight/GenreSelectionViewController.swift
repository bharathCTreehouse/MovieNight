//
//  GenreSelectionViewController.swift
//  MovieNight
//
//  Created by Bharath on 04/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class GenreSelectionViewController: MovieCriteriaViewController {
    
    var tableView: MultipleOptionSelectionTableView? = nil
    let allGenres: [Genre]
    var allGenreViewModels: [MultipleOptionSelectionDisplayable] = []
    
    
    init(withGenres genres: [Genre], movieCriteria: MovieCriteria) {
        allGenres = genres
        super.init(withMovieCriteria: movieCriteria)
        prepareData()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        allGenres = []
        super.init(coder: aDecoder)
    }
    
    
    override func loadView() {
        
        self.view = UIView()
        
        let sectionInfo: TableViewSectionDetail = TableViewSectionDetail(withHeader: nil, footer: nil, identifier: 0)
        
        tableView = MultipleOptionSelectionTableView(withData: [sectionInfo: allGenreViewModels], selectionHandler: { [unowned self] (selectedIDs: [String]) -> Void in
            
            self.movieCriteria.addGenres(withIDs: selectedIDs)
            let actorSelectionVC: ActorSelectionViewController = ActorSelectionViewController(withMovieCriteria: self.movieCriteria)
            self.navigationController?.pushViewController(actorSelectionVC, animated: true)
        })
        
        self.view.addSubview(tableView!)
        tableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        activateNavigationItemTitle()
    }
    
    
    func prepareData() {
        allGenreViewModels = allGenres.compactMap({ return GenreListViewModel(withGenre: $0)} )
    }
    
    
    override var titleString: String? {
        return "Select genres"
    }
    
    
    deinit {
        tableView = nil
    }
    
}



extension GenreSelectionViewController {
    
    @objc override func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        
        tableView?.fetchAllSelectedObjects()

    }
    
    
    @objc override func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        
        self.movieCriteria.removeAllGenres()
        self.movieCriteria.changeSelectionStatus(to: .unInitiated)
        super.leftBarButtonTapped(sender)
        
    }
}
