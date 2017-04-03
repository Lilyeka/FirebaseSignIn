//
//  ViewController.swift
//  Temp111
//
//  Created by Dmitry Torshin on 29.03.17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth


class moreViewController: UIViewController {
 
    let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign out", for: .normal)
        button.addTarget(self, action: #selector(signOutButtonAction), for: .touchUpInside)
        /*
         let cornerRadius : CGFloat = 5.0
         button.layer.borderWidth = 1.0
         button.layer.borderColor = UIColor.black.cgColor
         button.layer.cornerRadius = cornerRadius
        */
        return button
    }()
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        view.addSubview(signOutButton)
        signOutButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10.0).isActive = true
        signOutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        signOutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10.0).isActive = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signOutButtonAction(sender: UIButton!){
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let actionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            self.signOutFirebaseEmailAndPasswUser()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func signOutFirebaseEmailAndPasswUser() {
        let firebaseAuth =  FIRAuth.auth()
        var signOutOK = false
        do{
            try firebaseAuth?.signOut()
            signOutOK = true
        } catch let signOutErr as NSError {
            print("Error signing out: %@ ",signOutErr)
        }
        if signOutOK {
            print("user seccessfully signed out!")
           // let signInView = signInViewController(nibName: nil, bundle: nil)
           //self.navigationController?.pushViewController(signInView, animated: true)
        }
    }



}
