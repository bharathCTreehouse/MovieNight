//
//  CertificationListViewModel.swift
//  MovieNight
//
//  Created by Bharath on 21/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum CertificationAttribute {
    
    case country
    case meaning
    
    var labelTextAlignment: NSTextAlignment {
        switch self {
            case .country: return .center
            case .meaning: return .natural
        }
    }
    
    
    var color: UIColor {
        switch self {
            case .country, .meaning: return UIColor.white
        }
    }
}



class CertificationListViewModel {
    
    
    let certification: Certification
    let attributeType: CertificationAttribute
    
    
    init(withCertification certification: Certification, attributeType type: CertificationAttribute) {
        
        self.certification = certification
        attributeType = type
    }
}



extension CertificationListViewModel: SingleLabelDisplayable {
    
    var backgroundColor: UIColor {
        return self.attributeType.color
    }
    
    var textAlignment: NSTextAlignment {
        return self.attributeType.labelTextAlignment
    }
    
    var textAttribute: TextWithAttribute {
        
        switch self.attributeType {
            case .country: return TextWithAttribute(text: certification.country.fullCountryString!, font: UIFont.boldSystemFont(ofSize: 17.0), color: UIColor.red)
            case .meaning: return TextWithAttribute(text: certification.meaning, font: UIFont.systemFont(ofSize: 15.0), color: UIColor.red)
        }
    }
    
}
