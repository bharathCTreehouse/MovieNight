//
//  GenreListViewModel.swift
//  MovieNight
//
//  Created by Bharath on 02/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class GenreListViewModel {
    
    let genre: Genre
    var isSelected: Bool = false
    
    init(withGenre genre: Genre) {
        self.genre = genre
    }
}


extension GenreListViewModel: MultipleOptionSelectionDisplayable {
    
    
    var ID: String {
        return String(genre.ID)
    }
    
    
    
    var selectionDetail: SelectionAttribute {
        
        set(value) {
            self.isSelected = value.isSelected
        }
        get {
            let color: UIColor = UIColor.init(red: 196.0/155.0, green: 26.0/155.0, blue: 22.0/155.0, alpha: 1.0)
            return SelectionAttribute(withSelected: isSelected, color: color)
        }
    }
    
    
    
    var textDetail: TextWithAttribute {
        let font: UIFont = UIFont.systemFont(ofSize: 18.0)
        let color: UIColor = UIColor.black
        return TextWithAttribute(text: genre.name, font: font, color: color)
    }
    
}
