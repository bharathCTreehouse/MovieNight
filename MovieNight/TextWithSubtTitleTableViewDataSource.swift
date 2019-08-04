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
    var contentImage: UIImage? { get }
    var moreInfoButtonAttribute: ButtonAttribute? { get }
}




class TextWithSubtTitleTableViewDataSource: NSObject, UITableViewDataSource {
    
    var data: [TextWithSubtTitleDisplayable] = []
    var accessoryViewTapHandler: ((IndexPath) -> Void)? = nil
    var cellTapHandler: ((IndexPath) -> Void)? = nil

    
    
    init(withData data: [TextWithSubtTitleDisplayable], accessoryActionHandler: ((IndexPath) -> Void)?, cellTapHandler: ((IndexPath) -> Void)?) {
        
        self.data = data
        accessoryViewTapHandler = accessoryActionHandler
        self.cellTapHandler =  cellTapHandler
        super.init()
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
        cell!.textLabel?.numberOfLines = 0
        cell!.detailTextLabel?.numberOfLines = 0
        
        let currentData: TextWithSubtTitleDisplayable = data[indexPath.row]
        
        if let buttonAttr = currentData.moreInfoButtonAttribute {
            
            let accessoryButton: UIButton = UIButton(type: buttonAttr.type)
            accessoryButton.tag = indexPath.row
            accessoryButton.setTitle(buttonAttr.title, for: .normal)
            accessoryButton.addTarget(self, action: #selector(accessoryViewButtonTapped(_:)), for: .touchUpInside)
        accessoryButton.setTitleColor(buttonAttr.titleColorForNormalState, for: .normal)
            
            cell!.accessoryView = accessoryButton
        }
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
        accessoryViewTapHandler = nil
        cellTapHandler = nil
    }
    
    
}

extension TextWithSubtTitleTableViewDataSource: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        cellTapHandler?(indexPath)
    }
    
    
    @objc func accessoryViewButtonTapped(_ sender: UIButton) {
        accessoryViewTapHandler?(IndexPath(row: sender.tag, section: 0))
    }
    
}
