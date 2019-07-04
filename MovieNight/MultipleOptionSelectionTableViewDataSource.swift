//
//  MultipleOptionSelectionTableViewDataSource.swift
//  MovieNight
//
//  Created by Bharath on 02/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit



class MultipleOptionSelectionTableViewDataSource: NSObject, UITableViewDataSource {
    
    let data: [MultipleOptionSelectionDisplayable]
    weak var tableView: UITableView? = nil
    
    
    init(withData data: [MultipleOptionSelectionDisplayable], tableView: UITableView) {
        self.data = data
        self.tableView = tableView
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        let data: MultipleOptionSelectionDisplayable = self.data[indexPath.row]

        
        if cell.accessoryView == nil {
            
            let selectionSwitch: UISwitch = UISwitch.init()
            selectionSwitch.addTarget(self, action: #selector(selectionSwitchToggled(_:)), for: .valueChanged)
            selectionSwitch.tag = indexPath.row
            cell.accessoryView = selectionSwitch
            selectionSwitch.onTintColor = data.selectionDetail.selectionColor
            selectionSwitch.setOn(data.selectionDetail.isSelected, animated: true)
        }
        
        cell.textLabel?.text = data.textDetail.text
        cell.textLabel?.font = data.textDetail.font
        cell.textLabel?.textColor = data.textDetail.color
        
        return cell
        
    }
    
    
    
    
    @objc func selectionSwitchToggled(_ sender: UISwitch) {
        
        let data: MultipleOptionSelectionDisplayable = self.data[sender.tag]
        data.selectionDetail.isSelected = sender.isOn
        
    }
    
    
    
    func allSelectedObjectIndexes() -> [Int] {
        return [4,2,3]
    }
    
    
    
    deinit {
        tableView = nil
    }
    
 
}
