//
//  ForgotPasswordController.swift
//  Temp111
//
//  Created by Dmitry Torshin on 17.03.17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordController: UIViewController, UITextFieldDelegate {
    
    let text: UITextView = {
        let txt = UITextView()
        txt.text = "Enter your email address bellow and we'll send you instructions on how to change your password"
        txt.font = UIFont.systemFont(ofSize: 18)
        txt.textAlignment = NSTextAlignment.center
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
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
    
    let sendEmailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendEmailButtonAction), for: .touchUpInside)
        button.isEnabled = false
        /*
         let cornerRadius : CGFloat = 5.0
         button.layer.borderWidth = 1.0
         button.layer.borderColor = UIColor.black.cgColor
         button.layer.cornerRadius = cornerRadius*/
        return button
    }()
    
    func sendEmailButtonAction(sender: UIButton) {
        emailTextField.resignFirstResponder()
        guard let email = emailTextField.text else {return}
        
        let isValid = isValidEmail(testStr: email)
        if isValid {
            let auth = FIRAuth.auth()
            auth?.sendPasswordReset(withEmail: email, completion: { (error) in
                if let err = error {
                    let alert = UIAlertController(title: "Error in sending email", message: err.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let alert = UIAlertController(title: "Thanks! You shoud recieve an email in a few minutes!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                    let signInView = signInViewController(nibName: nil, bundle: nil)
                    self.navigationController?.pushViewController(signInView, animated: true)
                    
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            let alert = UIAlertController(title: "Your e-mail is not valid!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = UIColor.orange
        
        emailTextField.delegate = self
        
        view.addSubview(text)
        view.addSubview(emailTextField)
        view.addSubview(sendEmailButton)
        
        text.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 50.0).isActive = true
        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        text.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        text.bottomAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 150.0).isActive = true
        //-------------------
        emailTextField.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 20.0).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: text.leftAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: text.rightAnchor).isActive = true
        //-------------------
        sendEmailButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15.0).isActive = true
        sendEmailButton.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        sendEmailButton.rightAnchor.constraint(equalTo: emailTextField.rightAnchor).isActive = true

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Forgot password?"
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !(emailTextField.text?.isEmpty)! {
            self.sendEmailButton.isEnabled = true  // enable button
        } else {
            self.sendEmailButton.isEnabled = false // disable button
        }
        return true;
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
