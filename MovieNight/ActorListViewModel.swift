//
//  ActorListViewModel.swift
//  MovieNight
//
//  Created by Bharath on 10/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ActorListViewModel {
    
    let actor: Actor
    
    init(withActor actor: Actor) {
        self.actor = actor
    }
}


extension ActorListViewModel: MultipleOptionSelectionDisplayable {
    
    
    var selectionDetail: SelectionAttribute {
        let color: UIColor = UIColor.init(red: 196.0/155.0, green: 26.0/155.0, blue: 22.0/155.0, alpha: 1.0)
        return SelectionAttribute(withSelected: false, color: color)
    }
    
    
    
    var textDetail: TextWithAttribute {
        let font: UIFont = UIFont.systemFont(ofSize: 18.0)
        let color: UIColor = UIColor.black
        return TextWithAttribute(text: actor.name, font: font, color: color)
    }
    
    
    var ID: String {
        return String(actor.ID)
    }
    
    
}
