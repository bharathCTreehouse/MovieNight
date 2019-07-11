//
//  TableViewSectionInfo.swift
//  MovieNight
//
//  Created by Bharath on 08/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum TableViewSection {
    case header(TableViewSectionDisplay)
    case footer(TableViewSectionDisplay)
}


enum TableViewSectionDisplay {
    case title(String)
    case view(UIView, CGFloat)
}


/*struct TableViewSectionInfo: Hashable {
    
    let title: String
    let ID: Int
    
}*/


class TableViewSectionIdentifier: Hashable {
    
    let ID: Int
    
    init(withID id: Int) {
        ID = id
    }
    
    static func == (lhs: TableViewSectionIdentifier, rhs: TableViewSectionIdentifier) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ID)
    }
}



class TableViewSectionDetail: TableViewSectionIdentifier {
    
    let sectionHeader: TableViewSection?
    let sectionFooter: TableViewSection?
    
    
    init(withHeader header: TableViewSection?, footer: TableViewSection?, identifier: Int) {
        sectionHeader = header
        sectionFooter = footer
        super.init(withID: identifier)
    }
    
}
