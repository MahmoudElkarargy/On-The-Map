//
//  LoginViewController.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/1/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets.
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: Buttons!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate  = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //if return is pressed resign first responder to hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: IBActions functions.
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        //close the keyboard
        passwordTextField.resignFirstResponder()
        //send the username and password to the API.
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completionHandler: self.handleLoginResponse(success:error:))
    }
    @IBAction func signupTapped(_ sender: Any) {
        //direct to udacity website
        UIApplication.shared.open(UdacityClient.EndPoints.signUP.url, options: [:], completionHandler: nil)
    }
    
    // MARK: Handleing functions.
    //Handle the login response
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            // load data
            UdacityClient.getClientData(completionHandler: handleClientData(data:error:) )
            // get the text fields empty again to handle logout.
            emailTextField.text = ""
            passwordTextField.text = ""
            performSegue(withIdentifier: "completeLogin", sender: nil)
            
        } else {
            showError(title: "Login Failed", message: error?.localizedDescription ?? "Error")
        }
    }
    func handleClientData(data: ClientDataResponse?, error: Error?){
        guard let data = data else {
            showError(title: "Error", message: "There was error loading data")
            return
        }
        ClientData.currentClientData = data
    }
    
    //Show and hide elments depends on login case.
    func setLoggingIn (_ loggingIn: Bool){
        loggingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}

