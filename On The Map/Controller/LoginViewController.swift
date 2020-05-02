//
//  LoginViewController.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/1/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: Buttons!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: self.handleLogin(success:error:))
    }
    func handleLogin(success: Bool, error: Error?) {
       setLoggingIn(false)
        guard error == nil, success == true
            else {
                print("error ")
                return
            }
//        self.performSegue(withIdentifier: "login", sender: self)
        print("okay")
    }
    @IBAction func signupTapped(_ sender: Any) {
    }
    
    func setLoggingIn (_ loggingIn: Bool){
        if loggingIn{
            ActivityIndicator.startAnimating()
        } else{
            ActivityIndicator.stopAnimating()
        }
    }
}

