//
//  PaginatedAPIHandler.swift
//  MovieNight
//
//  Created by Bharath on 06/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class PaginatedAPIHandler {
    
    private(set) var allPaginatedData: [PaginatedAPIData] = []
    var apiDataActive: PaginatedAPIData? = nil
    
    
    init(withPaginatedDataList list: [PaginatedAPIData]) {
        apiDataActive = list.first
        updatePaginatedData(withList: list)
    }
    
    convenience init(withPaginatedData data: PaginatedAPIData) {
        self.init(withPaginatedDataList: [data])
    }
    
    func updatePaginatedData(withList apiData: [PaginatedAPIData]) {
        allPaginatedData = apiData
    }
    
    func addPaginatedData(_ data: PaginatedAPIData) {
        allPaginatedData.append(data)
    }
    
    func removePaginatedData(atIndex index: Int) {
        if allPaginatedData.count > index {
            allPaginatedData.remove(at: index)
        }
    }
    
    
    func triggerAPIRequest() {
        //Sub classes to override and make respective API requests.
    }
    
    
    deinit {
        apiDataActive = nil
    }
}



extension PaginatedAPIHandler {
    
    var maxLimitReached: Bool {
        
        if let apiDataActive = apiDataActive {
            if let limit = apiDataActive.maxPageLimit {
                return apiDataActive.page >= limit
            }
            else {
                return false
            }
        }
        else {
            return true
        }
    }
}
