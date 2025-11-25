//
//  CommentDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

// MARK: - Comment List Request
struct CommentListRequest: Codable {
    let postId: Int
    let page: Int
    let size: Int
    let sortBy: String

    enum CodingKeys: String, CodingKey {
        case postId
        case page
        case size
        case sortBy
    }
}

// MARK: - Reply List Request
struct ReplyListRequest: Codable {
    let parentId: Int
    let page: Int
    let size: Int

    enum CodingKeys: String, CodingKey {
        case parentId
        case page
        case size
    }
}

// MARK: - Create Comment Request
struct CreateCommentRequest: Codable {
    let postId: Int
    let content: String
    let parentId: Int?

    enum CodingKeys: String, CodingKey {
        case postId
        case content
        case parentId
    }
}

// MARK: - Update Comment Request
struct UpdateCommentRequest: Codable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content
    }
}

// MARK: - Comment DTO (API 응답 구조)
struct CommentDTO: Codable {
    let id: Int
    let content: String
    let nickname: String
    let userId: Int
    let postId: Int
    let parentId: Int?
    let likeCount: Int
    let likedByLoginUser: Bool
    let createdAt: String
    let modifiedAt: String
    let hasChildren: Bool
    let deleted: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case nickname
        case userId
        case postId
        case parentId
        case likeCount
        case likedByLoginUser
        case createdAt
        case modifiedAt
        case hasChildren
        case deleted
    }
}

// MARK: - Comment List Response DTO
struct CommentListResponseDTO: Codable {
    let content: [CommentDTO]
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let number: Int
    let first: Bool
    let last: Bool

    enum CodingKeys: String, CodingKey {
        case content
        case totalPages
        case totalElements
        case size
        case number
        case first
        case last
    }
}
