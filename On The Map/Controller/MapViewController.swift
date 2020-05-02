//
//  MapViewController.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManger = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureView()
        checkLocationServices()
    }
    func setLocationManger(){
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setLocationManger()
            checkLocationAuthorization()
        }
        else{
            print("Allow it please")
        }
    }
    func centerViewOnUserLocation(){
        if let location = locationManger.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
        //Do map stuff
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
            break
        
        case .denied:
            //Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            //show the Alarm letting them knows what's up
            break
        case .authorizedAlways:
            break
        }
    }
    func configureView(){
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonIsPressed))
        self.tabBarController?.title = "On The Map"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_pin"), style: .plain, target: self, action: #selector(addNewPin))
//        refreshData()
    }
    
    @objc func logoutButtonIsPressed(){
        print("eh el klam?")
        UdacityClient.logout(completionHandler: {
            (success, error) in
            if success{
                // Empty the client Infromation list
                ClientData.data = []
                self.tabBarController?.navigationController?.popViewController(animated: true)
            }else{
                print("Error")
            }
        })
    }
    @objc func addNewPin(){
        print("Adding new Pin")
    }
}
