//
//  Language.swift
//  switch-languages
//
//  Created by Andrew Fletcher on 2/11/20.
//

import Foundation
import UIKit

/// This code is from Nicolas Poincet's Cocoapod Switch Language
/// While I couldn't directly use the module due to code errors with the current version of Swift 5  https://github.com/NicolasPoincet/SwitchLanguage
/// I did use a this 


let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"
let LCLDefaultLanguage = "en-US"
let LCLBaseBundle = "Base"
let LCLCurrentTableNameKey = "LCLCurrentTableNameKey"
let LCLDefaultTableName = "Localizable"

public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"


public protocol LanguageDelegate: class {
    func language(_ language: Language.Type, getLanguageFlag flag: UIImage)
}

public class Language : NSObject {
    
    public static var delegate : LanguageDelegate?

    /**
     Get the table name
     
     @return The current table name
     **/
    public class func getTableName() -> String {
        if let currentTableName = UserDefaults.standard.object(forKey: LCLCurrentTableNameKey) as? String {
            return currentTableName
        }
        return LCLDefaultTableName
    }

    /**
     Set the table name
     
     @param The table nameto set
     **/
    public class func setTableName(_ name: String) {
        UserDefaults.standard.set(name, forKey: LCLCurrentTableNameKey)
        UserDefaults.standard.synchronize()
    }


    
    /**
     It get the list of all available languages in the app in code format
      en, fr, ru...
     
     @return Array of available languages.
     */
    public class func getAllLanguages(_ bundle: Bundle = .main) -> [String] {
        var listLanguages = bundle.localizations
        
        if let indexOfBase = listLanguages.firstIndex(of: LCLBaseBundle) {
            listLanguages.remove(at: indexOfBase)
        }
        
        return listLanguages
    }
  
    /**
     It get the list of all available languages in the app in code - name format
      en - english, fr - french, ru - russian, etc...
     
     @return Array of available languages.
     */
    public class func getAllLanguageNames(_ bundle: Bundle = .main) -> [String] {
        var listLanguages: [String] = []
        
        for item in getAllLanguages() {
          listLanguages.append(item.localized() + " - " + displayNameForLanguage(item.localized()))
        }
        
        return listLanguages
    }
    
    /**
     It get the current language of the app.
     
     @return String of current language.
     */
    public class func getCurrentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return getDefaultLanguage()
    }
    
    /**
     It change the current language of the app.
     
     @param language String correspondant to desired language.
     */
    public class func setCurrentLanguage(_ language: String, bundle: Bundle = .main) {
        let selectedLanguage = getAllLanguages(bundle).contains(language) ? language : getDefaultLanguage()
        if (selectedLanguage != getCurrentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    /**
     It get the default language of the app.
     
     @return String of app default language.
     */
    public class func getDefaultLanguage(bundle: Bundle = .main) -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = bundle.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = getAllLanguages(bundle)
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    /**
     It reset the language with the default language of the app.
     
     @return Void
     */
    public class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.getDefaultLanguage())
    }
    
    /**
     It get the current language and display his name.
     
     @param language String correspondant to desired language.
     
     @return String name of the current languages.
     */
    public class func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: getCurrentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
    
    /**
     It get the flag of the current language and display it in the settings button.
     
     @return Void
     */
    public class func setFlagToButton() {
        let cLanguage = getCurrentLanguage()
        
        let countryCode = cLanguage.split(separator: "-")
        var newLang : String
        if (countryCode.count == 2) {
            newLang = String(countryCode[1])
        } else {
            newLang = String(countryCode[0])
        }
        
        let flag = URL(string: "http://www.countryflags.io/\(newLang)/flat/64.png")
        
        var cFlag = UIImage()
        downloadImage(url: flag!) { img in
            if (img?.cgImage != nil) {
                cFlag = img!
                self.delegate?.language(self, getLanguageFlag: cFlag)
            }
        }
        
    }
    
    /**
     It display a basic alert with each names of available languages of the app.
     
     @param [String] array of all available languages.
     
     @return UIAlertController alert action to change the language.
     */
    public class func basicAlert(_ languages: [String]) -> UIAlertController {
        
      let actionSheet = UIAlertController(title: nil, message: "Switch Language".localized(), preferredStyle: UIAlertController.Style.actionSheet)
        for lang in languages {
            let displayName = displayNameForLanguage(lang)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                setCurrentLanguage(lang)
            })
            actionSheet.addAction(languageAction)
        }
        
      let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        return actionSheet
    }
    
    /**
     It display an alert with the flags of each available languages of the app.
     
     @param [String] array of all available languages.
     
     @return UIAlertController alert action to change the language.
     */
    public class func flagAlert(_ languages: [String]) -> UIAlertController {
        
      let actionSheet = UIAlertController(title: nil, message: "Switch Language".localized(), preferredStyle: UIAlertController.Style.actionSheet)
        
        let imageView = UIImageView()
        actionSheet.view.addSubview(imageView)
        
        for lang in languages {
            let countryCode = lang.split(separator: "-")
            var newLang : String
            if (countryCode.count == 2) {
                newLang = String(countryCode[1])
            } else {
                newLang = String(countryCode[0])
            }
            
            let flag = URL(string: "http://www.countryflags.io/\(newLang)/flat/64.png")
            
            var cFlag = UIImage()
            downloadImage(url: flag!) { img in
                if (img?.cgImage != nil) {
                    cFlag = img!
                    let displayName = displayNameForLanguage(lang)
                    let languageAction = UIAlertAction(title: displayName, style: .default, handler: { (alert: UIAlertAction!) -> Void  in
                        setCurrentLanguage(lang)
                    })
                  languageAction.setValue(cFlag.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), forKey: "image")
                    
                    actionSheet.addAction(languageAction)
                }
            }
        }

      let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        return actionSheet
    }
}


extension Language {
    
    /**
     Request to get the flag image of the languages.
     
     @param URL of the awaited image
     */
    class func getDataFromUrl(url : URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) {
            data, response, error in completion(data, response, error)
            }.resume()
    }
    
    /**
     Call the request to download the awaited image for languages.
     
     @param URL of the awaited image
     */
    class func downloadImage(url: URL,  completionHandler: @escaping (UIImage?) -> Void) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let image = UIImage(data: data)
                completionHandler(image)
            }
        }
    }
    
}

