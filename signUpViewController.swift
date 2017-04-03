//
//  ViewController3.swift
//  Temp111
//
//  Created by Dmitry Torshin on 06.03.17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import TwitterKit

class signUpViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    let homePageView = homeViewController(nibName: nil, bundle: nil)
  
    let emailTextField: UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "Email"
        email.layer.borderWidth = 1.0
        email.layer.cornerRadius = 5
        email.layer.borderColor = UIColor.gray.cgColor
        return email
    }()
    
    let passwTextField: UITextField = {
        let passw = UITextField()
        passw.translatesAutoresizingMaskIntoConstraints = false
        passw.placeholder = "Password"
        passw.isSecureTextEntry = true
        passw.layer.borderWidth = 1.0
        passw.layer.cornerRadius = 5
        passw.layer.borderColor = UIColor.gray.cgColor
        return passw
    }()

    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let fbLoginButton: FBSDKLoginButton = {
        let loginButton = FBSDKLoginButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.readPermissions = ["email","public_profile"]
        return loginButton
    }()
    
    let googleButton:GIDSignInButton = {
        let googleButton = GIDSignInButton()
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        return googleButton
    }()
    
    func signUpButtonAction(sender: UIButton!){
        
        emailTextField.resignFirstResponder()
        let login = emailTextField.text!
        
        passwTextField.resignFirstResponder()
        let passw = passwTextField.text!
        
        let validEmail = isValidEmail(testStr: login)
        
        if validEmail {
            if passw.characters.count >= 6 {
                FIRAuth.auth()?.createUser(withEmail: login, password: passw, completion: { (user, error) in
                    if let err = error {
                        let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print(err.localizedDescription)
                    
                        return
                    }
                    print("Seccessfully created new user with email & passw", user?.uid ?? "")
                    // we need to open home page or sign in page after creating new user in Farebase ???
                    self.navigationController?.pushViewController(self.homePageView, animated: true)
                })
            }
            else {
                let alert = UIAlertController(title: "Your password must be at least 6 characters!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else {
            let alert = UIAlertController(title: "Your e-mail is not valid!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    //Facebook login button
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
   
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else
        { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Something wrong with sign in Firebese FB user: ", err.localizedDescription)
                return
            }
            print("Successfull logged in with sign in Firebese FB user: ",user?.uid ?? "")
            //self.navigationController?.pushViewController(self.homePageView, animated: true)
        })
        
        /*FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start{
            (connection, result, err) in
            if err != nil {
                print("Filed to start graph request: ", err)
                return
            }
            print(result)
        }*/
    }
    
    private func SetupTwitterButton() {
        let twitterButton = TWTRLogInButton { (session, error) in
            if let err = error {
                print("Failed to login via Twitter", err.localizedDescription)
                return
            }
     
            guard let token = session?.authToken else {return}
            guard let secretToken = session?.authTokenSecret else {return}
            let credential = FIRTwitterAuthProvider.credential(withToken: token, secret: secretToken)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let err = error {
                    print("Something wrong with sign in Firebese Twitter user:", err)
                    return
                }
                print("Successfully logged in Firebese Twitter user:", user?.uid ?? "")
                //self.navigationController?.pushViewController(self.homePageView, animated: true)
            })
        }
        
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(twitterButton)
        twitterButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 40.0).isActive = true
        twitterButton.leftAnchor.constraint(equalTo: googleButton.leftAnchor).isActive = true
        twitterButton.rightAnchor.constraint(equalTo: googleButton.rightAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        emailTextField.delegate = self
        passwTextField.delegate = self
        fbLoginButton.delegate = self
        
        view.addSubview(emailTextField)
        view.addSubview(passwTextField)
        view.addSubview(signUpButton)
        view.addSubview(fbLoginButton)
        view.addSubview(googleButton)
       
        SetupTwitterButton()
        
        GIDSignIn.sharedInstance().uiDelegate = self
     
        //-------------------------
        emailTextField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8.0).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        //--------------------------
        passwTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10.0).isActive = true
        passwTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        passwTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor).isActive = true
        //--------------------------
        signUpButton.topAnchor.constraint(equalTo: passwTextField.bottomAnchor, constant: 20.0).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: passwTextField.leftAnchor).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: passwTextField.rightAnchor).isActive = true
  
        //--------------------------
        fbLoginButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 40.0).isActive = true
        fbLoginButton.leftAnchor.constraint(equalTo: signUpButton.leftAnchor).isActive = true
        fbLoginButton.rightAnchor.constraint(equalTo: signUpButton.rightAnchor).isActive = true
        
        //-----------------------------
        googleButton.topAnchor.constraint(equalTo: fbLoginButton.bottomAnchor, constant: 40.0).isActive = true
        googleButton.leftAnchor.constraint(equalTo: signUpButton.leftAnchor).isActive = true
        googleButton.rightAnchor.constraint(equalTo: signUpButton.rightAnchor).isActive = true

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = " Create account"
          navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (!(emailTextField.text?.isEmpty)! && !(passwTextField.text?.isEmpty)!) {
            self.signUpButton.isEnabled = true  // enable button
        } else {
            self.signUpButton.isEnabled = false // disable button
        }
        return true;
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    

}
