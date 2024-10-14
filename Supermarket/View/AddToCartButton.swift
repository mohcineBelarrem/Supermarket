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
            Image(systemName: "cart")
                .frame(width: 24, height: 24)
                .padding(10)
                .background(product.inStock ? .green : .gray)
                .foregroundStyle(.white)
                //.font(.system(size: 20, weight: .bold))
                .cornerRadius(8)
                
                
        }
        .disabled(!product.inStock)
    }
}

#Preview {
    let interactor = AddToCartInteractor()
    let router = AddToCartRouter()
    let presenter = AddToCartPresenter(interactor: interactor, router: router)
    let product: ProductPresentationModel = .init(id: 1709,
                                                  name: "Some Product",
                                                  category: "Some Category",
                                                  inStock: true,
                                                  availability: "")
    AddToCartButton(presenter: presenter, product: product)
}
