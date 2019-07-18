//
//  ActorListImageOperation.swift
//  MovieNight
//
//  Created by Bharath on 19/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum ActorFetchType {
    
    case popular
    case searched
    case latest
    case unknown
}


class ActorListImageOperation: Operation {
    
    private let actorListViewModel: ActorListViewModel
    private var identifier: Int?
    private let imageURL: URL
    private let fetchType: ActorFetchType
    private let completionHandler: ((Int?,ActorFetchType, Error?) -> Void)
  
    
    init(withActorListViewModel viewModel: ActorListViewModel, uniqueIdentifier: Int? = nil, url: URL, actorFetchType: ActorFetchType = .unknown, completionHandler handler: @escaping ((Int?,ActorFetchType, Error?) -> Void)) {
        
        actorListViewModel = viewModel
        identifier = uniqueIdentifier
        imageURL = url
        fetchType = actorFetchType
        completionHandler = handler
    }
    
    
    override func main() {
        
        do {
            let data: Data = try Data(contentsOf: imageURL)
            let image: UIImage? = UIImage(data: data)
            self.actorListViewModel.profileImage = image
            
            DispatchQueue.main.async {  () -> Void in
                self.completionHandler(self.identifier, self.fetchType, nil)
            }
        }
        catch let fetchError {
            DispatchQueue.main.async {  () -> Void in
                self.completionHandler(self.identifier, self.fetchType, fetchError)
            }
        }
    }
    
    
    deinit {
        identifier = nil
    }
    
}
