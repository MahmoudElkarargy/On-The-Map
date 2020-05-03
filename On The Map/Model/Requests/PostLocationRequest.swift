//
//  PostLocationRequest.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/3/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import Foundation
struct PostLocationRequest: Codable{
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
