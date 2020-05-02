//
//  UdacityClient.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import Foundation

class UdacityClient{
    struct Auth {
        static var accountId = ""
        static var sessionId = ""
    }
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
    
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType:
        Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encoding a JSON body from a string
        let encoder = JSONEncoder()
        do{
            request.httpBody = try encoder.encode(body)
        }catch{
            //cannot convert to http body, throw error
            DispatchQueue.main.async {
                completionHandler(nil, error)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data,response,error) in
            guard let data = data else{
            //cannot fetch response, throw server error
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) // subset response data!
            print("Login......")
            print(String(data: newData, encoding: .utf8)!)
        })
        task.resume()
    }
    
    
    
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(userData: data(username: username, password: password))
        
        taskForPOSTRequest(url: EndPoints.createSession.url, responseType: LoginRequest.self, body: body, completionHandler: { (response, error) in
            if let response = response{
                //safely unwrapped response so login successfull
                completionHandler(true, nil)
            }else{
                //unable to login throw error
                completionHandler(false, error)
            }
        })
        
    }
}
