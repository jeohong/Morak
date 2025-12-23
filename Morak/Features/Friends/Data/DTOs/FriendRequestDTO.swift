//
//  FriendRequestDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

// MARK: - Friend Request DTO
struct FriendRequestDTO: Codable {
    let requestId: Int
    let senderId: Int
    let senderNickname: String
    let senderEmail: String
    let receiverId: Int
    let receiverNickname: String
    let receiverEmail: String
    let status: String
    let createdAt: String
}
