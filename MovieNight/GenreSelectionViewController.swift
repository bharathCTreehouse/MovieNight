//
//  GenreSelectionViewController.swift
//  MovieNight
//
//  Created by Bharath on 04/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class GenreSelectionViewController: MovieNightViewController {
    
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
        
        let sectionInfo: TableViewSectionInfo = TableViewSectionInfo(title: "", ID: 0)
        
        tableView = MultipleOptionSelectionTableView(withData: [sectionInfo: allGenreViewModels], selectionHandler: { [unowned self] (selectedIndexes: [IndexPath]) -> Void in
            
            let selectedGenres: [Genre] = selectedIndexes.compactMap({ return self.allGenres[$0.row] })
            self.movieCriteria.genres.append(contentsOf: selectedGenres)
            
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
        
        self.title = "Select genres"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped(_:)))
         self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    
    
    func prepareData() {
        allGenreViewModels = allGenres.compactMap({ return GenreListViewModel(withGenre: $0)} )
    }
    
    
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func nextButtonTapped(_ sender: UIBarButtonItem) {
        tableView?.fetchAllSelectedObjects()
    }
    
    
    deinit {
        tableView = nil
    }
    
}
