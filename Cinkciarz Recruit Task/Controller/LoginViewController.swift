//
//  ViewController.swift
//  Cinkciarz Recruit Task
//
//  Created by Filip on 21/03/2019.
//  Copyright © 2019 Filip. All rights reserved.
//


import UIKit
import LocalAuthentication



class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

    }
    
    
    @IBAction func biometricButton(_ sender: Any) {
        
        authentication()
        //performSegue(withIdentifier: "goToAgencyVC", sender: nil)
        
    }
    
    
    private func authentication() {
        
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use biometric security to move forward") { (successful, error) in
                
                if successful {
                    print("Success")
                    
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "goToAgencyVC", sender: nil)
                        
                    }
                    
                } else {
                    
                    print("error")
                    
                }
            }
            
        }
        
    }
    
    
}

