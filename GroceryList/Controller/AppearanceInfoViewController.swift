//
//  AppearanceInfoViewController.swift
//  GroceryList
//
//  Created by gunta.golde on 05/08/2021.
//

import UIKit

class AppearanceInfoViewController: UIViewController {
    
    @IBOutlet weak var appInfoLabel: UILabel!
    
    var infoText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !infoText.isEmpty {
            appInfoLabel.text = infoText
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!
       
        
    @IBAction func openSettingsTapped(_ sender: Any) {
        openSettings()
    }
    
    func setLabelText(){
        var text = "Unable to specify UI style"
        if self.traitCollection.userInterfaceStyle == .dark{
            text = "Dark Mode is On\nGo to Settings if you would like\nto change to Light Mode."
        }else{
            text = "Light Mode is On\nGo to Settings if you would like\nto change to Dark Mode."
        }
        textLabel.text = text
    }
    
    func openSettings(){
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingURL){
            UIApplication.shared.open(settingURL, options: [:]) { success in
                print("sucess: ", success)
            }
        }
        setLabelText()
    }
}
    
    extension AppearanceInfoViewController {
     override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         setLabelText()
     }
}

