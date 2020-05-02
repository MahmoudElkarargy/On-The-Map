//
//  StudentLocation.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import Foundation

struct ClientsLocation: Codable{
    let results: [ClientsData]
}

struct ClientsData: Codable {
    let firstName: String
    let lastName: String
    let longitude: Float
    let latitude: Float
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}
