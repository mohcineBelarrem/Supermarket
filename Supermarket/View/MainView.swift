//
//  MainView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @ObservedObject var tabController = TabController()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView(selection: $tabController.selectedTab) {
            ProductListRouter.createModule(with: modelContext)
                .tabItem {
                    Label("Products", systemImage: "list.bullet")
                }
                .tag(TabController.Tab.productList)
            
                LoginRouter.createModule(with: modelContext)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(TabController.Tab.login)
            
            CartRouter.createModule(with: tabController, modelContext: modelContext)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .tag(TabController.Tab.cart)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
