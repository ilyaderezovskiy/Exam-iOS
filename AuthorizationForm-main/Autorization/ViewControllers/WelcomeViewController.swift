//
//  WelcomeViewController.swift
//  Autorization
//
//  Created by Ilya Derezovskiy on 26/5/23.
//  

import UIKit


class WelcomeViewController: UIViewController {

    @IBOutlet var welcomeMessageLabel: UILabel!
    @IBOutlet var elementsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeMessageLabel.text = "Привет, \(UserDefaults.standard.string(forKey: "username")!)!"
        
        view.bringSubviewToFront(elementsStackView)
        
    }
    
    
}
