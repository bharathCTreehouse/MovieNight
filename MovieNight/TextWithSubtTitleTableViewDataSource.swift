//
//  TextWithSubtTitleTableViewDataSource.swift
//  MovieNight
//
//  Created by Bharath Chandrashekar on 28/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol TextWithSubtTitleDisplayable: UniquelyIdentifiable {
    var textAttribute: TextWithAttribute { get }
    var subTitleTextAttribute: TextWithAttribute { get }
    var contentImage: UIImage?{ get }
}




class TextWithSubtTitleTableViewDataSource: NSObject, UITableViewDataSource {
    
    var data: [TextWithSubtTitleDisplayable] = []
    weak var tableView: UITableView? = nil
    
    
    init(withData data: [TextWithSubtTitleDisplayable], tableView: UITableView) {
        self.data = data
        self.tableView = tableView
    }
    
    
    func update(withData data: [TextWithSubtTitleDisplayable]) {
        self.data = data
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        let currentData: TextWithSubtTitleDisplayable = data[indexPath.row]
        cell?.textLabel?.text = currentData.textAttribute.text
        cell?.textLabel?.font = currentData.textAttribute.font
        cell?.textLabel?.textColor = currentData.textAttribute.color
        
        cell?.detailTextLabel?.text = currentData.subTitleTextAttribute.text
        cell?.detailTextLabel?.font = currentData.subTitleTextAttribute.font
        cell?.detailTextLabel?.textColor = currentData.subTitleTextAttribute.color
        
        cell?.imageView?.image = currentData.contentImage
        
        return cell!
        
    }
    
    
    
    deinit {
        tableView = nil
    }
    
    
}
