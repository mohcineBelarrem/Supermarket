//
//  TabController.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI

class TabController: ObservableObject {
    @Published var selectedTab: Tab = .productList
    
    enum Tab {
        case cart
        case login
        case productList
    }

    func switchToLoginTab() {
        selectedTab = .login
    }
    
    func switchToCartTab() {
        selectedTab = .cart
    }
    
    func switchToProductListTab() {
        selectedTab = .productList
    }
}
