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
            if let user = presenter.user {
                presenter.profileView(for: user)
                
                Button(action: {
                    presenter.logout()
                }, label: {
                    Text("Logout")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .bold))
                        .cornerRadius(8)
                })
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
