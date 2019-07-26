//
//  ViewController.swift
//  MovieNight
//
//  Created by Bharath on 24/06/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundMovieImageView: UIImageView!
    @IBOutlet weak var firstPersonCriteriaSelectionButton: UIButton!
    @IBOutlet weak var secondPersonCriteriaSelectionButton: UIButton!
    @IBOutlet weak var viewResultsButton: UIButton!

    let movieCriteria: MovieCriteria = MovieCriteria(withGenres: [], actors: nil, certifications: nil)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundMovieImageView.sizeToFit()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let nameOfImage: String = self.movieCriteria.criteriaSelectionStatus.imageName
        let image: UIImage? = UIImage(named: nameOfImage)
        
        if self.movieCriteria.currentPerson == .unknown {
            firstPersonCriteriaSelectionButton.setImage(image, for: .normal)
            secondPersonCriteriaSelectionButton.setImage(image, for: .normal)
        }
        else {
            
            if self.movieCriteria.currentPerson == .first {
                firstPersonCriteriaSelectionButton.setImage(image, for: .normal)
            }
            else if self.movieCriteria.currentPerson == .second {
                secondPersonCriteriaSelectionButton.setImage(image, for: .normal)
            }
        }
        
        let enabled: Bool =  self.movieCriteria.completionCount > 0
        viewResultsButton.changeEnabledState(to: enabled, alphaChangeStatus: (enabled == true) ? AlphaChangeNeeded.yes(1.0) : AlphaChangeNeeded.yes(0.3))
    }
    
    
    
    @IBAction func firstPersonCriteriaSelectionButtonTapped(sender: UIButton) {
        self.movieCriteria.updateCurrentPerson(with: .first)
        moveToNextCriteriaSelectionScreen()
    }
    
    
    @IBAction func secondPersonCriteriaSelectionButtonTapped(sender: UIButton) {
        self.movieCriteria.updateCurrentPerson(with: .second)
        moveToNextCriteriaSelectionScreen()
    }
    
    
    
    func moveToNextCriteriaSelectionScreen() {
        
        
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
                    self.movieCriteria.changeSelectionStatus(to: .inProgress)
                    let genreVC: GenreSelectionViewController = GenreSelectionViewController(withGenres: allGenres, movieCriteria: self.movieCriteria)
                    self.navigationController?.pushViewController(genreVC, animated: true)
                }
            }
        })
        
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
        viewResultsButton = nil
    }
}



extension ViewController {
    
    @IBAction func viewResultsButtonTapped(_ sender: UIButton) {
        
        let movieListVC: MovieListViewController = MovieListViewController(withMovieCriteria: self.movieCriteria)
        let navController: UINavigationController = UINavigationController(rootViewController: movieListVC)
        
        present(navController, animated: true, completion: nil)
        
    }
    
}


