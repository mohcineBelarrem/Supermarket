//
//  UserPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import SwiftData

@Model
class UserPresentationModel {
    var username: String
    var email: String
    var accessToken: String
    
    static var dummyUser: UserPresentationModel {
        UserPresentationModel(username: "hamid", email: "hamid@free.com", accessToken: "12345")
    }
    
    init(username: String, email: String, accessToken: String) {
        self.username = username
        self.email = email
        self.accessToken = accessToken
    }
}
