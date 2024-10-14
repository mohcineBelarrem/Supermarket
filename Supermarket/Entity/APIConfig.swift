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
        case userRegistration
        case createCart
        case getCartItems(String)
        
        var rawValue: String {
            switch self {
            case .apiStatus: return "/status"
            case .products: return "/products"
            case .productDetail(let id): return "/products/\(id)"
            case .userRegistration: return "/api-clients"
            case .createCart: return "/carts"
            case .getCartItems(let id): return "/carts/\(id)/items"
            }
        }
    }
    
    // Utility function to create full URL for a given endpoint
    static func url(for endpoint: Endpoint) -> URL? {
        return URL(string: baseURL + endpoint.rawValue)
    }
}
