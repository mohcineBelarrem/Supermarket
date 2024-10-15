//
//  AddToCartButton.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI

struct AddToCartButton: View {
    @ObservedObject var presenter: AddToCartPresenter
    var product: ProductPresentationModel
    var body: some View {
        Button {
            print("Buying \(product.name)")
        } label: {
            
            HStack(alignment: .center) {
                
                if presenter.isLoading {
                    ProgressView(" ")
                } else if let _ = presenter.errorMessage {
                    Text("")
                } else {
                    if let quantity = presenter.productQuantityInCart, quantity > 0 {
                        Text("\(quantity)")
                    } else {
                        Image(systemName: "cart")
                    }
                }
            }
            .frame(width: 24, height: 24)
            .padding(10)
            .background(presenter.isButtonEnabled ? .green : .gray)
            .foregroundStyle(.white)
            //.font(.system(size: 20, weight: .bold))
            .cornerRadius(8)
        }
        .disabled(!presenter.isButtonEnabled)
        .onAppear {
            presenter.getProductQuantityInCart(for: product)
        }
    }
}

#Preview {
    AddToCartRouter.createModule(with: .init(id: 1709, name: "Some Product", category: "Category", inStock: true))
}
