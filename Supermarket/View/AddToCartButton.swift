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
    @State var shouldBeDisabled: Bool = false
    var body: some View {
        Button {
            print("Buying \(product.name)")
        } label: {
            
            HStack(alignment: .center) {
                
                if let _ = presenter.errorMessage {
                    Text("")
                } else if let quantity = presenter.productQuantityInCart {
                    if quantity > 0 {
                        Text("\(quantity)")
                    } else {
                        Image(systemName: "cart")
                    }
                    
                } else {
                    ProgressView("")
                }
            }
            .frame(width: 24, height: 24)
            .padding(10)
            .background(product.inStock ? .green : .gray)
            .foregroundStyle(.white)
            //.font(.system(size: 20, weight: .bold))
            .cornerRadius(8)
        }
        .disabled(!product.inStock)
        .onAppear {
            presenter.getProductQuantityInCart(for: product.id)
        }
    }
}

#Preview {
    AddToCartRouter.createModule(with: .init(id: 1709, name: "Some Product", category: "Category", inStock: true))
}
