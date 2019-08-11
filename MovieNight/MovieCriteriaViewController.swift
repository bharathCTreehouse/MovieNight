//
//  MovieCriteriaViewController.swift
//  MovieNight
//
//  Created by Bharath on 05/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum BarButtonType {
    case custom (withTitle: String, titleColor: UIColor, style: UIBarButtonItem.Style, target: Any?, action: Selector?)
    case system (UIBarButtonItem.SystemItem, titleColor: UIColor, target: Any?, action: Selector?)
}


protocol MovieCriteriaNavigationItemConfigurer {
     var rightNavigationBarButtonItemConfig: BarButtonType? { get }
     var leftNavigationBarButtonItemConfig: BarButtonType? { get }
}


protocol MovieCriteriaNavigationItemTitleConfigurer {
    var titleString: String? { get }
    var navigationTitleView: UIView? { get }
}


class MovieCriteriaViewController: UIViewController, MovieCriteriaNavigationItemConfigurer, MovieCriteriaNavigationItemTitleConfigurer {
    
    var movieCriteria: MovieCriteria
    
    
    var rightNavigationBarButtonItemConfig: BarButtonType? {
        return BarButtonType.custom(withTitle: "Next", titleColor: UIColor.white, style: .plain, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    var leftNavigationBarButtonItemConfig: BarButtonType? {
        return BarButtonType.custom(withTitle: "Back", titleColor: UIColor.white, style: .plain, target: self, action: #selector(leftBarButtonTapped(_:)))
    }
    
    
    var titleString: String? {
        return nil
    }
    
    var navigationTitleView: UIView? {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .white)
        activityView.startAnimating()
        return activityView
    }
    
    
    init(withMovieCriteria criteria: MovieCriteria) {
        movieCriteria = criteria
        super.init(nibName: nil, bundle:nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        movieCriteria = MovieCriteria(withGenres: [], actors: nil, certifications: nil)
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRightNavigationBarButtonItem()
        setupLeftNavigationBarButtonItem()
    }
    
    
    func setupRightNavigationBarButtonItem() {
    navigationItem.setupRightNavigationBarButtonItem(usingConfigData: rightNavigationBarButtonItemConfig)
    }
    
    
    func setupLeftNavigationBarButtonItem() {
    navigationItem.setupLeftNavigationBarButtonItem(usingConfigData: leftNavigationBarButtonItemConfig)
    }
    
    
    func alertActionTapped(atIndex indexOfAlertAction: Int?) {
        //Subclasses to override and perform customized work on alert action tap.
    }
}


extension MovieCriteriaViewController {
    
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        //Subclasses will override and push the next view controller accordingly.
    }
    
    @objc func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}



extension MovieCriteriaViewController {
    
    func activateNavigationItemTitle() {
        navigationItem.configureTitle(forType: .title(titleString))
    }
    
    func activateNavigationItemTitleView() {
        navigationItem.configureTitle(forType: .view(navigationTitleView))
    }
}


extension MovieCriteriaViewController {
    
    func showAlertController(withTitle title: String?, message: String?, actionTitles: [String]) {
        
        MovieNightAlertViewController.displayAlertController(onViewController: self, withTitle: title, message: message, actionTitles: actionTitles, buttonActionCompletion: { [unowned self] (actionIndex: Int?) -> Void in
            
                self.alertActionTapped(atIndex: actionIndex)
        })
        
    }
}
