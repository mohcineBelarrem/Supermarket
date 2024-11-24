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
            VStack {
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
                                    presenter.routeToOrderItemView(for: orderItem)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                }
                                .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.background)
                        }
                    }
                } else {
                    GoToLoginButton(title: "You must be logged in to see orders") {
                        //TODO: Redirect to Login
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
        .task {
            presenter.viewDidLoad()
        }
    }
}


