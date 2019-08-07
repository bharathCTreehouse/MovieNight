//
//  ButtonWithActivityIndicatorHeaderFooterView.swift
//  MovieNight
//
//  Created by Bharath on 05/08/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

enum HeaderFooterViewDisplayState {
    case notLoading(buttonTitle: String)
    case loading
}


class ButtonWithActivityIndicatorHeaderFooterView: UIView {
    
    var buttonTapCompletionHandler: (() -> Void)?
    var button: UIButton? = nil
    var activityView: UIActivityIndicatorView? = nil
    
    var displayState: HeaderFooterViewDisplayState = .notLoading(buttonTitle: "Header Footer Button") {
        
        didSet {
            
            switch displayState {
                case let .notLoading(buttonTitle: title):
                    button?.isHidden = false
                    button?.setTitle(title, for: .normal)
                    activityView?.stopAnimating()
                
                case .loading:
                    activityView?.startAnimating()
                    button?.isHidden = true
            }
        }
    }
    
    
    init(withFrame frame: CGRect, displayState: HeaderFooterViewDisplayState, buttonTapHandler: (() -> Void)?) {
        
        buttonTapCompletionHandler = buttonTapHandler
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupSubviews()
        update(displayState: displayState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func setupSubviews() {
        
        if button == nil {
            button = UIButton(type: .system)
            button!.frame = frame
            addSubview(button!)
            button!.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            button!.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        if activityView == nil {
            activityView = UIActivityIndicatorView(style: .gray)
            addSubview(activityView!)
            activityView!.center = self.center
            activityView!.hidesWhenStopped = true
        }
        
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        buttonTapCompletionHandler?()
    }
    
    
    func update(displayState state: HeaderFooterViewDisplayState) {
        self.displayState = state
    }
    
    
    deinit {
        buttonTapCompletionHandler = nil
    }
}
