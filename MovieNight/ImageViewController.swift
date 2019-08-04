//
//  ImageViewController.swift
//  MovieNight
//
//  Created by Bharath on 04/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageToDisplay: UIImage? = nil
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let rightBarType: BarButtonType = BarButtonType.system(.done, titleColor: .white, target: self, action: #selector(doneButtonTapped(_:)))

    navigationItem.setupRightNavigationBarButtonItem(usingConfigData: rightBarType)
        
        imageView.image = imageToDisplay

    }
    
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        imageView = nil
        imageToDisplay = nil
    }
}
