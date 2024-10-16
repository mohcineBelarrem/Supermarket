//
//  AddToCartView.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

import SwiftUI

struct AddToCartView: View {
    @ObservedObject var presenter: AddToCartViewPresenter
    var product: ProductDetailPresentationModel
   
    var range: ClosedRange<Int> {
        1...product.currentStock
    }
    
    var body: some View {
        VStack (alignment: .center) {
            Text("\(product.name)")
            
            HStack {
                Spacer()
                
                VStack() {
                    Stepper(value: $presenter.quantity,
                            in: presenter.quantityRange(for: product),
                            step: 1) { }
                        .fixedSize()
                        .padding(40)
                    Text("\(presenter.quantity)")
                        .padding(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        
                }
                
                Spacer()
            }
            
            
            
            Spacer()
            
            HStack() {
                Text("Total Price")
                Spacer()
                Text(presenter.totalFormattedPrice(for: product))
            }
            .padding(.bottom, 20)
            
            Button {
                
            } label: {
                Text("Add to cart")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.green)
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .bold))
                    .cornerRadius(8)
            }
        }
        .padding(20)
    }
}

#Preview {
    AddToCartViewRouter.createModule(with: ProductDetailPresentationModel.dummyProduct)
}
