//
//  GoToProductsButton.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//

import SwiftUI

struct GoToProductsButton: View {
    let title: String
    let buttonAction: () -> Void
    var body: some View {
        Text(title)
        Button {
            buttonAction()
        } label: {
            Text("Shop")
        }
        .padding()
        .background(.green)
        .foregroundStyle(.white)
        .font(.system(size: 20, weight: .bold))
        .cornerRadius(8)
    }
}

#Preview {
    GoToProductsButton(title: "Sir L products") {
        print("Sir")
    }
}
