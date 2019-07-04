//
//  ViewController.swift
//  MovieNight
//
//  Created by Bharath on 24/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var backgroundMovieImageView: UIImageView!
    @IBOutlet var firstPersonCriteriaSelectionButton: UIButton!
    @IBOutlet var secondPersonCriteriaSelectionButton: UIButton!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backgroundMovieImageView.sizeToFit()
    }
    
    
    @IBAction func firstPersonCriteriaSelectionButtonTapped(sender: UIButton) {
        
        let movieNightAPI: MovieNightAPI = MovieNightAPI()
        
        movieNightAPI.fetchAllGenres(withEndPoint: Endpoint.fetchGenre, completionHandler: { [unowned self] (allGenres: [Genre]?, error: Error?) -> () in
            
            if let error = error {
                print("ERROR: \(error)")
            }
            else {
                if let allGenres =  allGenres {
                    let genreVC: GenreSelectionViewController = GenreSelectionViewController(withGenres: allGenres)
                    self.navigationController?.pushViewController(genreVC, animated: true)
                }
            }
        })
        
    }
    
    
    @IBAction func secondPersonCriteriaSelectionButtonTapped(sender: UIButton) {

    }
    
    
    
    deinit {
        backgroundMovieImageView = nil
        firstPersonCriteriaSelectionButton = nil
        secondPersonCriteriaSelectionButton = nil
    }
    
    
   
}

