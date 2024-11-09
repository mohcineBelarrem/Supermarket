//
//  AddToCartButton.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI
import SwiftData

struct CartButton: View {
    @StateObject var presenter: CartButtonPresenter
    var product: ProductDetailPresentationModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Button {
            presenter.isShowingAddToCartView.toggle()
        } label: {
            
            HStack(alignment: .center) {
                
                if let quantity = presenter.productQuantityInCart, quantity > 0 {
                    Text("\(quantity)")
                } else if presenter.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "cart")
                }
                
            }
            .frame(width: 24, height: 24)
            .padding(10)
            .background(presenter.isButtonEnabled(for: product) ? .green : .gray)
            .foregroundStyle(.white)
            .cornerRadius(8)
            .sheet(isPresented: $presenter.isShowingAddToCartView) {
                AddToCartViewRouter.createModule(with: product,
                                                 modelContext: modelContext)
                    .foregroundStyle(.black)
                    .presentationDetents([.medium])
            }
        }
        .disabled(!presenter.isButtonEnabled(for: product))
        .onAppear {
            presenter.fetchQuantity(for: product)
        }
    }
}

#Preview {
    let mockModelContainer = try! ModelContainer(for: UserPresentationModel.self)
    CartButtonRouter.createModule(with: ProductDetailPresentationModel.dummyProduct,
                                  modelContext: mockModelContainer.mainContext)
}
