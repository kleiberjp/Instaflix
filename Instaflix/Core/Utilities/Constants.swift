//
//  Constants.swift
//  Instaflix
//
//  Created by Kleiber Perez on 10/09/24.
//

import Foundation

struct Constants {
    
    static let imageURL                   = "https://image.tmdb.org/t/p/w500"
    
    static var curentLanguage: String {
        return Locale.preferredLanguages.first ?? "en-US"
    }
    
    static var apiKeyTMBD: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "InstaflixSensitive", ofType: "plist") else {
                return ""
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "TMDB_API_KEY") as? String else {
                return ""
            }
            
            return value
        }
    }
}
