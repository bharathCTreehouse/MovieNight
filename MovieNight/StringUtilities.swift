//
//  StringUtilities.swift
//  MovieNight
//
//  Created by Bharath on 25/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


extension String {
    
    var fullCountryString: String? {
        return CountryCodeMapper.countryString(fromCountryCode: self.uppercased())
    }
    
}
