//
//  HomeViewController.swift
//  switch-languages
//
//  Created by Andrew Fletcher on 30/10/20.
//

import UIKit
import RealmSwift


class HomeViewController: UIViewController {
    
  @IBOutlet weak var settingsBtn: UIButton!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the background image
        let img = UIImage(named: BACKGROUND_IMG)
        view.layer.contents = img?.cgImage
      
        manageHomeButtons()
        
    }
  
    /**
    Manage the buttons for the home screen
   
     */
    fileprivate func manageHomeButtons() {
        let settingsText = NSLocalizedString("Settings", comment: "settings")
        settingsBtn = styleButtons(label: settingsBtn, text: settingsText, color: flatGrayDarkColor)
    }
    
    /**
    Go to the settings screen
   
     */
    @IBAction func enterSettings(_ sender: Any) {
      performSegue(withIdentifier: "goToSettings", sender: self)
    }
  
    /**
    Style the buttons for the home screen

        @return stylized button
     */
    private func styleButtons(label: UIButton, text: String, color: UIColor)-> UIButton {
        label.setTitle(text, for: .normal)
        label.titleLabel?.font = UIFont(name: fontHomeTitle, size: 50.0)
        label.titleLabel?.textColor = color
        return label
    }
    
    
}
