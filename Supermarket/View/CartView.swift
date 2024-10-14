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
            if let cart = presenter.cart {
                List(cart) { item in
                    Text("ProductId:\(item.productId) Quantity:\(item.quantity)")
                }
                .navigationTitle("My Cart")
            } else if let errorMessage = presenter.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("Loading cart...")
                    .padding()
            }
        }
        .onAppear {
            presenter.loadCart()
        }
    }
}
