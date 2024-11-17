//
//  CartView.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI
import SwiftData

struct CartView: View {
    @StateObject var presenter: CartPresenter
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            if presenter.isUserLoggedIn {
                if let cart = presenter.cart {
                    if cart.items.isEmpty {
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
                        List(presenter.cartItems) { (item: CartItemPresentationModel) in
                            HStack {
                                Text(item.product.name)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(item.totalFormattedPrice)
                                        .foregroundStyle(Color.darkGreen)
                                        .font(.system(size: 14, weight: .semibold))
                                    Text(item.detailledPrice)
                                        .font(.system(size: 14))
                                }
                                CartButtonRouter.createModule(with: item.product, modelContext: modelContext)
                            }
                        }
                        if let totalFormattedPrice = presenter.totalFormattedPrice {
                            Text("Total: \(totalFormattedPrice)")
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
            presenter.viewDidLoad()
        }
    }
}

//#Preview {
//    let mockModelContainer = try! ModelContainer(for: UserPresentationModel.self)
//    CartRouter.createModule(with: TabController(),
//                            modelContext: mockModelContainer.mainContext)
//}

extension Color {
    static var darkGreen: Color {
        .init(red: 0, green: 85.0/255, blue: 20.0/255)
    }
}
