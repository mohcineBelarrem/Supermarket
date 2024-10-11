//
//  SupermarketApp.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI

@main
struct SupermarketApp: App {
    var body: some Scene {
           WindowGroup {
               TabView {
                   ProductListRouter.createModule()
                       .tabItem {
                           Label("Products", systemImage: "cart")
                       }
               }
           }
       }
}
