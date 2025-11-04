//
//  User.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation

// MARK: - User Model
struct User: Codable, Equatable {
    let id: String
    let email: String
    let nickname: String
}
