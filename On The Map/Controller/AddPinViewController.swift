//
//  AddPinViewController.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/3/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import UIKit

class AddPinViewController: UIViewController {

    @IBOutlet weak var addPinButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelPresed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPin(_ sender: Any) {
        print("Searching for location")
        ClientData.postLocation = self.locationTextField.text ?? ""
        print("Now: ")
        print(ClientData.postLocation)
        
//        performSegue(withIdentifier: "backToMap", sender: nil)
//        self.dismiss(animated: true, completion: nil)

        
        //        backToMap
//        performSegue(withIdentifier: "ShowLocation", sender: nil)
        
        
        
//        print("objectID: ")
//        print(ClientData.objectID)
//        print(UdacityClient.Auth.accountId)
//        print(ClientData.currentStudentData?.firstName)
//        print(ClientData.currentStudentData?.lastName)
//        print("post")
//        print(ClientData.postLocation)
//        print("webs")
//        print(ClientData.postWebsite)
//        print(ClientData.postLatitude)
//        print(ClientData.postLongitude)
//        UdacityClient.postNewPin(uniqueKey: UdacityClient.Auth.accountId, firstName: ClientData.currentStudentData?.firstName ?? "", lastName: ClientData.currentStudentData?.lastName ?? "", mapString: "ClientData.postLocation", mediaURL: "ClientData.postWebsite", latitude: 30, Longitude: 40, completionHandler: {
//            (success, error) in
//            if !success{
//                //show alert
//                self.showError(title: "Error", message: "Can't post location")
//            }else{
//                //dismiss
//                print("objectID tany: ")
//                print(ClientData.objectID)
//                ClientData.postLocation = self.locationTextField.text ?? ""
//                print("post")
//                print(ClientData.postLocation)
//            }
//        })
//
    }
    
    
    
}
