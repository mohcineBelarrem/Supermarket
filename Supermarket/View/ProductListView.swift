//
//  ProductListView.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI
import SwiftData

struct ProductListView: View {
    @StateObject var presenter: ProductListPresenter
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            if let error = presenter.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else if presenter.productCategories.isEmpty {
                ProgressView("Loading...")
            } else {
                ScrollView{
                    ForEach(presenter.productCategories) { category in
                        presenter.categoryView(for: category)
                        ForEach(category.products) { product in
                            NavigationLink {
                                presenter.detailView(for: product, modelContext: modelContext)
                            } label: {
                                HStack() {
                                    presenter.productView(for: product)
                                    Spacer()
                                    if presenter.isUserLoggedIn {
                                        presenter.cartButton(for: product, modelContext: modelContext)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            .foregroundColor(.black)
                        }
                    }
                    Spacer()
                        .frame(height: 20)
                }
                .padding()
                .background(Color.background)
            }
        }
        .task {
            presenter.viewDidLoad()
        }
    }
}

#Preview {
    let mockModelContainer = try! ModelContainer(for: UserPresentationModel.self)
    ProductListRouter.createModule(with: mockModelContainer.mainContext)
}
