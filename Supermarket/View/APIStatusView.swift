//
//  APIStatusView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI

struct APIStatusView: View {
    @StateObject var presenter: APIStatusPresenter

    var body: some View {
        NavigationStack {
            VStack {
                if let error = presenter.errorMessage {
                    Text("API is down: \(error)")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Button("Retry") {
                        presenter.checkAPIStatus()
                    }
                } else {
                    ProgressView("Checking API status...")
                        .onAppear {
                            presenter.checkAPIStatus()
                        }
                }
            }
            .navigationDestination(isPresented: $presenter.shouldNavigateToMainView) {
                presenter.mainView
            }
        }
    }
}

#Preview {
    APIStatusRouter.createModule()
}
