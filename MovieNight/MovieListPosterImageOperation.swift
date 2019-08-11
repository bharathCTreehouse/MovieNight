//
//  MovieListPosterImageOperation.swift
//  MovieNight
//
//  Created by Bharath Chandrashekar on 28/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit



class MovieListPosterImageOperation: Operation {
    
    private var completionHandler: ((Int?,Error?) -> Void)?
    private let url: URL
    private let movieListViewModel: MovieListViewModel
    private var identifier: Int?

    
    init(withURL url: URL, identifier: Int? = nil, movieListViewModel: MovieListViewModel, completionHandler handler: ((Int?,Error?) -> Void)?) {
        
        self.url = url
        self.identifier = identifier
        self.movieListViewModel = movieListViewModel
        completionHandler = handler
    }
    
    
    override func main() {
        
        do {
            if isCancelled == true {
                return
            }
            let imageData: Data = try Data(contentsOf: self.url)
            self.movieListViewModel.update(posterImage: UIImage(data: imageData))
            
            DispatchQueue.main.async {
                if self.isCancelled == true {
                    return
                }
                self.completionHandler?(self.identifier, nil)
            }
        }
        catch let imageError {
            DispatchQueue.main.async {
                if self.isCancelled == true {
                    return
                }
                self.completionHandler?(self.identifier, imageError)
            }
        }
        
    }
    
    
    deinit {
        completionHandler = nil
        identifier = nil
    }
    
}
