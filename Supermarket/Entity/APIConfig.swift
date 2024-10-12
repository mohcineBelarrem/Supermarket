//
//  APIConfig.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Foundation

struct APIConfig {
    static let baseURL = "https://simple-grocery-store-api.glitch.me"
    
    enum Endpoint {
        case apiStatus
        case products
        case productDetail(Int)
        
        var rawValue: String {
            switch self {
            case .apiStatus: return "/status"
            case .products: return "/products"
            case .productDetail(let id): return "/products/\(id)"
            }
        }
    }
    
    // Utility function to create full URL for a given endpoint
    static func url(for endpoint: Endpoint) -> URL? {
        return URL(string: baseURL + endpoint.rawValue)
    }
}
