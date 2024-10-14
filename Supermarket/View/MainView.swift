//
//  MainView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ProductListRouter.createModule()
                .tabItem {
                    Label("Products", systemImage: "list.bullet")
                }
            
            LoginRouter.createModule()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            
            CartRouter.createModule()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
