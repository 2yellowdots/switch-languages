//
//  SettingsViewController.swift
//  switch-languages
//
//  Created by Andrew Fletcher on 30/10/20.
//

import UIKit
import RealmSwift
import DropDown


class SettingsViewController: UIViewController {
  
    let realm = try! Realm()
    var settings: Results<Settings>?
    @IBOutlet weak var screenHeader: UITextField!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var demoLbl: UILabel!
  
    @IBOutlet weak var languageBtn: DropButton!
  
    let languageDropDown = DropDown()
    let textField = UITextField()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.languageDropDown
        ]
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: BACKGROUND_IMG)
        view.layer.contents = img?.cgImage
      
        setupHeader()
        setupLanguageLabel()
        setupDemoLabel()
        loadSettings()
        countSettings()
        
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.setNeedsDisplay()
    }
    
    // MARK: - Actions
  
    @IBAction func headHome(_ sender: Any) {
      // change the language of the app
      languageButtonAction()
      // go to home screen
      performSegue(withIdentifier: "goHome", sender: self)
    }
  
    // change the language of the app, as the user taps the back button
    /* for this function to work, the swift file bundleExtension must be added also
        the this to occur, the following two lines must also exist
         UserDefaults.standard.set([languageAbbreviation], forKey: "AppleLanguages")
         UserDefaults.standard.synchronize()
     */
    
    func languageButtonAction() {
        // This is done so that network calls now have the Accept-Language as Language.getCurrentLanguage() (Using Alamofire) Check if you can remove these
        UserDefaults.standard.set([Language.getCurrentLanguage()], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
      
        // Update the language by swaping bundle
        Bundle.setLanguage(Language.getCurrentLanguage())
        
        // Done to reintantiate the storyboards instantly
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        UIApplication.shared.windows.first { $0.isKeyWindow }
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
  
    @IBAction func chooseLanguage(_ sender: Any) {
        languageDropDown.show()
    }

    /**
    Default  setup for the drop down function
   
     */
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
        }
    }
    
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = flatGrayDarkColor
        
        dropDowns.forEach {
            /*** FOR CUSTOM CELLS ***/
            $0.cellNib = UINib(nibName: "DropCell", bundle: nil)
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? DropCell else { return }
                
                // Setup your custom UI components
                cell.suffixLabel.text = "Suffix \(index)"
            }
            /*** ---------------- ***/
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
  
    //MARK: - Set up the header and labels
  
    fileprivate func setupHeader() {
        let labelLanguage = NSLocalizedString("Settings", comment: "Settings")
        screenHeader.text = labelLanguage
        screenHeader.font = UIFont(name: fontLabel, size: 20.0)
        screenHeader.textColor = flatGrayDarkColor
    }
  
    //
    fileprivate func setupLanguageLabel() {
        let labelLanguage = NSLocalizedString("SettingsLanguage", comment: "Language")
        languageLbl.text = labelLanguage
        languageLbl.numberOfLines = 0
        languageLbl.font = UIFont(name: fontLabel, size: 22.0)
        languageLbl.textColor = flatGrayDarkColor
    }
    
    //
    fileprivate func setupDemoLabel() {
        let labelDemo = NSLocalizedString("SettingsDemoText", comment: "Show the result of changing languages")
        demoLbl.text = labelDemo
        demoLbl.numberOfLines = 0
        demoLbl.font = UIFont(name: fontLabel, size: 18.0)
        demoLbl.textColor = flatGrayDarkColor
    }
    
    func setupDropDowns() {
        setupLanguageButton()
        setupLanguageDropDown()
    }
    
    @IBAction func showKeyboard(_ sender: AnyObject) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        view.endEditing(false)
    }
    
    func setupLanguageButton() {
        languageBtn.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        // set the language drop down to the current setting
        languageBtn.setTitle(settings!.first?.speechLanguage, for: .normal)
    }
    
    func setupLanguageDropDown() {
        
        languageDropDown.anchorView = languageBtn
        
        // Will set a custom with instead of anchor view width
        languageDropDown.width = 240
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        languageDropDown.bottomOffset = CGPoint(x: 0, y: languageBtn.bounds.height)
        
        // You can also use localizationKeysDataSource instead
//        languageDropDown.dataSource = SpeakViewController().speechVoiceList()
        languageDropDown.dataSource = Language.getAllLanguageNames()
        
        // get the row position of the current language saved in settings
        let rowPosition = Language.getAllLanguageNames().firstIndex(of: (settings!.first?.speechLanguage)!)
        // preset the current selection to the respective row in the array
        languageDropDown.selectRow(at: rowPosition)
        
        // Action triggered on selection
        languageDropDown.selectionAction = { [weak self] (index, item) in
            self?.languageBtn.setTitle(item, for: .normal)
            /* language item will be displayed as en-GB, fr-FR, etc...
               separate the item into an array to allow for longer code such
               as zh-Hans */
            let newLanguageArr = item.components(separatedBy: " - ")
            if let setting = self?.settings!.first {
                // set the new item as the current language
                Language.setCurrentLanguage(newLanguageArr.first!)
                try! self?.realm.write {
                    setting.speechLanguage = item
                }
              
                self?.languageButtonAction()
            }
        }
  
    }
    
    //MARK: Realm
  
    func loadSettings() {
        settings = realm.objects(Settings.self)
    }
    
    /**
    Get the settings object for use in other view controllers
   
     */
    func getSettings() -> Object {
        loadSettings()
        let initSettings = Settings()
        
        return initSettings
    }
  
    /**
    If there are no values in the settings object, then initialise
   
     */
    func countSettings() {
        if settings?.count == 0 || settings?.count == nil {
            let settings = Settings()
            settings.category = 0
            settings.level = 0
            settings.phrase = 0
            settings.score = 0
            settings.speechLanguage = "en-US"
            save(setting: settings)
        }
    }
    
    func save(setting: Settings) {
        do {
            try realm.write {
                realm.add(setting)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }

}

