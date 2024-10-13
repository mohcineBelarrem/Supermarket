//
//  ProfileView.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import SwiftUI

struct ProfileView: View {
    var user: UserPresentationModel
    var body: some View {
        NavigationView {
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
                VStack(alignment: .leading, content: {
                    Text(user.username)
                    Text(user.email)
                })
            }
            
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: .init(username: "Hamid", email: "Hamid@free.com", accessToken: "asdasd"))
}