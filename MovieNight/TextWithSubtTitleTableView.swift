//
//  TextWithSubtTitleTableView.swift
//  MovieNight
//
//  Created by Bharath Chandrashekar on 28/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class TextWithSubtTitleTableView: UITableView {
    
    var dataSourceForTableView: TextWithSubtTitleTableViewDataSource? = nil
    
    
    init(withData data: [TextWithSubtTitleDisplayable]) {
        
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        dataSourceForTableView = TextWithSubtTitleTableViewDataSource(withData: data, tableView: self)
        dataSource = dataSourceForTableView
        estimatedRowHeight = 60.0
        rowHeight = 94.0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func update(withData data: [TextWithSubtTitleDisplayable]) {
        dataSourceForTableView?.update(withData: data)
        reloadData()
    }
    
    
    deinit {
        dataSourceForTableView = nil
    }
}
