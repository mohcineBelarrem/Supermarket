//
//  CartItemView.swift
//  Supermarket
//
//  Created by Mohcine on 19/11/2024.
//

import SwiftUI

struct CartItemView: View {
    let item: CartItemPresentationModel
    
    var body: some View {
        Text(item.product.name)
            .font(.system(size: 14, weight: .semibold))
        Spacer()
        VStack(alignment: .trailing) {
            Text(item.totalFormattedPrice)
                .foregroundStyle(Color.green)
                .font(.system(size: 14, weight: .semibold))
            Text(item.detailledPrice)
                .font(.system(size: 14))
        }
    }
}

#Preview {
    CartItemView(item: .init(id: 123232, productId: 1212321, quantity: 1378, product: .dummyProduct))
}
