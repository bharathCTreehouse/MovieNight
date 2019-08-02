//
//  MovieBackdropView.swift
//  MovieNight
//
//  Created by Bharath on 31/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum MovieBackdropType {
    case loading
    case image(UIImage?)
    case noImagePresent
}


class MovieBackdropView: UIView {
    
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var noImageLabel: UILabel!
    weak var backdropView: UIView? = nil
    @IBOutlet weak var backgroundView: UIView!



    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backdropView = Bundle.main.loadNibNamed("MovieBackdropView", owner: self, options: nil)?.first as? UIView
        backdropView!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backdropView!)
        backdropView!.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backdropView!.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backdropView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backdropView!.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func updateBackdropView(withType type: MovieBackdropType) {
        

        switch type {
            
            case .loading: loadingActivityView.isHidden = false
                           loadingActivityView.startAnimating()
                           backdropImageView.isHidden = true
                           noImageLabel.isHidden = true
            
            case .image(let img): loadingActivityView.stopAnimating()
                              backdropImageView.isHidden = false
                              backdropImageView.image = img
                              noImageLabel.isHidden = true
            
            
            case .noImagePresent: loadingActivityView.stopAnimating()
                              backdropImageView.isHidden = true
                              noImageLabel.isHidden = false
        }
    }
    
    
    deinit {
        loadingActivityView = nil
        backdropImageView = nil
        noImageLabel = nil
        backdropView = nil
        backgroundView = nil
    }
}

