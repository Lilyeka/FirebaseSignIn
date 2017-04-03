//
//  veryFirstViewController.swift
//  Temp111
//
//  Created by Dmitry Torshin on 03.04.17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class veryFirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                for userInfo in user.providerData {
                    switch userInfo.providerID {
                    case "facebook.com": print("user is signed in with facebook")
                    default: print("user is signed in with \(userInfo.providerID)")
                    }
                }
                //Show Home page
                let homePageView = homeViewController(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(homePageView, animated: false)
            } else {
                //Show Sign in page
                print("no user!")
                let signInView = signInViewController(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(signInView, animated: false)
            }
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
