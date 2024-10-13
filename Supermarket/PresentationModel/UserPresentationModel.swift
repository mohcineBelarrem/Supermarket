//
//  UserPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import Foundation

struct UserPresentationModel {
    let username: String
    let email: String
    let accessToken: String
}

enum UserPresentationModelKeys: String {
    typealias RawValue = String
    case username
    case email
    case accessToken
}
