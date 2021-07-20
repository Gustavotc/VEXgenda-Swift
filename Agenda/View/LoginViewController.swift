//
//  LoginViewController.swift
//  Agenda
//
//  Created by INDB on 21/06/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        let gSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        gSignIn.center = view.center
        view.addSubview(gSignIn)
        
        let signOut = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 30))
        signOut.backgroundColor = UIColor.red
        signOut.setTitle("Sair", for: .normal)
        signOut.center = view.center
        signOut.center.y = view.center.y + 100
        signOut.addTarget(self, action: #selector(self.signOut(_ :)), for: .touchUpInside)
        self.view.addSubview(signOut)
    }
    
    @objc func signOut(_ sender: UIButton) {
        print("Saiu")
        GIDSignIn.sharedInstance().signOut()
    }
    
}
