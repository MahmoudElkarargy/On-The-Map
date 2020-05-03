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

class MapViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var urlView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlField: UITextField!
    let Newannotation = MKPointAnnotation()
    let locationManger = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        urlField.delegate = self
        configureView()
        checkLocationServices()
    }
    var annotations = [MKPointAnnotation]()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //if return is pressed resign first responder to hide keyboard
        textField.resignFirstResponder()
        return true
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
            showError(title: "Location Service is off", message: "On the map can't perform without location service")
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
            showError(title: "Error", message: "Please allow location service")
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            showError(title: "Error", message: "Please allow location service")
            break
        case .authorizedAlways:
            break
        }
    }
    func configureView(){
        urlView.isHidden = true
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonIsPressed))
        self.tabBarController?.title = "On The Map"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_pin"), style: .plain, target: self, action: #selector(addNewPin))

        //Get Clients Locations..
        UdacityClient.getClientsLocations(completionHandler: handleLocations(data:error:))
    }
    
    @objc func logoutButtonIsPressed(){
        UdacityClient.logout(completionHandler: {
            (success, error) in
            if success{
                // Empty the client Infromation list
                ClientData.currentClientData = nil
                self.tabBarController?.navigationController?.popViewController(animated: true)
            }else{
                self.showError(title: "Error", message: "Failed to logout")
            }
        })
    }
    
    func handleLocations(data: ClientsLocation?, error: Error?){
        if let data = data{
            ClientData.ClientsDataLocations = data.results
            //display pins on map
            displayPinsOnMap()
        }else{
            //error fetching data
            showError(title: "Error", message: "Problem while fetching data")
        }
    }
    @objc func addNewPin(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addPin") as! AddPinViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMap( _ sender: UIStoryboardSegue){
        //Now will add the URL view
        if ClientData.postLocation != ""{
            //Check is this location exists.
            showLocationOnMap()
        }
    }
    @IBAction func AddURLPressed(_ sender: Any) {
        urlField.resignFirstResponder()
        ClientData.postWebsite = urlField.text ?? ""
        urlView.isHidden = true
        if !ClientData.postedPin {
                UdacityClient.postNewPin(uniqueKey: UdacityClient.Auth.accountId, firstName: ClientData.currentClientData?.firstName ?? "", lastName: ClientData.currentClientData?.lastName ?? "", mapString: ClientData.postLocation, mediaURL: ClientData.postWebsite, latitude: ClientData.postLatitude!, Longitude: ClientData.postLongitude!, completionHandler: {
                    (success, error) in
                    if !success{
                        //show alert
                        self.showError(title: "Error", message: "Can't post location")
                    }else{
                        self.Newannotation.subtitle = ClientData.postWebsite
                        self.showError(title: "Pin Posted", message: "Your pin have been posted")
                        ClientData.postedPin = true
                    }
                })
        }
        else {
            //Post Requet to edit current pin
            UdacityClient.PUTStudentLocation(uniqueKey: UdacityClient.Auth.accountId, firstName: ClientData.currentClientData?.firstName ?? "", lastName: ClientData.currentClientData?.lastName ?? "", mapString: ClientData.postLocation, mediaURL: ClientData.postWebsite, latitude: ClientData.postLatitude!, Longitude: ClientData.postLongitude!, completionHandler: {
                (success, error) in
                if !success{
                    //show alert
                    self.showError(title: "Error", message: "Can't update location")
                }else{
                    self.showError(title: "Modify complete", message: "Your pin have been Modified")
                    self.Newannotation.subtitle = ClientData.postWebsite
                }
            })
            
        }
    }
    
    // MARK: Check if location is valid and zoom in on it
    func showLocationOnMap(){
        // MARK: Geocode the Location user entered
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = ClientData.postLocation
        let search = MKLocalSearch(request: searchRequest)

        // If it doesn't exist display an error message
        search.start { response, error in
            guard let response = response else {
                self.showError(title: "Error", message: "Can't Find Location")
                return
            }
            
        for item in response.mapItems {
            if let mi = item as? MKMapItem {
                // zoom in on the location
                let span = MKCoordinateSpan(latitudeDelta: 0.9000, longitudeDelta: 0.9000)
                let coordinate = mi.placemark.location?.coordinate
                let region = MKCoordinateRegion(center: coordinate!, span: span)
                self.mapView.setRegion(region, animated: true)

                // Update the Student Location Instance with the coordinates
                ClientData.postLongitude = coordinate!.longitude
                ClientData.postLatitude = coordinate!.latitude
                
                // Show a new PinMarker on the Map
                
                self.Newannotation.coordinate = coordinate!
                self.annotations.append(self.Newannotation)
                let firstname = ClientData.currentClientData?.firstName ?? ""
                let lastname = ClientData.currentClientData?.lastName ?? ""
                let fullname = firstname + " " + lastname
                self.Newannotation.title = fullname
                self.mapView.addAnnotations(self.annotations)
                self.urlView.isHidden = false

                UdacityClient.getClientsLocations(completionHandler: self.handleLocations(data:error:))
                    break
                }
            }
        }
    }
    
    func displayPinsOnMap(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        let locations = ClientData.ClientsDataLocations
        for location in locations{
            let annotation = MKPointAnnotation()
            annotation.title = location.firstName + " " + location.lastName
            annotation.subtitle = location.mediaURL
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
}


extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.isEnabled = true
                pinView!.canShowCallout = true
                pinView?.animatesDrop = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return pinView
            }
            else {
                pinView!.annotation = annotation
            }
            return pinView
        }
    
    // This delegate method is implemented to respond to taps. as to direct to media type
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            guard let urlString = view.annotation?.subtitle!, let url = URL(string: urlString) else{
                showError(title: "Error", message: "URL not valid ")
                return
            }
            
            UIApplication.shared.open(url, options: [:]) { success in
                guard success == true else{
                    self.showError(title: "Error", message: "URL not valid ")
                    return
                }
            }
        }
    }
}
