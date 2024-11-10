//
//  UserProfileService.swift
//  Supermarket
//
//  Created by Mohcine on 8/11/2024.
//

import Foundation
import SwiftData

protocol UserProfileServiceProtocol {
    func fetchUser() -> UserPresentationModel?
    func saveUser(_ user: UserPresentationModel)
    func deleteUser()
}

class UserProfileService: UserProfileServiceProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchUser() -> UserPresentationModel? {
        let predicate = #Predicate<UserPresentationModel> { _ in true }
        let descriptor = FetchDescriptor(predicate: predicate)
        let result = try? modelContext.fetch(descriptor)
        return result?.first
    }
    
    func saveUser(_ user: UserPresentationModel) {
        modelContext.insert(user)
    }
    
    func deleteUser() {
        if let user = fetchUser() {
            modelContext.delete(user)
        }
    }
}
