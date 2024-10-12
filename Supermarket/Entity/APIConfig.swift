//
//  APIConfig.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Foundation

struct APIConfig {
    static let baseURL = "https://simple-grocery-store-api.glitch.me"
    
    // Endpoints for different API calls
    enum Endpoint: String {
        case apiStatus = "/status"
        case products = "/products"
    }
    
    // Utility function to create full URL for a given endpoint
    static func url(for endpoint: Endpoint) -> URL? {
        return URL(string: baseURL + endpoint.rawValue)
    }
}
