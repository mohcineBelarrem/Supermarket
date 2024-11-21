//
//  OrderListView.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//


import SwiftUI
import Combine

struct OrderListView: View {
    @StateObject var presenter: OrderListPresenter
    
    var body: some View {
        NavigationView {
            if presenter.isUserLoggedIn {
                if let error = presenter.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else if presenter.isLoading {
                    ProgressView("Loading...")
                } else {
                    if presenter.orders.isEmpty  {
                        GoToProductsButton(title: "Your orders are empty.") {
                            //TODO: Redirect to productList
                        }
                    } else {
                        ScrollView{
                            ForEach(presenter.orders, id: \.orderId) { orderItem in
                                Text(orderItem.orderId)
                            }
                            .foregroundColor(.black)
                        }
                        
                    }
                }
            } else {
                GoToLoginButton(title: "You must be logged in to see orders") {
                    //TODO: Redirect to Login
                }
            }
        }
        .task {
            presenter.viewDidLoad()
        }
    }
}


