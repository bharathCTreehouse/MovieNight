//
//  TextWithSubtTitleTableView.swift
//  MovieNight
//
//  Created by Bharath Chandrashekar on 28/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol TextWithSubTitleTableViewActionResponder: class {
    func accessoryInfoButtonTapped(atIndexPath indexPath: IndexPath)
    func tableViewCellTapped(atIndexPath indexPath: IndexPath)
}


class TextWithSubtTitleTableView: UITableView {
    
    var dataSourceForTableView: TextWithSubtTitleTableViewDataSource? = nil
    weak private(set) var tableViewActionResponder: TextWithSubTitleTableViewActionResponder? = nil
    weak var headerFooterDataSource: TableViewHeaderAndFooterProvider? = nil
    
    
    init(withData data: [TextWithSubtTitleDisplayable], tableViewActionResponder responder: TextWithSubTitleTableViewActionResponder?, headerFooterDataSource: TableViewHeaderAndFooterProvider?) {
        
        tableViewActionResponder = responder
        self.headerFooterDataSource = headerFooterDataSource
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        dataSourceForTableView = TextWithSubtTitleTableViewDataSource(withData: data, accessoryActionHandler: { [unowned self] (idxPath: IndexPath) -> Void in
            
            self.tableViewActionResponder?.accessoryInfoButtonTapped(atIndexPath: idxPath)
            
        }, cellTapHandler: { (indexPath: IndexPath) -> Void in
            self.tableViewActionResponder?.tableViewCellTapped(atIndexPath: indexPath)
        })
        dataSource = dataSourceForTableView
        delegate = dataSourceForTableView
        estimatedRowHeight = 60.0
        rowHeight = 94.0
        reloadTableHeaderView()
        reloadTableFooterView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func update(withData data: [TextWithSubtTitleDisplayable]) {
        dataSourceForTableView?.update(withData: data)
        reloadData()
        reloadTableHeaderView()
        reloadTableFooterView()
    }
    
    
    func reloadTableFooterView() {
        self.tableFooterView = self.headerFooterDataSource?.tableViewFooter
    }
    
    
    func reloadTableHeaderView() {
        self.tableHeaderView = self.headerFooterDataSource?.tableViewHeader
    }
    
    
    deinit {
        dataSourceForTableView = nil
    }
}



