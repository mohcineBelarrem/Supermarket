//
//  LoginView.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var presenter: LoginPresenter
    @State private var username: String = ""
    @State private var email: String = ""

    var body: some View {
        VStack {
            if let accessToken = presenter.accessToken {
                presenter.profileView(for: .init(username: username,
                                                 email: email,
                                                 accessToken: accessToken))
            } else {
                
                if presenter.isLoading {
                    ProgressView("Verifying Credentials..")
                } else if let errorMessage = presenter.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Login") {
                        presenter.login(username: username, email: email)
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

#Preview {
    let interactor = LoginInteractor()
    let router = LoginRouter()
    let presenter = LoginPresenter(interactor: interactor, router: router)
    
    LoginView(presenter: presenter)
}
