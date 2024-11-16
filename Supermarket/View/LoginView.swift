//
//  LoginView.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @ObservedObject var presenter: LoginPresenter
    @State private var username: String = ""
    @State private var email: String = ""
    
    @Environment(\.modelContext) private var modelContext

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
                Spacer()
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
    let mockModelContainer = try! ModelContainer(for: UserPresentationModel.self)
    LoginRouter.createModule(with: mockModelContainer.mainContext)
}
