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
        
        var stringValue: String{
            switch self {
            case .createSession:
                return EndPoints.base + "/session"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    // MARK: Login Request.
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?)->Void){
        
        print("Login ...")
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
                print("Eroorr")
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
                return
            }
            // Result need to remove first 5 character to be able to JSON Decode it
            let newData = data.subdata(in: (5..<data.count))
            let decoder = JSONDecoder()
            do{
                print("habden")
                let responseObject = try  decoder.decode(LoginTokenResponse.self, from: newData)
                Auth.accountId = responseObject.account.key
                Auth.sessionId = responseObject.session.id
                print(String(data: newData, encoding: .utf8)!)
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
                
            }
            catch{
                print("whu")
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
            }
            
        }
        task.resume()
    }
}
