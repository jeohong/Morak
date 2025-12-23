//
//  Post.swift
//  Morak
//
//  Created by Hong jeongmin on 11/3/25.
//

import Foundation

// MARK: - Post Entity (순수한 도메인 모델)
struct Post: Identifiable {
    let id: Int
    let nickname: String
    let content: String
    var likeCount: Int
    let commentCount: Int
    let viewCount: Int
    let createdAt: String
    let modifiedAt: String
    var likedByLoginUser: Bool
    let wroteByLoginUser: Bool

    var isLikedByMe: Bool {
        return likedByLoginUser
    }

    var isModified: Bool {
        return createdAt != modifiedAt
    }

    var formattedCreatedAt: String {
        return createdAt.formattedAsRelativeTime
    }

    // MARK: - Like State Management
    /// - Parameter serverResponse: 서버에서 받은 data 값 (null, true, false)
    mutating func updateLikeState(serverResponse: Bool?) {
        guard let newState = serverResponse else { return }

        let oldState = likedByLoginUser
        likedByLoginUser = newState

        if oldState != newState {
            if newState { likeCount += 1 }
            else { likeCount = max(0, likeCount - 1) }
        }
    }
}

// MARK: - Post List Response
struct PostListResponse {
    let content: [Post]
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let number: Int
    let first: Bool
    let last: Bool

    var hasNextPage: Bool {
        return !last
    }

    var isEmpty: Bool {
        return content.isEmpty
    }
}
