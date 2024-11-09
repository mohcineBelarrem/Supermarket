//
//  SupermarketApp.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI
import SwiftData

@main
struct SupermarketApp: App {
    var body: some Scene {
        WindowGroup {
            APIStatusRouter.createModule()
        }
        .modelContainer(for: [UserPresentationModel.self])
    }
}
