//
//  AddToCartButton.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI

struct CartButton: View {
    @ObservedObject var presenter: CartButtonPresenter
    var product: ProductPresentationModel
    @State private var isShowingModal = false
    var body: some View {
        Button {
            print("Buying \(product.name)")
            isShowingModal.toggle()
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
            .sheet(isPresented: $isShowingModal) {
                EmptyView()
                    .presentationDetents([.medium])
            }
        }
        .disabled(!presenter.isButtonEnabled)
        .onAppear {
            presenter.getProductQuantityInCart(for: product)
        }
    }
}

#Preview {
    CartButtonRouter.createModule(with: ProductPresentationModel.dummyProduct)
}
