//
//  ViewController.swift
//  Temp111
//
//  Created by Dmitry Torshin on 01.03.17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import ActiveLabel
import FirebaseAuth

class signInViewController: UIViewController, UITextFieldDelegate{
    var login = String()
    var passw = String()
    
    let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.backgroundColor = .cyan
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = #imageLiteral(resourceName: "logoImg")
        return logoImageView
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "WELCOME!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
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
    
   let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("New in AppName? Sign Up now!", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    func signInButtonAction(sender: UIButton!) {
        emailTextField.resignFirstResponder()
        self.login = emailTextField.text!
        
        passwTextField.resignFirstResponder()
        self.passw = passwTextField.text!
        
       //Если пароль больше 6 символов
        if passw.characters.count >= 6 {
            FIRAuth.auth()?.signIn(withEmail: self.login, password: self.passw, completion: { (user, error) in
                if let err = error {
                    let alert = UIAlertController(title: "Sign in error!", message: err.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                //let homePageView = homeViewController(nibName: nil, bundle: nil)
                //self.navigationController?.pushViewController(homePageView, animated: true)
            })
        } else {
            let alert = UIAlertController(title: "Your password must be at least 6 characters!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func signUpButtonAction(sender: UIButton!) {
        let signUpView = signUpViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(signUpView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                for userInfo in user.providerData {
                    switch userInfo.providerID {
                    case "facebook.com": print("user is signed in with facebook")
                    default: print("user is signed in with \(userInfo.providerID)")
                    }
                }
            } else {
                print("user is not signed")
            }
        }*/
        
        emailTextField.delegate = self
        passwTextField.delegate = self
        
        let label: ActiveLabel = {
            let label = ActiveLabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.customize { label in
                label.numberOfLines = 1
                let myType = ActiveType.custom(pattern: "Forgot password\\?")
                label.enabledTypes = [.mention, .hashtag, .url, myType]
                label.customColor[myType] = UIColor.purple
                label.customSelectedColor[myType] = UIColor.green
                label.text = "Forgot password?"
                label.textColor = .black
            
                label.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            label.handleCustomTap(for: myType){ element in
                let ctrl = ForgotPasswordController(nibName: nil, bundle: nil)
                self.navigationController?.pushViewController(ctrl, animated: true)
            }
            label.handleURLTap{ url in
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],completionHandler: {
                        (success) in
                        print("Open \(url): \(success)")
                    })
                } else {
                    let success = UIApplication.shared.openURL(url)
                    print("Open \(url): \(success)")
                }
            }
        }
            return label
        }()
        
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(label)
        view.addSubview(emailTextField)
        view.addSubview(passwTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        let margins = view.layoutMarginsGuide
        
        
    //-------------
        logoImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8.0).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10.0).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10.0).isActive = true

    //-------------
        welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20.0).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
    //-------------
        label.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20.0).isActive = true
        label.leftAnchor.constraint(equalTo: logoImageView.leftAnchor).isActive = true
    //-------------
        emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20.0).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: label.leftAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: logoImageView.widthAnchor).isActive = true
    //-------------
        passwTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10.0).isActive = true
        passwTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        passwTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
    //-------------
        signInButton.topAnchor.constraint(equalTo: passwTextField.bottomAnchor, constant: 10.0).isActive = true
        signInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        
        signInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
    //---------------
        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10.0).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: signInButton.leftAnchor, constant: 0.0).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: signInButton.rightAnchor, constant: 0.0).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
       navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (!(emailTextField.text?.isEmpty)! && !(passwTextField.text?.isEmpty)!) {
            self.signInButton.isEnabled = true // enable button
        } else {
            self.signInButton.isEnabled = false // disable button
        }
        return true;
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
 
}

