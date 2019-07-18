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
    
    var data: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]]
    weak var tableView: UITableView? = nil
    private var selectedObjectIDs: [String] = []
    
    
    init(withData data: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]], tableView: UITableView) {
        self.data = data
        self.tableView = tableView
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
    }
    
    
    func update(withData data: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]]) {
        self.data = data
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.keys.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let selectedMapperData: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == section })
        
        let detail: TableViewSectionDetail = selectedMapperData.keys.first!
        
        
        guard let sectionHeader = detail.sectionHeader else {
            return nil
        }
        
        switch sectionHeader {
            case .header(let sectionDisplay):
                switch (sectionDisplay) {
                    case .title(let headerTitle): return headerTitle
                    case .view(_, _): return nil
                }
            
            default: return nil
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        
        let selectedMapperData: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == section })
        
        let detail: TableViewSectionDetail = selectedMapperData.keys.first!
        
        
        guard let sectionFooter = detail.sectionFooter else {
            return nil
        }
        
        switch sectionFooter {
            case .footer(let sectionDisplay):
                switch (sectionDisplay) {
                    case .title(let footerTitle): return footerTitle
                    case .view(_, _): return nil
                }
            default: return nil
            
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let data: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == section })
        return data.values.first!.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        let selectedMapperData: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == indexPath.section })

        var data: MultipleOptionSelectionDisplayable = selectedMapperData.values.first![indexPath.row]

        
        var accessorySwitchView: AccessorySwitchView? = cell.accessoryView as? AccessorySwitchView
        
        if accessorySwitchView == nil {
            
            accessorySwitchView = AccessorySwitchView(withIndexPath: indexPath)
            cell.accessoryView = accessorySwitchView
            accessorySwitchView!.addTarget(self, action: #selector(selectionSwitchToggled(_:)), for: .valueChanged)
            accessorySwitchView!.onTintColor = data.selectionDetail.selectionColor
        }
        else {
            accessorySwitchView!.update(withIndexPath: indexPath)
        }
        accessorySwitchView!.setOn(data.selectionDetail.isSelected, animated: false)
        
        if accessorySwitchView!.isOn == false {
            if self.selectedObjectIDs.contains(data.ID) {
                data.selectionDetail.changeSelectedState(to: true)
                accessorySwitchView!.setOn(true, animated: false)
            }
        }
        
        cell.textLabel?.text = data.textDetail.text
        cell.textLabel?.font = data.textDetail.font
        cell.textLabel?.textColor = data.textDetail.color
        cell.imageView?.image = data.contentImage
        
        return cell
        
    }
    
    
    
    
    @objc func selectionSwitchToggled(_ sender: AccessorySwitchView) {
        
        let selectedMapperData: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == sender.indexPath.section })
        
        var data: MultipleOptionSelectionDisplayable = selectedMapperData.values.first![sender.indexPath.row]
        
        data.selectionDetail.changeSelectedState(to: sender.isOn)
        
        if sender.isOn == true {
            selectedObjectIDs.append(data.ID)
        }
        else {
            selectedObjectIDs.removeAll(where: { return $0 == data.ID })
        }
        
        
        for (key, value) in self.data {
            
            
            if key.ID != sender.indexPath.section {
                
                let filteredList: [MultipleOptionSelectionDisplayable] = value.filter({ return $0.ID == data.ID })
                
                if filteredList.isEmpty == false {
                    
                    var matchedData: MultipleOptionSelectionDisplayable = filteredList.first!
                    matchedData.selectionDetail.changeSelectedState(to: sender.isOn)
                    
                    let locationRow: Int = value.firstIndex(where: { return $0.ID == matchedData.ID})!
                    self.tableView?.reloadRows(at: [IndexPath.init(row: locationRow, section: key.ID)], with: .automatic)
                }
            }
        }
    }
    
    
    
    func allSelectedObjectIDs() -> [String] {
        return selectedObjectIDs
    }
    
    
    
    deinit {
        tableView = nil
    }
    
 
}



extension MultipleOptionSelectionTableViewDataSource: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let selectedMapperData: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == section })
        
        let detail: TableViewSectionDetail = selectedMapperData.keys.first!
        
        
        guard let sectionFooter = detail.sectionFooter else {
            return 0.0
        }
        
        
        switch sectionFooter {
            
            case .footer(let sectionDisplay):
                switch (sectionDisplay) {
                    case .view(_, let height): return height
                    default: return UITableView.automaticDimension
            }
            default: return 0.0
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        
        let selectedMapperData: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == section })
        
        let detail: TableViewSectionDetail = selectedMapperData.keys.first!
        
        guard let sectionFooter = detail.sectionFooter else {
            return nil
        }
        
        switch sectionFooter {
            
            case .footer(let sectionDisplay):
                switch (sectionDisplay) {
                    case .view(let viewToDisplay, _): return viewToDisplay
                    default: return nil
                }
            default: return nil
            
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let selectedMapperData: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == section })
        
        let detail: TableViewSectionDetail = selectedMapperData.keys.first!
        
        guard let sectionHeader = detail.sectionHeader else {
            return 0.0
        }
        
        switch sectionHeader {
            
            case .header(let sectionDisplay):
                switch (sectionDisplay) {
                    case .view(_, let height): return height
                    default: return UITableView.automaticDimension
                }
            default: return 0.0
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let selectedMapperData: [TableViewSectionDetail: [MultipleOptionSelectionDisplayable]] = self.data.filter({ return $0.key.ID == section })
        
        let detail: TableViewSectionDetail = selectedMapperData.keys.first!
        
        
        guard let sectionHeader = detail.sectionHeader else {
            return nil
        }
        
        switch sectionHeader {
            
            case .header(let sectionDisplay):
                switch (sectionDisplay) {
                    case .view(let viewToDisplay, _): return viewToDisplay
                    default: return nil
                }
            default: return nil
            
        }
    }
    
}
