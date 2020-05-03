//
//  UdacityClient.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import Foundation

class UdacityClient{
    // MARK: Struct to hold the Authentication keys.
    struct Auth {
        static var accountId = ""
        static var sessionId = ""
    }
    
    // MARK: EndPoints.
    enum EndPoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        static let baseLocation = base + "/StudentLocation"
        case createSession
        case logOut
        case getClientData
        case getClientsLocations
        case addPin
        case updatePin
        case signUP
        
        var stringValue: String{
            switch self {
            case .createSession, .logOut:
                return EndPoints.base + "/session"
            case .getClientData:
                return EndPoints.base + "/users/\(Auth.accountId)"
            case .getClientsLocations:
                return EndPoints.baseLocation + "?order=-updatedAt?limit=-100"
            case .addPin:
                return EndPoints.baseLocation
            case .updatePin:
                return EndPoints.baseLocation + "/\(ClientData.objectID)"
            case .signUP:
                return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Login Request.
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?)->Void){
        
        var request = URLRequest(url: EndPoints.createSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(userData: loginData(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        
        // Post Request.
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            guard let data = data else{
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
                return
            }
            // Result need to remove first 5 character to be able to JSON Decode it
            let newData = data.subdata(in: (5..<data.count))
            let decoder = JSONDecoder()
            do{
                let responseObject = try  decoder.decode(LoginTokenResponse.self, from: newData)
                Auth.accountId = responseObject.account.key
                Auth.sessionId = responseObject.session.id
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
                
            }
            catch{
                do{
                    // Parse it in ErrorResponse
                    let error = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completionHandler(false,error)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completionHandler(false,error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func logout(completionHandler: @escaping (Bool, Error?)->Void){
        var request = URLRequest(url: EndPoints.logOut.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard data != nil else{
              //cannot delete session
              DispatchQueue.main.async {
                  completionHandler(false, error)
              }
              return
          }
            DispatchQueue.main.async {
                completionHandler(true, nil)
            }
        }
        task.resume()
    }
    
    
    class func getClientData(completionHandler: @escaping (ClientDataResponse?, Error?) -> Void){
    
        let task = URLSession.shared.dataTask(with: EndPoints.getClientData.url) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let newData = data.subdata(in: (5..<data.count))
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ClientDataResponse.self, from: newData)
                DispatchQueue.main.async {
                        completionHandler(responseObject, nil)
                    }
                } catch {
                   DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
            task.resume()
    }
    
    class func getClientsLocations(completionHandler: @escaping (ClientsLocation?, Error?) -> Void){
    
        let task = URLSession.shared.dataTask(with: EndPoints.getClientsLocations.url) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
             let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ClientsLocation.self, from: data)
                DispatchQueue.main.async {
                        completionHandler(responseObject,nil)
                    }
                } catch {
                   DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
            task.resume()
    }
    
    // MARK: Post new Pin Request.
    class func postNewPin(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, Longitude: Double, completionHandler: @escaping (Bool, Error?)->Void){
        
        var request = URLRequest(url: EndPoints.addPin.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Encode StudentLocation to JSON and add it as Body
        let encoder = JSONEncoder()
        let requestBody = PostLocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: Longitude)
        let body = try! encoder.encode(requestBody)
        request.httpBody = body
        
        
        // Post Request.
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            guard let data = data else{
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try  decoder.decode(AddPinResponse.self, from: data)
                ClientData.objectID = responseObject.objectId
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
                
            }
            catch{
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
            }
            
        }
        task.resume()
    }
    
    class func PUTStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, Longitude: Double, completionHandler: @escaping (Bool, Error?)-> Void){
        
        let body = PostLocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: Longitude)
        let url = EndPoints.updatePin.url
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do{
            request.httpBody = try encoder.encode(body)
        }catch{
            //cannot convert to http body, throw error
            DispatchQueue.main.async {
                completionHandler(false, error)
            }
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) in
            guard let data = data else{
                //cannot fetch response, throw error
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
                return
            }
            do{
                //try fetching response
                _ = try JSONDecoder().decode(PUTNewLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }catch{
                //unable to parse response, throw error
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            }
        })
        task.resume()
    }
    
    
}
