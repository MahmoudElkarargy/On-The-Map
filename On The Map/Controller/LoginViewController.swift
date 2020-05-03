//
//  LoginViewController.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/1/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: Buttons!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate  = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //if return is pressed resign first responder to hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        passwordTextField.resignFirstResponder()
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completionHandler: self.handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            UdacityClient.getClientData(completionHandler: handleClientData(data:error:) ) // get student data
            emailTextField.text = ""
            passwordTextField.text = ""
            performSegue(withIdentifier: "completeLogin", sender: nil)
            
        } else {
            showError(title: "Login Failed", message: error?.localizedDescription ?? "Error")
        }
    }
    func handleClientData(data: ClientDataResponse?, error: Error?){
        guard let data = data else {
            return
        }
        ClientData.currentClientData = data
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        //direct to udacity website
        UIApplication.shared.open(UdacityClient.EndPoints.signUP.url, options: [:], completionHandler: nil)
    }

    func setLoggingIn (_ loggingIn: Bool){
        if loggingIn{
            ActivityIndicator.startAnimating()
        } else{
            ActivityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        
    }
}

