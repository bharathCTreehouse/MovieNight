//
//  CountryCodeMapper.swift
//  MovieNight
//
//  Created by Bharath on 25/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class CountryCodeMapper {
    
    enum Country {
        case USA
        case Canada
        case Australia
        case Denmark
        case France
        case NewZealand
        case India
        case GreatBritain
        case TheNetherlands
        case Brazil
        case Finland
        case Bulgaria
        case Spain
        case Phillipines
        case Portugal
        
        
        var countryCode: String {
            switch self {
            case .USA: return "US"
            case .Canada: return "CA"
            case .Australia: return "AU"
            case .Denmark: return "DE"
            case .France: return "FR"
            case .NewZealand: return "NZ"
            case .India: return "IN"
            case .GreatBritain: return "GB"
            case .TheNetherlands: return "NL"
            case .Brazil: return "BR"
            case .Finland: return "FI"
            case .Bulgaria: return "BG"
            case .Spain: return "ES"
            case .Phillipines: return "PH"
            case .Portugal: return "PT"
            }
        }
    }
    
    private static let countryDictionary:[String: String] =
         ["US": "United States Of America", "CA": "Canada", "AU": "Australia", "DE": "Denmark", "FR": "France", "NZ": "New Zealand", "IN": "India", "GB": "Great Britain", "NL": "The Netherlands", "BR": "Brazil", "FI": "Finland", "BG": "Bulgaria", "ES": "Spain", "PH": "Phillipines", "PT": "Portugal"]
    
    
    
    static func countryString(fromCountryCode code: String) -> String? {
        return countryDictionary[code]
    }
    
    
    static func countryString(fromCountry country: Country) -> String? {
        return countryString(fromCountryCode: country.countryCode)
    }
}
