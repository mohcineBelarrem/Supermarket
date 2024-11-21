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
                        GoToProductsButton(title: "Your cart is empty.") {
                            presenter.goToProductList()
                        }
                    } else {
                        ScrollView {
                            ForEach(presenter.cartItems) { (item: CartItemPresentationModel) in
                                HStack {
                                    presenter.cartItemView(for: item)
                                    presenter.cartButton(for: item.product,
                                                         modelContext: modelContext)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                        Spacer()
                        if let totalFormattedPrice = presenter.totalFormattedPrice {
                            Text("Total: \(totalFormattedPrice)")
                        }
                        Button(action: {
                            presenter.makeOrder()
                        }, label: {
                            Text("Order Items")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.darkGreen)
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .bold))
                                .cornerRadius(8)
                        })
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
                GoToLoginButton(title: "You must be logged in to see the cart.") {
                    presenter.goToLogin()
                }
            }
        }
        .alert("Oops", isPresented: $presenter.showAlert, actions: {
            Button("Ok", role: .cancel) {}
        }, message: {
            Text(presenter.alertMessage)
        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
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

