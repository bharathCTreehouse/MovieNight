//
//  MultipleOptionSelectionTableView.swift
//  MovieNight
//
//  Created by Bharath on 01/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol UniquelyIdentifiable {
    var ID: String { get }
}


protocol MultipleOptionSelectionDisplayable:  UniquelyIdentifiable {
    var textDetail: TextWithAttribute { get }
    var selectionDetail: SelectionAttribute { set get }
}



class MultipleOptionSelectionTableView: UITableView {
    
    var tableViewDataSource: MultipleOptionSelectionTableViewDataSource? = nil
    var selectionCompletionHandler: (([IndexPath]) -> Void)? = nil
    
    
    
    init(withData data: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]], selectionHandler: @escaping (([IndexPath]) -> Void)) {
        
        selectionCompletionHandler =  selectionHandler
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        
        tableViewDataSource = MultipleOptionSelectionTableViewDataSource(withData: data, tableView: self)
        self.dataSource = tableViewDataSource
        self.delegate = tableViewDataSource
        estimatedRowHeight = 65.0
        rowHeight = UITableView.automaticDimension
    }
    
    
    func update(withData data: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]]) {
        
        tableViewDataSource?.update(withData: data)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func fetchAllSelectedObjects() {
        let indexes: [IndexPath]? = tableViewDataSource?.allSelectedObjectIndexes()
        if let indexes = indexes {
            selectionCompletionHandler?(indexes)
        }
    }
    
    
    
    deinit {
        tableViewDataSource = nil
        selectionCompletionHandler = nil
    }
    
}
