//
//  getClientDataRequest.swift
//  On The Map
//
//  Created by Mahmoud Elkarargy on 5/2/20.
//  Copyright © 2020 Mahmoud Elkarargy. All rights reserved.
//

import Foundation

struct ClientDataResponse: Codable {
    
    let lastName: String?
    let socialAccounts: [String?]
    let mailingAddress: String?
    let cohortKeys: [String?]
    let signature: String?
    let stipeCustomerID: String?
    let guardData: [String:String?]
    let facebookID: String?
    let timezone: String?
    let sitePerferences: String?
    let occupation: String?
    let image: String?
    let firstName: String?
    let jabberID: String?
    let languages: String?
    let badges: [String?]
    let location: String?
    let externalServicePassword: String?
    let principals: [String?]
    let enrollments: [String?]
    let email: Email
    let websiteURL: String?
    let externalAccounts: [String?]
    let bio: String?
    let coachingData: String?
    let tags: [String?]
    let affliateProfiles: [String?]
    let hasPassword: Bool
    let emailPreferences: String?
    let resume: String?
    let key: String?
    let nickname: String?
    let employerSharing: Bool
    let memberships: [String?]
    let zendeskID: String?
    let registered: Bool
    var linkedinUrl: String?
    let googleID: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey{
        
        case lastName = "last_name"
        case socialAccounts = "social_accounts"
        case mailingAddress = "mailing_address"
        case cohortKeys = "_cohort_keys"
        case signature = "signature"
        case stipeCustomerID = "_stripe_customer_id"
        case guardData = "guard"
        case facebookID = "_facebook_id"
        case timezone = "timezone"
        case sitePerferences = "site_preferences"
        case occupation = "occupation"
        case image = "_image"
        case firstName = "first_name"
        case jabberID = "jabber_id"
        case languages = "languages"
        case badges = "_badges"
        case location = "location"
        case externalServicePassword = "external_service_password"
        case principals =  "_principals"
        case enrollments = "_enrollments"
        case email = "email"
        case websiteURL = "website_url"
        case externalAccounts = "external_accounts"
        case bio = "bio"
        case coachingData = "coaching_data"
        case tags = "tags"
        case affliateProfiles = "_affiliate_profiles"
        case hasPassword = "_has_password"
        case emailPreferences = "email_preferences"
        case resume = "_resume"
        case key = "key"
        case nickname = "nickname"
        case employerSharing = "employer_sharing"
        case memberships = "_memberships"
        case zendeskID = "zendesk_id"
        case registered = "_registered"
        case linkedinUrl = "linkedin_url"
        case googleID = "_google_id"
        case imageURL = "_image_url"
    }
    
    
}

struct Email: Codable {
    let verificationCode: Bool
    let verified: Bool
    let emailAddress: String
    
    enum CodingKeys: String, CodingKey{
        case verificationCode = "_verification_code_sent"
        case verified = "_verified"
        case emailAddress = "address"
    }
}

