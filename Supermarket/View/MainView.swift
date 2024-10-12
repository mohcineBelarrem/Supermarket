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
            
            Text("My Cart")
                .tabItem {
                    Label("My Cart", systemImage: "cart")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
