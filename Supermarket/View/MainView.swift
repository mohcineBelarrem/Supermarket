//
//  MainView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI
import SwiftData


//TODO: Add presenter for this view
//The presenter should fetch the number for the badge

struct MainView: View {
    @StateObject var presenter: MainPresenter
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView(selection: $presenter.selectedTab) {
            ProductListRouter.createModule(with: modelContext)
                .tabItem {
                    Label("Products", systemImage: "list.bullet")
                }
                .tag(Tab.productList)
            
                LoginRouter.createModule(with: modelContext)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(Tab.login)
            
            CartRouter.createModule(with: presenter, modelContext: modelContext)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .tag(Tab.cart)
                .badge(presenter.numberOfProducts ?? 0)
        }
        .navigationBarBackButtonHidden(true)
        .task {
            presenter.viewDidLoad()
        }
    }
}

//#Preview {
//    MainView()
//}
