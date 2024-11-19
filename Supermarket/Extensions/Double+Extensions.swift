//
//  Double+Extension.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

extension Double {
    var formattedPrice: String {
        return  String(format: "$%.2f", self)
    }
}
