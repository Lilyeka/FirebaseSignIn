//
//  ViewController2.swift
//  Temp111
//
//  Created by Dmitry Torshin on 01.03.17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class homeViewController: UIViewController {
    var loginData = String()
    var passwData = String()
   
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome at HOME!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                for userInfo in user.providerData {
                    switch userInfo.providerID {
                        case "facebook.com": print("user is signed in with facebook")
                        default: print("user is signed in with \(userInfo.providerID)")
                    }
                }
            }
        }*/
        //another way how to get current user
        /*let currentUser = FIRAuth.auth()?.currentUser
        if let user = currentUser {
            for data in user.providerData {
                print("Data: \(data)")
            }
            testLabel.text = "FIR User email =\(user.email), id = \(user.uid), name = \(user.displayName)"
        } else {
        }*/
        
        
        view.backgroundColor = .blue
        view.addSubview(testLabel)

        testLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300.0).isActive = true
        testLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        testLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        //navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = " Home page "
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More", style: UIBarButtonItemStyle.plain, target: self, action:#selector(moreButtonAction))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moreButtonAction(sender: UIBarButtonItem) {
        
        let moreView = moreViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(moreView, animated: true)
    }
    
}
