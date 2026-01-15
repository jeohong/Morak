//
//  PostDTO.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation

// MARK: - Post List Request
struct PostListRequest: Codable {
    let page: Int
    let size: Int
    let sortBy: String

    enum CodingKeys: String, CodingKey {
        case page
        case size
        case sortBy
    }
}

// MARK: - Post DTO (API 응답 구조)
struct PostDTO: Codable {
    let id: Int
    let writerId: Int
    let nickname: String
    let content: String
    let likeCount: Int
    let commentCount: Int
    let viewCount: Int
    let createdAt: String
    let modifiedAt: String
    let likedByLoginUser: Bool
    let wroteByLoginUser: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case writerId
        case nickname
        case content
        case likeCount
        case commentCount
        case viewCount
        case createdAt
        case modifiedAt
        case likedByLoginUser
        case wroteByLoginUser
    }
}

// MARK: - Post List Response DTO
struct PostListResponseDTO: Codable {
    let content: [PostDTO]
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
