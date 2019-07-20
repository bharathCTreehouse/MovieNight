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
    var contentImage: UIImage? { get }
}



class MultipleOptionSelectionTableView: UITableView {
    
    var tableViewDataSource: MultipleOptionSelectionTableViewDataSource? = nil
    var selectionCompletionHandler: (([String]) -> Void)? = nil
    
    
    
    init(withData data: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]], tableViewRowHeight: CGFloat = UITableView.automaticDimension, selectionHandler: @escaping (([String]) -> Void)) {
        
        selectionCompletionHandler =  selectionHandler
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        
        tableViewDataSource = MultipleOptionSelectionTableViewDataSource(withData: data, tableView: self)
        self.dataSource = tableViewDataSource
        self.delegate = tableViewDataSource
        estimatedRowHeight = 65.0
        rowHeight = tableViewRowHeight
    }
    
    
    func update(withData data: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]]) {
        
        tableViewDataSource?.update(withData: data)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func fetchAllSelectedObjects() {
        let objectIDs: [String]? = tableViewDataSource?.allSelectedObjectIDs()
        if let objectIDs = objectIDs {
            selectionCompletionHandler?(objectIDs)
        }
    }
    
    
    
    deinit {
        tableViewDataSource = nil
        selectionCompletionHandler = nil
    }
    
}
