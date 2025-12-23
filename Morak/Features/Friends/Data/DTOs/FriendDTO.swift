//
//  FriendDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

// MARK: - Friend DTO
struct FriendDTO: Codable {
    let friendId: Int
    let userId: Int
    let nickname: String
    let email: String
}
