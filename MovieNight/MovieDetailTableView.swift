//
//  MovieDetailTableView.swift
//  MovieNight
//
//  Created by Bharath on 02/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class MovieDetailTableView: UITableView {
    
    var detailViewModel: MovieDetailViewModel?
    
    init(withMovieDetailViewModel viewModel: MovieDetailViewModel) {
        detailViewModel = viewModel
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        estimatedRowHeight = 50.0
        rowHeight = UITableView.automaticDimension
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    deinit {
        detailViewModel = nil
    }
    
}


extension MovieDetailTableView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell!.selectionStyle = .none
        cell!.detailTextLabel?.numberOfLines = 0
        cell?.textLabel?.textColor = UIColor.gray
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        var displayAttribute: TextWithAttribute? = nil
        
        if indexPath.row == 0 {
            
            //Movie title
            displayAttribute = detailViewModel?.movieNameAttribute
            cell!.textLabel?.text = nil
           
        }
        else if indexPath.row == 1 {
            
            //Overview
            displayAttribute = detailViewModel?.overviewAttribute
            cell!.textLabel?.text = "Overview"
            
        }
        else if indexPath.row == 2 {
            
            //Rating count
            displayAttribute = detailViewModel?.ratingCountAttribute
            cell!.textLabel?.text = "Number of reviews"
            
        }
        else if indexPath.row == 3 {
            
            //Average rating count
            displayAttribute = detailViewModel?.averageRatingAttribute
            cell!.textLabel?.text = "Average rating"
            
        }
        else {
            
            //Release date
            displayAttribute = detailViewModel?.dateOfReleaseAttribute
            cell!.textLabel?.text = "Date of release"
        }
        
        cell!.detailTextLabel?.text = displayAttribute?.text
        cell!.detailTextLabel?.font = displayAttribute?.font
        cell!.detailTextLabel?.textColor = displayAttribute?.color
        
        return cell!
    }
}
