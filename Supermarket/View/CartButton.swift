//
//  AddToCartButton.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI

struct CartButton: View {
    @ObservedObject var presenter: CartButtonPresenter
    var product: ProductDetailPresentationModel
    @State private var isShowingModal = false
    var body: some View {
        Button {
            print("Buying \(product.name)")
            isShowingModal.toggle()
        } label: {
            
            HStack(alignment: .center) {
                
                if let quantity = presenter.productQuantityInCart, quantity > 0 {
                    Text("\(quantity)")
                } else {
                    Image(systemName: "cart")
                }
                
            }
            .frame(width: 24, height: 24)
            .padding(10)
            .background(presenter.isButtonEnabled(for: product) ? .green : .gray)
            .foregroundStyle(.white)
            .cornerRadius(8)
            .sheet(isPresented: $isShowingModal) {
                AddToCartViewRouter.createModule(with: product)
                    .foregroundStyle(.black)
                    .presentationDetents([.medium])
            }
        }
        .disabled(!presenter.isButtonEnabled(for: product))
        .onAppear {
            presenter.subscribeForQuantity(for: product)
        }
    }
}

#Preview {
    CartButtonRouter.createModule(with: ProductDetailPresentationModel.dummyProduct)
}
