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
    
    let movieCriteria: MovieCriteria = MovieCriteria(withGenres: [], actors: nil, certification: nil)

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backgroundMovieImageView.sizeToFit()
    }
    
    
    
    @IBAction func firstPersonCriteriaSelectionButtonTapped(sender: UIButton) {
        
        
        let appDelegate: AppDelegate? =  UIApplication.shared.delegate as? AppDelegate
        
        if appDelegate?.imageConfiguration == nil {
            fetchImageConfiguration()
        }
        
        MovieNightAPI().fetchAllGenres(withEndPoint: Endpoint.fetchGenre, completionHandler: { [unowned self] (allGenres: [Genre]?, error: Error?) -> () in
            
            if let error = error {
                print("ERROR: \(error)")
            }
            else {
                if let allGenres =  allGenres {
                    let genreVC: GenreSelectionViewController = GenreSelectionViewController(withGenres: allGenres, movieCriteria: self.movieCriteria)
                    self.navigationController?.pushViewController(genreVC, animated: true)
                }
            }
        })
        
    }
    
    
    @IBAction func secondPersonCriteriaSelectionButtonTapped(sender: UIButton) {
        
        let appDelegate: AppDelegate? =  UIApplication.shared.delegate as? AppDelegate
        
        if appDelegate?.imageConfiguration == nil {
            fetchImageConfiguration()
        }
    }
    
    
    
    func fetchImageConfiguration() {
        
        let movieAPI: MovieNightAPI = MovieNightAPI()
        
        movieAPI.fetchImageConfiguration(withEndPoint: Endpoint.fetchImageConfiguration, completionHandler: { (imgConfig: ImageConfiguration?, error: Error?) -> Void in
            
            if let error = error {
                print("Error: \(error)")
            }
            else {
                let appDelegate: AppDelegate? =  UIApplication.shared.delegate as? AppDelegate
                appDelegate?.imageConfiguration = imgConfig
            }
            
        })
    }
    
    
    
    deinit {
        backgroundMovieImageView = nil
        firstPersonCriteriaSelectionButton = nil
        secondPersonCriteriaSelectionButton = nil
    }
    
    
   
}

