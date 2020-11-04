//
//  StringExtension.swift
//  switch-languages
//
//  Created by Andrew Fletcher on 3/11/20.
//

import Foundation


public extension String {
    
    /**
     It search the localized string

          @return The localized string.
     */
    func localized() -> String {
        return localized(using: Language.getTableName())
    }
    
    /**
     It search the localized string
     
     @param tableName: The receiver’s string table to search.
     
     @param bundle: The receiver’s bundle to search.
     
          @return The localized string.
     */
    func localized(using tableName: String, in bundle: Bundle = .main) -> String {
        if let path = bundle.path(forResource: Language.getCurrentLanguage(), ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        else if let path = bundle.path(forResource: LCLBaseBundle, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }
  
}
