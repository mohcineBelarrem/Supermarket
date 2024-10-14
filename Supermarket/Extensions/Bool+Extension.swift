//
//  Bool+Extension.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

extension Bool {
    var availability : String {
        self ? "In stock" : "Out of stock"
    }
}
