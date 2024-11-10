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
                List {
                    ForEach(presenter.productCategories) { category in
                        Section(header: Text(category.name)) {
                            ForEach(category.products) { product in
                               NavigationLink {
                                   presenter.detailView(for: product,
                                                        modelContext: modelContext)
                                } label: {
                                    presenter.productView(for: product)
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            if presenter.productCategories.isEmpty {
                presenter.viewDidLoad()
            }
        }
    }
}

#Preview {
    let mockModelContainer = try! ModelContainer(for: UserPresentationModel.self)
    ProductListRouter.createModule(with: mockModelContainer.mainContext)
}
