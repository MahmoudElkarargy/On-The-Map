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
        
        case createSession
        case logOut
        var stringValue: String{
            switch self {
            case .createSession, .logOut:
                return EndPoints.base + "/session"
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
                print(String(data: newData, encoding: .utf8)!)
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
}
