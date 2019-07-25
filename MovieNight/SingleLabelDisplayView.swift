//
//  SingleLabelDisplayView.swift
//  MovieNight
//
//  Created by Bharath on 22/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

protocol SingleLabelDisplayable {
    var backgroundColor: UIColor { get }
    var textAlignment: NSTextAlignment { get }
    var textAttribute: TextWithAttribute { get }
}


class SingleLabelDisplayView: UIView {
    
    private var textLabel: UILabel? = nil
    
    private var data: SingleLabelDisplayable? {
        didSet {
            setupTextLabelIfRequired()
            textLabel?.font = data?.textAttribute.font
            textLabel?.text = data?.textAttribute.text
            textLabel?.textColor = data?.textAttribute.color
            textLabel?.textAlignment = data?.textAlignment ?? NSTextAlignment.natural
            self.backgroundColor = data?.backgroundColor

        }
    }
    
    
    init(withData data: SingleLabelDisplayable?) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        update(withData: data)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func update(withData data: SingleLabelDisplayable?) {
        self.data = data
    }
    
    
    func setupTextLabelIfRequired() {
        
        if textLabel == nil {
            textLabel = UILabel()
            textLabel!.translatesAutoresizingMaskIntoConstraints = false
            textLabel!.numberOfLines = 0
            addSubview(textLabel!)
            textLabel!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
            textLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
            textLabel!.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0).isActive = true
            textLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0).isActive = true
        }
    }
    
    
    func changeMinimumScaleFactor(to value: CGFloat) {
        self.textLabel!.adjustsFontSizeToFitWidth = true
        self.textLabel!.minimumScaleFactor = value
    }
    
    
    
    deinit {
        textLabel = nil
        data = nil
    }
    
}
