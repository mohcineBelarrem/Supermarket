//
//  CartPublisher.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

import Combine
import Foundation

class UserDefaultsPublisher<T: Codable> {
    private let userDefaults: UserDefaults
    private let key: String
    
    init(userDefaults: UserDefaults = .standard, key: String) {
        self.userDefaults = userDefaults
        self.key = key
    }

    var publisher: AnyPublisher<T?, Never> {
        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification, object: userDefaults)
            .map { [weak self] _ in
                return self?.userDefaults.getObject(forKey: self?.key ?? "", as: T.self)
            }
            .eraseToAnyPublisher()
    }
    
    func save(_ object: T) {
        userDefaults.save(object, forKey: key)
    }
    
    // Retrieve the latest value from UserDefaults
    func getLatestValue() -> T? {
        return userDefaults.getObject(forKey: key, as: T.self)
    }
}
