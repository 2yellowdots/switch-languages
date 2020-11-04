//
//  Settings.swift
//  switch-languages
//
//  Created by Andrew Fletcher on 30/10/20.
//

import Foundation
import RealmSwift


class Settings: Object {
    // initial category is zero (0)
    @objc dynamic var category: Int = 0
    // initial level is zero (0)
    @objc dynamic var level: Int = 0
    // initial phrase is zero (0)
    @objc dynamic var phrase: Int = 0
    // initial score is zero (0)
    @objc dynamic var score: Int = 0
    // default language
    @objc dynamic var speechLanguage: String = "en-GB"
}
