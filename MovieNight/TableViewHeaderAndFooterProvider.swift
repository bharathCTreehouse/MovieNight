//
//  TableViewHeaderAndFooterProvider.swift
//  MovieNight
//
//  Created by Bharath on 05/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol TableViewHeaderAndFooterProvider: class {
    var tableViewHeader: UIView? { get }
    var tableViewFooter: UIView? { get }
}

extension TableViewHeaderAndFooterProvider {
    var tableViewHeader: UIView? {
        return nil
    }
    var tableViewFooter: UIView? {
        return nil
    }
}
