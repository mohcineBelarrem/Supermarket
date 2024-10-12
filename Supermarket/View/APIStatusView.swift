//
//  APIStatusView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI

struct APIStatusView: View {
    @ObservedObject var presenter: APIStatusPresenter

    var body: some View {
        VStack {
            if let currentView = presenter.currentView {
                currentView 
            } else if let error = presenter.errorMessage {
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
    }
}

#Preview {
    let interactor = APIStatusInteractor()
    let router = APIStatusRouter()
    let presenter = APIStatusPresenter(interactor: interactor, router: router)
    
    APIStatusView(presenter: presenter)
}
