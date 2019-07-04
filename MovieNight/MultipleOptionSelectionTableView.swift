//
//  MultipleOptionSelectionTableView.swift
//  MovieNight
//
//  Created by Bharath on 01/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol MultipleOptionSelectionDisplayable {
    var textDetail: TextWithAttribute { get }
    var selectionDetail: SelectionAttribute { get }
}



class MultipleOptionSelectionTableView: UITableView {
    
    var tableViewDataSource: MultipleOptionSelectionTableViewDataSource? = nil
    var selectionCompletionHandler: (([Int]) -> Void)? = nil
    
    
    
    init(withData data: [MultipleOptionSelectionDisplayable], selectionHandler: @escaping (([Int]) -> Void)) {
        
        selectionCompletionHandler =  selectionHandler
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        
        tableViewDataSource = MultipleOptionSelectionTableViewDataSource(withData: data, tableView: self)
        self.dataSource = tableViewDataSource
        estimatedRowHeight = 65.0
        rowHeight = UITableView.automaticDimension
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func fetchAllSelectedObjects() {
        let indexes: [Int]? = tableViewDataSource?.allSelectedObjectIndexes()
        if let indexes = indexes {
            selectionCompletionHandler?(indexes)
        }
    }
    
    
    
    deinit {
        tableViewDataSource = nil
        selectionCompletionHandler = nil
    }
    
}
