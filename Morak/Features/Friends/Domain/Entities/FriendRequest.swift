//
//  FriendRequest.swift
//  Morak
//
//  Created by Hong jeongmin on 11/27/25.
//

import Foundation

struct FriendRequest: Identifiable, Equatable {
    let id: Int
    let nickname: String
    let requestedAt: Date
}
