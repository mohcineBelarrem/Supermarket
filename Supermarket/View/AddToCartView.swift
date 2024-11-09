//
//  AddToCartView.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

import SwiftUI
import SwiftData

struct AddToCartView: View {
    @StateObject var presenter: AddToCartViewPresenter
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
                presenter.buttonPressed(for: product)
            } label: {
                if presenter.isLoading {
                    ProgressView("")
                } else if presenter.errorMessage != nil {
                    Text("")
                } else {
                    Text(presenter.buttonText)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.green)
            .foregroundStyle(.white)
            .font(.system(size: 20, weight: .bold))
            .cornerRadius(8)
            .disabled(!presenter.isButtonEnabbled)
        }
        .padding(20)
        .onAppear {
            presenter.viewDidLoad(with: product)
        }
    }
}

#Preview {
    let mockModelContainer = try! ModelContainer(for: UserPresentationModel.self)
    AddToCartViewRouter.createModule(with: ProductDetailPresentationModel.dummyProduct,
                                     modelContext: mockModelContainer.mainContext)
}
