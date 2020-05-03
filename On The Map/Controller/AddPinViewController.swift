//
//  AddPinViewController.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/3/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import UIKit

class AddPinViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var addPinButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //if return is pressed resign first responder to hide keyboard
        textField.resignFirstResponder()
        return true
    }
    @IBAction func cancelPresed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPin(_ sender: Any) {
        ClientData.postLocation = self.locationTextField.text ?? ""
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
