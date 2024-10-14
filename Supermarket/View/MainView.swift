//
//  MainView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var tabController = TabController()
    var body: some View {
        TabView(selection: $tabController.selectedTab) {
            ProductListRouter.createModule()
                .tabItem {
                    Label("Products", systemImage: "list.bullet")
                }
                .tag(TabController.Tab.productList)
            
            LoginRouter.createModule()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(TabController.Tab.login)
            
            CartRouter.createModule(with: tabController)
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
