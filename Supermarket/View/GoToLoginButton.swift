//
//  GoToLoginButton.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//

import SwiftUI

struct GoToLoginButton: View {
    let title: String
    let buttonAction: () -> Void
    var body: some View {
        Text(title)
        Button {
            buttonAction()
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


#Preview {
    GoToLoginButton(title: "Sir L login") {
        print("Sir")
    }
}
