//
//  ClientData.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

struct ClientData {
    static var currentClientData: ClientDataResponse?
    static var ClientsDataLocations = [ClientsData]()
    static var objectID = ""
    static var postLocation = ""
    static var postLatitude: Double?
    static var postLongitude: Double?
    static var postWebsite = ""
}
