//
//  Comment.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

// MARK: - Comment Entity (순수한 도메인 모델)
struct Comment: Identifiable, Equatable {
    let id: Int
    let content: String
    let nickname: String
    let userId: Int
    let postId: Int
    let parentId: Int?
    var likeCount: Int
    var likedByLoginUser: Bool
    let createdAt: String
    let modifiedAt: String
    let hasChildren: Bool
    let deleted: Bool

    var isLikedByMe: Bool {
        return likedByLoginUser
    }

    var isModified: Bool {
        return createdAt != modifiedAt
    }

    var isRootComment: Bool {
        return parentId == nil
    }

    var formattedCreatedAt: String {
        return createdAt.formattedAsRelativeTime
    }

    // MARK: - Like State Management
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

// MARK: - Comment List Response
struct CommentListResponse {
    let content: [Comment]
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
