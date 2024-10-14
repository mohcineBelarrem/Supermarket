//
//  CartView.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var presenter: CartPresenter

    var body: some View {
        VStack {
            if presenter.isUserLoggedIn {
                if let cart = presenter.cart {
                    if cart.isEmpty {
                        Text("Your cart is empty.")
                        Button {
                            presenter.goToProductList()
                        } label: {
                            Text("Shop")
                        }
                        .padding()
                        .background(.green)
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .bold))
                        .cornerRadius(8)
                    } else {
                        List(cart) { item in
                            Text("ProductId:\(item.productId) Quantity:\(item.quantity)")
                        }
                    }
                } else if let errorMessage = presenter.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Loading cart...")
                        .padding()
                }
            } else {
                Text("You must be logged in to see the cart.")
                Button {
                    presenter.goToLogin()
                } label: {
                    Text("Go to Login")
                }
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .bold))
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            presenter.loadCart()
        }
    }
}

#Preview {
    let loginInteractor = LoginInteractor()
    let interactor = CartInteractor(loginInteractor: loginInteractor)
    let tabController = TabController()
    let router = CartRouter(tabController: tabController)
    let presenter = CartPresenter(interactor: interactor, router: router)
    
    CartView(presenter: presenter)
}
