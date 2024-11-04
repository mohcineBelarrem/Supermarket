//
//  CartView.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI

struct CartView: View {
    @StateObject var presenter: CartPresenter

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
                        List(cart.items) { item in
                            HStack {
                                Text("\(item.quantity)")
                                Spacer()
                                Text(item.label)
                                Spacer()
                                Button {
                                    presenter.deleteCartItem(with: item.id)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
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
        .alert("Oops", isPresented: $presenter.showAlert, actions: {
            Button("Ok", role: .cancel) {}
        }, message: {
            Text(presenter.alertMessage)
        })
        .padding()
        .onAppear {
            presenter.loadCart()
        }
    }
}

#Preview {
    CartRouter.createModule(with: TabController())
}
